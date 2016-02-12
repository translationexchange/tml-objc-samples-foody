//
//  JSONValueTransformer.m
//  Demo
//
//  Created by Pasha on 11/10/15.
//  Copyright © 2015 TmlHub Inc. All rights reserved.
//

#import "JSONValueTransformer.h"
#import "NSObject+JSON.h"

NSString * const JSONValueTransformerName = @"JSONValueTransformer";

@implementation JSONValueTransformer

+ (void)initialize {
    if (self == [JSONValueTransformer class]) {
        [NSValueTransformer setValueTransformer:[[self alloc] init] forName:JSONValueTransformerName];
    }
}

+ (Class)transformedValueClass {
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)transformedValue:(id)value {
    if (value == nil) {
        return nil;
    }
    return [[value JSONString] dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)reverseTransformedValue:(id)value {
    NSString *string = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
    return [string JSONObject];
}

@end
