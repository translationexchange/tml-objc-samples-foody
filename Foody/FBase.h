//
//  FBase.h
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiClient.h"

@interface FBase : NSObject

@property (nonatomic, strong) NSMutableDictionary *attributes;

- (id) initWithAttributes: (NSDictionary *) attrs;

- (NSObject *) getObject: (NSString *) attr;
- (NSString *) getValue: (NSString *) attr;

@end
