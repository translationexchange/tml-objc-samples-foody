//
//  NSObject+JSON.h
//  Demo
//
//  Created by Pasha on 11/10/15.
//  Copyright © 2015 TmlHub Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSON)
- (NSString *)JSONString;
@end

@interface NSNull (JSON)
- (NSString *)JSONString;
@end

@interface NSString (JSON)
- (NSString *)JSONString;
- (id)JSONObject;
@end

@interface NSNumber (JSON)
- (NSString *)JSONString;
@end

@interface NSArray (JSON)
- (NSString *)JSONString;
@end

@interface NSDictionary (JSON)
- (NSString *)JSONString;
@end

@interface NSData (JSON)
- (NSString *)JSONString;
- (id)JSONObject;
@end