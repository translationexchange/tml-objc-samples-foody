//
//  ApiClient.h
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiClient : NSObject

+ (ApiClient *) sharedInstance;

- (void) get: (NSString *) path
      params: (NSDictionary *) params
     options: (NSDictionary *) options
     success: (void (^)(NSDictionary *responseObject)) success
     failure: (void (^)(NSError *error)) failure;

- (void) post: (NSString *) path
       params: (NSDictionary *) params
      options: (NSDictionary *) options
      success: (void (^)(NSDictionary *responseObject)) success
      failure: (void (^)(NSError *error)) failure;

- (void) del: (NSString *) path
      params: (NSDictionary *) params
     options: (NSDictionary *) options
     success: (void (^)(NSDictionary *responseObject)) success
     failure: (void (^)(NSError *error)) failure;

- (void) put: (NSString *) path
      params: (NSDictionary *) params
     options: (NSDictionary *) options
     success: (void (^)(NSDictionary *responseObject)) success
     failure: (void (^)(NSError *error)) failure;

@end
