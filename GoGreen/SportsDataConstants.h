//
//  SportsDataConstants.h
//  GoGreen
//
//  Created by admin mac on 11/9/12.
//  Copyright (c) 2012 Frabulon. All rights reserved.
//

#ifndef GoGreen_SportsDataConstants_h
#define GoGreen_SportsDataConstants_h

typedef enum {
    RosterData = 0x0,
    TeamStatsData = 0x1
} DataType;

FOUNDATION_EXPORT NSString *const kSportsDataApiKey;
// Google Custom Search API
// Reference: https://developers.google.com/custom-search/v1/using_rest
// Example search for brandon bass images:
// https://www.googleapis.com/customsearch/v1?key=AIzaSyA4GfXVBK22hYeRX9cSOfJ12SZ6hfizNLI&cx=012714704323638122126:r2kppnt1yd0&q=brandon+bass&searchType=image&num=9&start=88
// key = google custom search api key
// cx = google custom search engine id
// q = search query
// num = number of search results for current search (values between 1 and 10)
// start = index of first result to return, values between 1 and (101-num)
FOUNDATION_EXPORT NSString *const kGoogleCustomSearchApiKey;
FOUNDATION_EXPORT NSString *const kGoGreenITunesURL;
FOUNDATION_EXPORT NSString *const kGoogleCustomSearchEngineId;
FOUNDATION_EXPORT NSString *const kBitlyUsernameStr;// = @"septimius";
FOUNDATION_EXPORT NSString *const kBitlyApiKeyStr;// = @"R_01294e5e128039a02f9e7f4e8962d00a";
FOUNDATION_EXPORT NSString *const kNBARosterUrl;
FOUNDATION_EXPORT NSString *const kNBATeam2012SeasonStatsToDateUrl;
FOUNDATION_EXPORT NSString *const kPlayerImageSearchBaseUrl;
FOUNDATION_EXPORT NSString *const kRosterDataFileName;
FOUNDATION_EXPORT NSString *const kTeamStatsFileName;
FOUNDATION_EXPORT NSString *const kNotificationRosterDataReady;
FOUNDATION_EXPORT NSString *const kNotificationTeamStatsReady;
FOUNDATION_EXPORT NSString *const kNotificationReadyForRequest;
FOUNDATION_EXPORT NSString *const kNotificationStartResourceLoader;
FOUNDATION_EXPORT NSString *const kNotificationLoadNextResource;
FOUNDATION_EXPORT NSString *const kDataModelName;
FOUNDATION_EXPORT NSString *const kNotificationDataReadyToDisplay;
FOUNDATION_EXPORT NSString *const kNotificationReadBytes;
#endif
