//
//  FBase.m
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "FBase.h"

@implementation FBase

@synthesize attributes;

- (id) initWithAttributes: (NSDictionary *) attrs {
    if ([self init] == self) {
        self.attributes = [NSMutableDictionary dictionaryWithDictionary: attrs];
    }
    
    return self;
}

- (NSObject *) getObject: (NSString *) attr {
    return [self.attributes objectForKey:attr];
}

- (NSString *) getValue: (NSString *) attr {
    return [self.attributes objectForKey:attr];
}

@end
