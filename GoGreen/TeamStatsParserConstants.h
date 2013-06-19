//
//  TeamStatsParserConstants.h
//  GoGreen
//
//  Created by admin mac on 11/22/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#ifndef GoGreen_TeamStatsParserConstants_h
#define GoGreen_TeamStatsParserConstants_h

typedef enum {
    UninitializedTeamStat = 0,
    ThreePointersAttemptedStat,
    ThreePointersMadeStat,
    AssistsStat,
    BlocksAgainstStat,
    BlockedShotsStat,
    DefensiveReboundsStat,
    FieldGoalsAttemptedStat,
    FieldGoalsMadeStat,
    FreeThrowsAttemptedStat,
    FreeThrowsMadeStat,
    OffensiveReboundsStat,
    PersonalFoulsStat,
    PointsStat,
    StealsStat,
    TurnoversStat,
    TotalReboundsStat,
    PointsAgainstStat,
    FieldGoalsAttemptedAgainstStat,
    TurnoversForcedStat,
    FreeThrowsAttemptedAgainstStat,
    PlusMinusStat,
    MinutesStat,
    GamesPlayedStat,
    GamesStartedStat
} TeamStatisticType;

FOUNDATION_EXPORT NSString *const kSeasonStatsElem;
FOUNDATION_EXPORT NSString *const kTeamStatsTeamElem;
FOUNDATION_EXPORT NSString *const kStatsElem;
FOUNDATION_EXPORT NSString *const kTeamStatsPlayerElem;
FOUNDATION_EXPORT NSString *const kTeamStatsTypeAttrKey;
FOUNDATION_EXPORT NSString *const kTeamStatsTeamUidAttrKey;
FOUNDATION_EXPORT NSString *const kSeasonIdAttrKey;
FOUNDATION_EXPORT NSString *const kTeamStatPlayerUuidAttrKey;
FOUNDATION_EXPORT NSString *const kPlayerFirstNameAttrKey;
FOUNDATION_EXPORT NSString *const kPlayerLastNameAttrKey;

FOUNDATION_EXPORT NSString *const kThreePointersAttemptedAttrKey;
FOUNDATION_EXPORT NSString *const kThreePointersMadeAttrKey;
FOUNDATION_EXPORT NSString *const kAssistsAttrKey;
FOUNDATION_EXPORT NSString *const kBlocksAgainstAttrKey;
FOUNDATION_EXPORT NSString *const kBlockedShotsAttrKey;
FOUNDATION_EXPORT NSString *const kDefensiveReboundsAttrKey;
FOUNDATION_EXPORT NSString *const kFieldGoalsAttemptedAttrKey;
FOUNDATION_EXPORT NSString *const kFieldGoalsMadeAttrKey;
FOUNDATION_EXPORT NSString *const kFreeThrowsAttemptedAttrKey;
FOUNDATION_EXPORT NSString *const kFreeThrowsMadeAttrKey;
FOUNDATION_EXPORT NSString *const kOffensiveReboundsAttrKey;
FOUNDATION_EXPORT NSString *const kPersonalFoulsAttrKey;
FOUNDATION_EXPORT NSString *const kPointsAttrKey;
FOUNDATION_EXPORT NSString *const kStealsAttrKey;
FOUNDATION_EXPORT NSString *const kTurnoversAttrKey;
FOUNDATION_EXPORT NSString *const kTotalReboundsAttrKey;
FOUNDATION_EXPORT NSString *const kPointsAgainstAttrKey;
FOUNDATION_EXPORT NSString *const kFieldGoalsAttemptedAgainstAttrKey;
FOUNDATION_EXPORT NSString *const kTurnoversForcedAttrKey;
FOUNDATION_EXPORT NSString *const kFreeThrowsAttemptedAgainstAttrKey;
FOUNDATION_EXPORT NSString *const kPlusMinusAttrKey;
FOUNDATION_EXPORT NSString *const kMinutesAttrKey;
FOUNDATION_EXPORT NSString *const kGamesPlayedAttrKey;
FOUNDATION_EXPORT NSString *const kGamesStartedAttrKey;



#endif
