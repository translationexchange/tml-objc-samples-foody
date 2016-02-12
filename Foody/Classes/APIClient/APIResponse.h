//
//  APIResponse.h
//  Demo
//
//  Created by Pasha on 11/5/15.
//  Copyright © 2015 TmlHub Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const APIResponseErrorDomain;

extern NSString * const APIResponsePaginationKey;
extern NSString * const APIResponseCurrentPageKey;
extern NSString * const APIResponseResultsPerPageKey;
extern NSString * const APIResponseTotalResultsKey;
extern NSString * const APIResponseTotalPagesKey;
extern NSString * const APIResponsePageLinksKey;
extern NSString * const APIResponseFirstPageLinkKey;
extern NSString * const APIResponseLastPageLinkKey;
extern NSString * const APIResponseNextPageLinkKey;
extern NSString * const APIResponseCurrentPageLinkKey;

extern NSString * const APIResponseResultsKey;
extern NSString * const APIResponseResultsTranslationsKey;
extern NSString * const APIResponseResultsLanguagesKey;
extern NSString * const APIResponseResultsTranslationKeysKey;

extern NSString * const APIResponseStatusKey;
extern NSString * const APIResponseStatusOK;
extern NSString * const APIResponseStatusError;

extern NSString * const APIResponseErrorDescriptionKey;
extern NSString * const APIResponseErrorCodeKey;

@class Translation, Language;

@interface APIResponse : NSObject <NSCopying>

#pragma mark - Init

- (instancetype) initWithData:(NSData *)data;

#pragma mark - Results
@property (readonly, nonatomic) NSDictionary *userInfo;
@property (readonly, nonatomic) id results;

#pragma mark - Pagination
@property (readonly, nonatomic, getter=isPaginated) BOOL paginated;
@property (readonly, nonatomic) NSInteger currentPage;
@property (readonly, nonatomic) NSInteger totalPages;
@property (readonly, nonatomic) NSInteger resultsPerPage;
@property (readonly, nonatomic) NSInteger totalResults;

#pragma mark - Status
@property (readonly, nonatomic) NSString *status;
@property (readonly, nonatomic, getter=isSuccessfulResponse) BOOL successfulResponse;

#pragma mark - Merging
- (APIResponse *)responseByMergingWithResponse:(APIResponse *)response;

#pragma mark - Errors
@property (readonly, nonatomic) NSError *error;

@end
