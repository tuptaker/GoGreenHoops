//
//  RosterParseOperation.m
//  GoGreen
//
//  Created by admin mac on 11/12/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#import "RosterParseOperation.h"
#import "RosterParserConstants.h"
#import "SportsDataConstants.h"
#import "SportsDataLoader.h"
#import "Team+Create.h"
#import "Player+Create.h"


@interface RosterParseOperation () <NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableData *rosterData;
@property (nonatomic, strong) NSXMLParser *rosterParser;
@property (nonatomic, strong) NSString *currentTeamUid;
@property (nonatomic, strong) NSNumber *season;
@property (nonatomic, strong) Team *team;
@property (nonatomic, strong) Player *currentPlayer;
@property (nonatomic) BOOL isParsingPositionElement;
@property (nonatomic) BOOL isParsingCelticsRoster;
@property (nonatomic) BOOL isParsingTeamElement;
@property (nonatomic) BOOL isParsingTeamNameElement;
@property (nonatomic) BOOL isParsingPlayerElement;
@property (nonatomic) BOOL isParsingPlayerNameElement;
@property (nonatomic) BOOL isParsingPlayerChangesElement;
@property (nonatomic) VitalStatisticType currentVitalStat;
@property (nonatomic) BOOL isParsingPlayerVitalStat;
@property (nonatomic) BOOL vitalStatIsFirstName;
@property (nonatomic) BOOL vitalStatIsLastName;
@property (nonatomic) BOOL vitalStatIsBirthDate;
@property (nonatomic) BOOL vitalStatIsWeight;
@property (nonatomic) BOOL vitalStatIsHeight;
@property (nonatomic) BOOL vitalStatIsJerseyNumber;
@property (nonatomic) BOOL vitalStatIsCollege;
@property (nonatomic) BOOL vitalStatIsFirstYear;
@property (nonatomic, strong) NSManagedObjectContext *childCtx;
@end

@implementation RosterParseOperation
@synthesize rosterData;
@synthesize rosterParser;
@synthesize currentTeamUid;
@synthesize team;
@synthesize currentPlayer;
@synthesize isParsingPositionElement;
@synthesize isParsingCelticsRoster;
@synthesize isParsingTeamElement;
@synthesize isParsingTeamNameElement;
@synthesize isParsingPlayerElement;
@synthesize isParsingPlayerNameElement;
@synthesize isParsingPlayerChangesElement;
@synthesize isParsingPlayerVitalStat;
@synthesize currentVitalStat;
@synthesize vitalStatIsFirstName;
@synthesize vitalStatIsLastName;
@synthesize vitalStatIsBirthDate;
@synthesize vitalStatIsWeight;
@synthesize vitalStatIsHeight;
@synthesize vitalStatIsJerseyNumber;
@synthesize vitalStatIsCollege;
@synthesize vitalStatIsFirstYear;
@synthesize childCtx;
@synthesize season;

#pragma mark - NSOperation

- (void) main {
    [rosterParser setDelegate:self];
    [self databaseIsReady];
}

- (void) databaseIsReady {
    BOOL isParseSuccessful = [self.rosterParser parse];
    if (isParseSuccessful) {
        DLog(@"Successfully parsed");
    } else {
        DLog(@"Parsing failed");
    }
}

#pragma mark - RosterParseOperation

- (id) initWithParser:(NSXMLParser *)parser andContext:(NSManagedObjectContext *)ctx {
    // initialize superclass instance else [NSOperationQueue addOperation]
    // will fail with EXC_BAD_ACCESS
    self = [super init];
    self.childCtx = ctx;
    self.rosterParser = parser;
    self.isParsingPositionElement = NO;
    self.isParsingCelticsRoster = NO;
    self.isParsingTeamNameElement = NO;
    self.isParsingTeamElement = NO;
    self.isParsingPlayerNameElement = NO;
    self.isParsingPlayerChangesElement = NO;
    self.isParsingPlayerVitalStat = NO;
    self.currentVitalStat = UninitializedStat;
    self.vitalStatIsFirstName = NO;
    self.vitalStatIsLastName = NO;
    self.vitalStatIsBirthDate = NO;
    self.vitalStatIsWeight = NO;
    self.vitalStatIsHeight = NO;
    self.vitalStatIsJerseyNumber = NO;
    self.vitalStatIsCollege = NO;
    self.vitalStatIsFirstYear = NO;
    self.currentTeamUid = [[NSString alloc] init];
    return self;
    
}

#if 0
- (id) initWithData:(NSData *) data {
    // initialize superclass instance else [NSOperationQueue addOperation]
    // will fail with EXC_BAD_ACCESS
    self = [super init];
    self.rosterData = [data mutableCopy];
    self.isParsingPositionElement = NO;
    self.isParsingCelticsRoster = NO;
    self.isParsingTeamNameElement = NO;
    self.isParsingTeamElement = NO;
    self.isParsingPlayerNameElement = NO;
    self.isParsingPlayerChangesElement = NO;
    self.isParsingPlayerVitalStat = NO;
    self.currentVitalStat = UninitializedStat;
    self.vitalStatIsFirstName = NO;
    self.vitalStatIsLastName = NO;
    self.vitalStatIsBirthDate = NO;
    self.vitalStatIsWeight = NO;
    self.vitalStatIsHeight = NO;
    self.vitalStatIsJerseyNumber = NO;
    self.vitalStatIsCollege = NO;
    self.vitalStatIsFirstYear = NO;
    self.currentTeamUid = [[NSString alloc] init];
    return self;
}
#endif 

#pragma mark - NSXMLParserDelegate

- (void) parserDidStartDocument:(NSXMLParser *)parser {
    
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    NSError *err = nil;
    [childCtx save:&err];
    SportsDataLoader *loader = [SportsDataLoader sportsDataLoaderWithContext:childCtx];
    [loader loadSportsDataOfType:TeamStatsData WithCompletion:^(NSInteger statusCode, NSError *err) {
        if (err == nil) {
            DLog(@"Team Stats Load Data Success");
        } else {
            DLog(@"Team Stats Load Data Failure");
        }
    }];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

    if ([elementName isEqualToString:kOptaDocumentElem]) {
        self.season = [NSNumber numberWithInt:[[attributeDict valueForKey:kRosterSeasonIdAttrKey] integerValue]];
    }
    
    if ([elementName isEqualToString:kTeamElem]) {
        self.isParsingTeamElement = YES;
        self.currentTeamUid = [attributeDict valueForKey:kTeamUidAttrKey];
    }
    
    if ([elementName isEqualToString:kTeamNameElem]) {
        self.isParsingTeamNameElement = YES;
        
    }
    
    if ([elementName isEqualToString:kPlayerElem]) {
        NSString *uid = [attributeDict valueForKey:kPlayerUidAttrKey];
        self.currentVitalStat = UidStat;
        if (self.isParsingCelticsRoster && !self.isParsingPlayerChangesElement) {
            self.isParsingPlayerElement = YES;
            DLog(@"Player uuid is %@", uid);
            self.currentPlayer = [Player playerWithUuid:uid withManagedObjectContext:childCtx];
        }
    }
    
    if ([elementName isEqualToString:kPlayerNameElem]) {
        self.isParsingPlayerNameElement = YES;
    }
    
    if ([elementName isEqualToString:kPositionElem]) {
        self.isParsingPositionElement = YES;
    }
    
    if ([elementName isEqualToString:kPlayerChangesElem]) {
        self.isParsingPlayerChangesElement = YES;
    }
    
    if ([elementName isEqualToString:kVitalStatsElem]) {
        // <Stats> element has only 1 attribute named "type"
        NSString *attributeType = [attributeDict valueForKey:kVitalStatsTypeAttrKey];
        self.isParsingPlayerVitalStat = UninitializedStat;
        self.isParsingPlayerVitalStat = NO;
        
        if ([attributeType isEqualToString:kFirstNameAttrKey]) {
            self.isParsingPlayerVitalStat = YES;
            self.currentVitalStat = FirstNameStat;
        }
        
        if ([attributeType isEqualToString:kLastNameAttrKey]) {
            self.isParsingPlayerVitalStat = YES;
            self.currentVitalStat = LastNameStat;
        }
        
        if ([attributeType isEqualToString:kBirthDateAttrKey]) {
            self.isParsingPlayerVitalStat = YES;
            self.currentVitalStat = BirthDateStat;
        }
        
        if ([attributeType isEqualToString:kWeightAttrKey]) {
            self.isParsingPlayerVitalStat = YES;
            self.currentVitalStat = WeightStat;
        }
        
        if ([attributeType isEqualToString:kHeightAttrKey]) {
            self.isParsingPlayerVitalStat = YES;
            self.currentVitalStat = HeightStat;
        }
        
        if ([attributeType isEqualToString:kJerseyNumberAttrKey]) {
            self.isParsingPlayerVitalStat = YES;
            self.currentVitalStat = JerseyNumStat;
        }
        
        if ([attributeType isEqualToString:kCollegeAttrKey]) {
            self.isParsingPlayerVitalStat = YES;
            self.currentVitalStat = CollegeStat;
        }
        
        if ([attributeType isEqualToString:kFirstYearAttrKey]) {
            self.isParsingPlayerVitalStat = YES;
            self.currentVitalStat = FirstYearStat;
        }
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:kTeamElem]){
        if (self.isParsingTeamElement && self.isParsingCelticsRoster) {
            self.isParsingTeamElement = NO;
            self.isParsingCelticsRoster = NO;
        }
    }
    
    if ([elementName isEqualToString:kPlayerElem] && self.isParsingCelticsRoster && !self.isParsingPlayerChangesElement) {
        self.isParsingPlayerElement = NO;
        [self.team addPlayersObject:self.currentPlayer];
    }
    
    if ([elementName isEqualToString:kTeamNameElem]) {
        self.isParsingTeamNameElement = NO;
    }
    
    if([elementName isEqualToString:kPlayerNameElem]) {
        self.isParsingPlayerNameElement = NO;
    }
    
    if([elementName isEqualToString:kPositionElem]) {
        self.isParsingPositionElement = NO;
    }
    
    if([elementName isEqualToString:kVitalStatsElem]) {
        self.isParsingPlayerVitalStat = NO;
    }
    
    if ([elementName isEqualToString:kPlayerChangesElem]) {
        self.isParsingPlayerChangesElement = NO;
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([string isEqualToString:kCelticsTeamName] && (!self.isParsingCelticsRoster) && (self.isParsingTeamNameElement) && (!self.isParsingPlayerChangesElement)) {
        self.isParsingCelticsRoster = YES;
        DLog(@"Team name is %@", string);
        DLog(@"Team uid is %@", self.currentTeamUid);
        self.team = [Team teamWithName:string forTeamUid:self.currentTeamUid withManagedObjectContext:childCtx andSeason:self.season];
    }
    
    if (self.isParsingTeamNameElement && ![string isEqualToString:kCelticsTeamName]) {
        self.isParsingCelticsRoster = NO;
    }
    
    if (self.isParsingCelticsRoster && self.isParsingPlayerNameElement && !self.isParsingPlayerChangesElement) {
        DLog(@"Celtics player: %@", string);
    }
    
    if (self.isParsingCelticsRoster && self.isParsingPositionElement && !self.isParsingPlayerChangesElement) {
        DLog(@"Celtics position: %@", string);
        self.currentPlayer.position = string;
    }
    
    if (self.isParsingPlayerVitalStat && self.isParsingCelticsRoster && !self.isParsingPlayerChangesElement) {
        NSArray *dateComponentsArray = nil;
        NSDateComponents *dateComponents = nil;
        NSCalendar *gregorian = nil;
        NSDate *birthDate = nil;
        switch (currentVitalStat) {
            case LastNameStat:
                DLog(@"Last Name is %@", string);
                self.currentPlayer.lastName = string;
                break;
            case FirstNameStat:
                DLog(@"First Name is %@", string);
                self.currentPlayer.firstName = string;
                break;
            case BirthDateStat:
                DLog(@"Birth Date is %@", string);
                dateComponentsArray = [string componentsSeparatedByString:@"-"];
                dateComponents = [[NSDateComponents alloc] init];
                [dateComponents setYear:[[dateComponentsArray objectAtIndex:0] integerValue]];
                [dateComponents setMonth:[[dateComponentsArray objectAtIndex:1] integerValue]];
                [dateComponents setDay:[[dateComponentsArray objectAtIndex:2] integerValue]];
                gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                birthDate = [gregorian dateFromComponents:dateComponents];
                self.currentPlayer.dateOfBirth = birthDate;
                break;
            case WeightStat:
                DLog(@"Weight is %@", string);
                self.currentPlayer.weightInPounds = [NSNumber numberWithInteger:[string integerValue]];
                break;
            case HeightStat:
                DLog(@"Height is %@", string);
                self.currentPlayer.heightInInches = [NSNumber numberWithInteger:[string integerValue]];
                break;
            case JerseyNumStat:
                DLog(@"Jersey number is %@", string);
                self.currentPlayer.jerseyNumber = [NSNumber numberWithInteger:[string integerValue]];
                break;
            case CollegeStat:
                DLog(@"College is %@", string);
                self.currentPlayer.college = string;
                break;
            case FirstYearStat:
                DLog(@"First year is %@", string);
                self.currentPlayer.firstYear = [NSNumber numberWithInteger:[string integerValue]];
                break;
            default:
                break;
        }
    }
}

- (void) parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    if (currentVitalStat == CollegeStat) {
        NSString *collegeName = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        if (self.isParsingCelticsRoster && !self.isParsingPlayerChangesElement) {
            DLog(@"College is %@", collegeName);
            self.currentPlayer.college = collegeName;
        }
    }
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
}

- (void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    
}

@end
