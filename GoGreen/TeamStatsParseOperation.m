//
//  TeamStatsParseOperation.m
//  GoGreen
//
//  Created by admin mac on 11/19/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import "TeamStatsParseOperation.h"
#import "SportsDataConstants.h"
#import "TeamStatsParserConstants.h"
#import "Player+Create.h"
#import "PlayerStatistics+Create.h"
#import "TeamStatistics+Create.h"
#import "Team.h"
#import <CoreData/CoreData.h>

@interface TeamStatsParseOperation () <NSXMLParserDelegate>
@property (nonatomic, strong) NSXMLParser *teamStatsParser;
@property (nonatomic, strong) NSMutableData *teamStatsData;
@property (nonatomic) TeamStatisticType currentStatistic;
@property (nonatomic) BOOL isParsingSeasonStatsElem;
@property (nonatomic) BOOL isParsingTeamElem;
@property (nonatomic) BOOL isParsingStatsElem;
@property (nonatomic) BOOL isParsingPlayerElem;
@property (nonatomic, strong) PlayerStatistics *currentPlayerStatistics;
@property (nonatomic, strong) TeamStatistics *currentTeamStatistics;
@property (nonatomic, strong) NSManagedObjectContext *childCtx;

@end

@implementation TeamStatsParseOperation
@synthesize teamStatsParser;
@synthesize teamStatsData;
@synthesize currentStatistic;
@synthesize currentPlayerStatistics;
@synthesize currentTeamStatistics;
@synthesize isParsingSeasonStatsElem;
@synthesize isParsingTeamElem;
@synthesize isParsingStatsElem;
@synthesize isParsingPlayerElem;
@synthesize childCtx;

#pragma mark - NSOperation

- (void) main {
    [[self teamStatsParser] setDelegate:self];
    [self databaseIsReady];
}

#pragma mark - TeamStatsParseOperation

- (void) databaseIsReady {
    BOOL isParseSuccessful = [self.teamStatsParser parse];
    if (isParseSuccessful) {
        DLog(@"Successfully parsed");
    } else {
        DLog(@"Parsing failed");
    }
}

- (id) initWithData:(NSMutableData *)data {
    self = [super init];
    self.teamStatsData = [data mutableCopy];
    self.isParsingSeasonStatsElem = NO;
    self.isParsingTeamElem = NO;
    self.isParsingStatsElem = NO;
    self.isParsingPlayerElem = NO;
    self.currentStatistic = UninitializedTeamStat;
    return self;
}

- (id) initWithParser:(NSXMLParser *)parser andContext:(NSManagedObjectContext *)ctx{
    self = [super init];
    
    self.teamStatsParser = parser;
    self.isParsingSeasonStatsElem = NO;
    self.isParsingTeamElem = NO;
    self.isParsingStatsElem = NO;
    self.isParsingPlayerElem = NO;
    self.currentStatistic = UninitializedTeamStat;
    self.childCtx = ctx;
    return self;
}

#pragma mark - NSXMLParserDelegate

- (void) parserDidStartDocument:(NSXMLParser *)parser {
    DLog(@"TeamStatsParseOperation started document");
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    DLog(@"TeamStatsParseOperation ended document");
    NSNotification *readyToDisplayNotification = [NSNotification notificationWithName:kNotificationDataReadyToDisplay object:nil];
    [[NSNotificationQueue defaultQueue] enqueueNotification:readyToDisplayNotification postingStyle:NSPostWhenIdle];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
    req.predicate = [NSPredicate predicateWithFormat:@"name = %@", @"Boston Celtics"];
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    req.sortDescriptors = [NSArray arrayWithObject:sortDesc];
    NSError *err = nil;
    [childCtx save:&err];
    NSArray *teamArray = [childCtx executeFetchRequest:req error:&err];
    Team *team = nil;
    if (teamArray && [teamArray count] > 0) {
        team = [teamArray objectAtIndex:0];
    }
    if (team) {
        DLog(@"\nTeam points: %hd\nTeam assists: %hd\nTeam steals: %hd\n ", team.teamStatistics.points, team.teamStatistics.assists, team.teamStatistics.steals);
        for (Player *player in team.players) {
            DLog(@"%@ %@", player.firstName, player.lastName);
            DLog(@"%@ points: %hd, assists: %hd, steals: %hd", player.firstName, player.playerStatistics.points, player.playerStatistics.assists, player.playerStatistics.steals);
        }
    }
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    NSString *attrValue = nil;
    if ([elementName isEqualToString:kSeasonStatsElem]) {
        self.isParsingSeasonStatsElem = YES;
        attrValue = [attributeDict valueForKey:kSeasonIdAttrKey];
        DLog(@"Season is %@", attrValue);
    }
    if ([elementName isEqualToString:kTeamStatsTeamElem]) {
        self.isParsingTeamElem = YES;
        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
        req.predicate = [NSPredicate predicateWithFormat:@"name = %@", [attributeDict valueForKey:@"name"]];
        NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        req.sortDescriptors = [NSArray arrayWithObject:sortDesc];
        NSError *err = nil;
        NSArray *teamArray = [childCtx executeFetchRequest:req error:&err];
        Team *team = nil;
        self.currentTeamStatistics = nil;
        if (teamArray && [teamArray count] > 0) {
            team = [teamArray objectAtIndex:0];
        }
        if (team) {
            TeamStatistics *teamStats = [TeamStatistics statsForTeam:team withManagedObjectContext:childCtx];
            team.teamStatistics = teamStats;
            self.currentTeamStatistics = team.teamStatistics;
        }
        
        attrValue = [attributeDict valueForKey:kTeamStatsTeamUidAttrKey];
        DLog(@"Team uid is %@", attrValue);
    }
    if([elementName isEqualToString:kTeamStatsPlayerElem]) {
        self.isParsingPlayerElem = YES;
        attrValue = [attributeDict valueForKey:kTeamStatPlayerUuidAttrKey];
        DLog(@"Player uid is %@", attrValue);
        attrValue = [attributeDict valueForKey:kPlayerFirstNameAttrKey];
        DLog(@"Player first name is %@", attrValue);
        attrValue = [attributeDict valueForKey:kPlayerLastNameAttrKey];
        DLog(@"Player last name is %@", attrValue);
        
        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Player"];
        req.predicate = [NSPredicate predicateWithFormat:@"playerUid = %@", [attributeDict valueForKey:kTeamStatPlayerUuidAttrKey]];
        NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"playerUid" ascending:YES];
        req.sortDescriptors = [NSArray arrayWithObject:sortDesc];
        NSError *err = nil;
        NSArray *playerStatsArray = [childCtx executeFetchRequest:req error:&err];
        Player *player = nil;
        self.currentPlayerStatistics = nil;
        if (playerStatsArray && [playerStatsArray count] > 0) {
            player = [playerStatsArray objectAtIndex:0];
        }
        if (player) {
            PlayerStatistics *playerStats = [PlayerStatistics statsForPlayer:player withManagedObjectContext:childCtx];
            player.playerStatistics = playerStats;
            self.currentPlayerStatistics = player.playerStatistics;
        }
    }
    if ([elementName isEqualToString:kStatsElem]) {
        
        attrValue = [attributeDict valueForKey:kTeamStatsTypeAttrKey];
        if ([attrValue isEqualToString:kThreePointersAttemptedAttrKey]) {
            self.currentStatistic = ThreePointersAttemptedStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kThreePointersMadeAttrKey]) {
            self.currentStatistic = ThreePointersMadeStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kAssistsAttrKey]) {
            self.currentStatistic = AssistsStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kBlocksAgainstAttrKey]) {
            self.currentStatistic = BlocksAgainstStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kBlockedShotsAttrKey]) {
            self.currentStatistic = BlockedShotsStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kFieldGoalsAttemptedAttrKey]) {
            self.currentStatistic = FieldGoalsAttemptedStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kFieldGoalsMadeAttrKey]) {
            self.currentStatistic = FieldGoalsMadeStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kFreeThrowsAttemptedAttrKey]) {
            self.currentStatistic = FreeThrowsAttemptedStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kFreeThrowsMadeAttrKey]) {
            self.currentStatistic = FreeThrowsMadeStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kOffensiveReboundsAttrKey]) {
            self.currentStatistic = OffensiveReboundsStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kDefensiveReboundsAttrKey]) {
            self.currentStatistic = DefensiveReboundsStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kPersonalFoulsAttrKey]) {
            self.currentStatistic = PersonalFoulsStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kPointsAttrKey]) {
            self.currentStatistic = PointsStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kStealsAttrKey]) {
            self.currentStatistic = StealsStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kTurnoversAttrKey]) {
            self.currentStatistic = TurnoversStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kTotalReboundsAttrKey]) {
            self.currentStatistic = TotalReboundsStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kPointsAgainstAttrKey]) {
            self.currentStatistic = PointsAgainstStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kFieldGoalsAttemptedAgainstAttrKey]) {
            self.currentStatistic = FieldGoalsAttemptedAgainstStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kTurnoversForcedAttrKey]) {
            self.currentStatistic = TurnoversForcedStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kFreeThrowsAttemptedAgainstAttrKey]) {
            self.currentStatistic = FreeThrowsAttemptedAgainstStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kPlusMinusAttrKey]) {
            self.currentStatistic = PlusMinusStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kMinutesAttrKey]) {
            self.currentStatistic = MinutesStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kGamesPlayedAttrKey]) {
            self.currentStatistic = GamesPlayedStat;
            self.isParsingStatsElem = YES;
        }
        if ([attrValue isEqualToString:kGamesStartedAttrKey]) {
            self.currentStatistic = GamesStartedStat;
            self.isParsingStatsElem = YES;
        }
    }
    
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:kSeasonStatsElem]) {
        self.isParsingSeasonStatsElem = NO;
    }
    if ([elementName isEqualToString:kTeamStatsTeamElem]) {
        self.isParsingTeamElem = NO;
    }
    if ([elementName isEqualToString:kTeamStatsPlayerElem]) {
        self.isParsingPlayerElem = NO;
    }
    if ([elementName isEqualToString:kStatsElem]) {
        self.isParsingStatsElem = NO;
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.isParsingStatsElem) {
        switch (currentStatistic) {
            case ThreePointersAttemptedStat:
                DLog(@"%@ = %@", kThreePointersAttemptedAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.threePointersAttempted = [string integerValue];
                }
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.threePointersAttempted = [string integerValue];
                }
                break;
            case ThreePointersMadeStat:
                DLog(@"%@ = %@", kThreePointersMadeAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.threePointersMade = [string integerValue];
                }
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.threePointersMade = [string integerValue];
                }
                break;
            case AssistsStat:
                DLog(@"%@ = %@", kAssistsAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.assists = [string integerValue];
                }
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.assists = [string integerValue];
                }
                break;
            case BlocksAgainstStat:
                DLog(@"%@ = %@", kBlocksAgainstAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.blockedAgainst = [string integerValue];
                }
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.blockedAgainst = [string integerValue];
                }
                break;
            case BlockedShotsStat:
                DLog(@"%@ = %@", kBlockedShotsAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.blockedShots = [string integerValue];
                }
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.blockedShots = [string integerValue];
                }
                break;
            case FieldGoalsAttemptedStat:
                DLog(@"%@ = %@", kFieldGoalsAttemptedAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.fieldGoalsAttempted = [string integerValue];
                }
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.fieldGoalsAttempted = [string integerValue];
                }
                break;
            case FieldGoalsMadeStat:
                DLog(@"%@ = %@", kFieldGoalsMadeAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.fieldGoalsMade = [string integerValue];
                }
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.fieldGoalsMade = [string integerValue];
                }
                break;
            case FreeThrowsAttemptedStat:
                DLog(@"%@ = %@", kFreeThrowsAttemptedAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.freeThrowsAttempted = [string integerValue];
                }
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.freeThrowsAttempted = [string integerValue];
                }
                break;
            case FreeThrowsMadeStat:
                DLog(@"%@ = %@", kFreeThrowsMadeAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.freeThrowsMade = [string integerValue];
                }
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.freeThrowsMade = [string integerValue];
                }
                break;
            case OffensiveReboundsStat:
                DLog(@"%@ = %@", kOffensiveReboundsAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.offensiveRebounds = [string integerValue];
                }
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.offensiveRebounds = [string integerValue];
                }
                break;
            case DefensiveReboundsStat:
                DLog(@"%@ = %@", kDefensiveReboundsAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.defensiveRebounds = [string integerValue];
                }
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.offensiveRebounds = [string integerValue];
                }
                break;

            case PersonalFoulsStat:
                DLog(@"%@ = %@", kPersonalFoulsAttrKey, string);
                break;
            case PointsStat:
                DLog(@"%@ = %@", kPointsAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.points = [string integerValue];
                }
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.points = [string integerValue];
                }
                break;
            case StealsStat:
                DLog(@"%@ = %@", kStealsAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.steals = [string integerValue];
                }
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.steals = [string integerValue];
                }
                break;
            case TurnoversStat:
                DLog(@"%@ = %@", kTurnoversAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.turnovers = [string integerValue];
                }
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.turnovers = [string integerValue];
                }
                break;
            case TotalReboundsStat:
                DLog(@"%@ = %@", kTotalReboundsAttrKey, string);
                break;
            case PointsAgainstStat:
                DLog(@"%@ = %@", kPointsAgainstAttrKey, string);
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.pointsAllowed = [string integerValue];
                }
                break;
            case FieldGoalsAttemptedAgainstStat:
                DLog(@"%@ = %@", kFieldGoalsAttemptedAgainstAttrKey, string);
                break;
            case TurnoversForcedStat:
                DLog(@"%@ = %@", kTurnoversForcedAttrKey, string);
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.turnoversForced = [string integerValue];
                }
                break;
            case FreeThrowsAttemptedAgainstStat:
                DLog(@"%@ = %@", kFreeThrowsAttemptedAgainstAttrKey, string);
                if (self.isParsingTeamElem && !self.isParsingPlayerElem) {
                    self.currentTeamStatistics.freeThrowsAllowed = [string integerValue];
                }
                break;
            case PlusMinusStat:
                DLog(@"%@ = %@", kPlusMinusAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.plusOrMinus = [string integerValue];
                }
                break;
            case MinutesStat:
                DLog(@"%@ = %@", kMinutesAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.minutes = string;
                }
                break;
            case GamesPlayedStat:
                DLog(@"%@ = %@", kGamesPlayedAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.gamesPlayed = [string integerValue];
                }
                break;
            case GamesStartedStat:
                DLog(@"%@ = %@", kGamesStartedAttrKey, string);
                if (self.isParsingPlayerElem) {
                    self.currentPlayerStatistics.gamesStarted = [string integerValue];
                }
                break;
            default:
                break;
        }
    }
}

- (void) parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
}

- (void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    
}

@end
