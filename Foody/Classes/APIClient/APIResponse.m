//
//  APIResponse.m
//  Demo
//
//  Created by Pasha on 11/5/15.
//  Copyright © 2015 TmlHub Inc. All rights reserved.
//

#import "NSObject+JSON.h"
#import "APIResponse.h"
#import "APISerializer.h"

NSString * const APIResponseErrorDomain = @"APIResponseErrorDomain";

NSString * const APIResponsePaginationKey = @"pagination";
NSString * const APIResponseCurrentPageKey = @"current_page";
NSString * const APIResponseResultsPerPageKey = @"per_page";
NSString * const APIResponseTotalResultsKey = @"total_count";
NSString * const APIResponseTotalPagesKey = @"total_pages";
NSString * const APIResponsePageLinksKey = @"links";
NSString * const APIResponseFirstPageLinkKey = @"first";
NSString * const APIResponseLastPageLinkKey = @"last";
NSString * const APIResponseNextPageLinkKey = @"next";
NSString * const APIResponseCurrentPageLinkKey = @"self";

NSString * const APIResponseResultsKey = @"results";
NSString * const APIResponseResultsTranslationsKey = @"translations";
NSString * const APIResponseResultsLanguagesKey = @"languages";
NSString * const APIResponseResultsTranslationKeysKey = @"languages";

NSString * const APIResponseStatusKey = @"status";
NSString * const APIResponseStatusOK = @"ok";
NSString * const APIResponseStatusError = @"error";

NSString * const APIResponseErrorDescriptionKey = @"error";
NSString * const APIResponseErrorCodeKey = @"code";

@interface APIResponse()
@property (readwrite, nonatomic) NSDictionary *userInfo;
@end

@implementation APIResponse

#pragma mark - Init

- (instancetype)initWithData:(NSData *)data {
    if (self = [super init]) {
        NSDictionary *userInfo = [data JSONObject];
        self.userInfo = (NSDictionary *)userInfo;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    APIResponse *copy = [[APIResponse alloc] init];
    copy.userInfo = self.userInfo;
    return copy;
}

#pragma mark - Results
- (id)results {
    return self.userInfo[APIResponseResultsKey];
}

#pragma mark - Pagination

- (NSDictionary *)paginationInfo {
    return self.userInfo[APIResponsePaginationKey];
}

- (BOOL)isPaginated {
    NSDictionary *paginationInfo = [self paginationInfo];
    if (paginationInfo != nil && [paginationInfo[APIResponseTotalPagesKey] integerValue] > 1) {
        return YES;
    }
    return NO;
}

- (NSInteger)currentPage {
    NSDictionary *paginationInfo = [self paginationInfo];
    return [paginationInfo[APIResponseCurrentPageKey] integerValue];
}

- (NSInteger)totalPages {
    NSDictionary *paginationInfo = [self paginationInfo];
    return [paginationInfo[APIResponseTotalPagesKey] integerValue];
}

- (NSInteger)resultsPerPage {
    NSDictionary *paginationInfo = [self paginationInfo];
    return [paginationInfo[APIResponseResultsPerPageKey] integerValue];
}

- (NSInteger)totalResults {
    NSDictionary *paginationInfo = [self paginationInfo];
    return [paginationInfo[APIResponseTotalResultsKey] integerValue];
}

#pragma mark - Status

- (NSString *)status {
    return self.userInfo[APIResponseStatusKey];
}

- (BOOL)isSuccessfulResponse {
    // if we spot results in the response - we can assume - it's a successful response
    id results = self.results;
    if (results != nil) {
        return YES;
    }
    
    // not all responses contain results, some may contain arbitrary data, but some will contain "status"
    NSString *status = [self.status lowercaseString];
    if (status != nil) {
        return [status isEqualToString:APIResponseStatusOK];
    }
    
    return self.userInfo != nil;
}

#pragma mark - Merging

- (APIResponse *)responseByMergingWithResponse:(APIResponse *)response {
    if (response == nil) {
        return self;
    }
    id results = self.results;
    id responseResults = response.results;
    id newResults = nil;
    if ([results isKindOfClass:[NSArray class]] == YES
        && [responseResults isKindOfClass:[NSArray class]] == YES) {
        NSMutableArray *newArray = [(NSArray *)results mutableCopy];
        [newArray addObjectsFromArray:responseResults];
        newResults = [newArray copy];
    }
    else if ([results isKindOfClass:[NSDictionary class]] == YES
             && [responseResults isKindOfClass:[NSDictionary class]] == YES) {
        NSMutableDictionary *newDict = [(NSDictionary *)results mutableCopy];
        for (id key in responseResults) {
            newDict[key] = responseResults[key];
        }
        newResults = [newDict copy];
    }
    else if (results == nil && responseResults != nil) {
        newResults = responseResults;
    }
    else if (responseResults == nil && results != nil) {
        newResults = results;
    }
    
    APIResponse *copy = [self copy];
    copy.userInfo = @{APIResponseResultsKey: newResults};
    return copy;
}

#pragma mark - Errors
- (NSError *)error {
    NSString *status = self.status;
    NSError *anError = nil;
    if ([status isEqualToString:APIResponseStatusError] == YES) {
        NSDictionary *userInfo = self.userInfo;
        NSInteger code = [userInfo[APIResponseErrorCodeKey] integerValue];
        NSString *description = userInfo[APIResponseErrorDescriptionKey];
        anError = [NSError errorWithDomain:APIResponseErrorDomain
                                      code:code
                                  userInfo:@{NSLocalizedDescriptionKey: description}];
    }
    return anError;
}

@end
