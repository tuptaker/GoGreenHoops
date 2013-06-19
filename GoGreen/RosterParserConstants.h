//
//  RosterParserConstants.h
//  GoGreen
//
//  Created by admin mac on 11/17/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#ifndef GoGreen_RosterParserConstants_h
#define GoGreen_RosterParserConstants_h

typedef enum {
    UninitializedStat = 0,
    LastNameStat,
    FirstNameStat,
    BirthDateStat,
    WeightStat,
    HeightStat,
    JerseyNumStat,
    CollegeStat,
    FirstYearStat,
    UidStat
} VitalStatisticType;

FOUNDATION_EXPORT NSString *const kPositionElem;
FOUNDATION_EXPORT NSString *const kCelticsTeamName;
FOUNDATION_EXPORT NSString *const kTeamElem;
FOUNDATION_EXPORT NSString *const kTeamNameElem;
FOUNDATION_EXPORT NSString *const kPlayerElem;
FOUNDATION_EXPORT NSString *const kPlayerNameElem;
FOUNDATION_EXPORT NSString *const kVitalStatsElem;
FOUNDATION_EXPORT NSString *const kPlayerChangesElem;
FOUNDATION_EXPORT NSString *const kOptaDocumentElem;
FOUNDATION_EXPORT NSString *const kVitalStatsTypeAttrKey;
FOUNDATION_EXPORT NSString *const kPlayerUidAttrKey;
FOUNDATION_EXPORT NSString *const kTeamUidAttrKey;
FOUNDATION_EXPORT NSString *const kFirstNameAttrKey;
FOUNDATION_EXPORT NSString *const kLastNameAttrKey;
FOUNDATION_EXPORT NSString *const kBirthDateAttrKey;
FOUNDATION_EXPORT NSString *const kWeightAttrKey;
FOUNDATION_EXPORT NSString *const kHeightAttrKey;
FOUNDATION_EXPORT NSString *const kJerseyNumberAttrKey;
FOUNDATION_EXPORT NSString *const kCollegeAttrKey;
FOUNDATION_EXPORT NSString *const kFirstYearAttrKey;
FOUNDATION_EXPORT NSString *const kRosterSeasonIdAttrKey;

#endif
