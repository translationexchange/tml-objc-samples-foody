//
//  SyncEngine.h
//  Foody
//
//  Created by Pasha on 1/24/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SyncEngineDidFinishEventName;
extern NSString * const SyncEngineDidStartEventName;

@class APIClient;

@interface SyncEngine : NSObject

- (instancetype)initWithAPIClient:(APIClient *)apiClient;
@property (readonly, nonatomic) APIClient *apiClient;
@property (readwrite, nonatomic) NSDate *lastSyncDate;

- (void)sync;

@end
