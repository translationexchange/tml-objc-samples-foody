//
//  NSObject+JSON.m
//  Demo
//
//  Created by Pasha on 11/10/15.
//  Copyright © 2015 TmlHub Inc. All rights reserved.
//

#import "NSObject+JSON.h"
#import "JSONValueTransformer.h"

@implementation NSObject (JSON)
- (NSString *)JSONString {
    NSData *data = nil;
    if ([self conformsToProtocol:@protocol(NSCoding)] == YES) {
        NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:JSONValueTransformerName];
        data = [transformer transformedValue:self];
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                       options:0
                                                         error:&error];
    if (jsonData == nil) {
        AppError(@"Error transorming %@ to JSONString: ", NSStringFromClass([self class]), error);
    }
    return [jsonData JSONString];
}
@end

@implementation NSNull (JSON)
- (NSString *)JSONString {
    return @"null";
}
@end

@implementation NSString (JSON)
- (NSString *)JSONString {
    NSArray *array = @[self];
    NSString *arrayString = [array JSONString];
    return [arrayString substringWithRange:NSMakeRange(1, arrayString.length-2)];
}

- (id)JSONObject {
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                             options:NSJSONReadingAllowFragments
                                               error:&error];
    if (obj == nil) {
        AppError(@"Error transorming %@ to JSONObject: ", NSStringFromClass([self class]), error);
    }
    return obj;
}
@end

@implementation NSNumber (JSON)
- (NSString *)JSONString {
    NSString *stringValue = [self stringValue];
    return stringValue;
}
@end

@implementation NSArray (JSON)
- (NSString *)JSONString {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:0
                                                     error:&error];
    if (data == nil) {
        AppError(@"Error transorming %@ to JSONString: ", NSStringFromClass([self class]), error);
    }
    return [data JSONString];
}
@end

@implementation NSDictionary (JSON)
- (NSString *)JSONString {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:0
                                                     error:&error];
    if (data == nil) {
        AppError(@"Error transorming %@ to JSONString: ", NSStringFromClass([self class]), error);
    }
    return [data JSONString];
}
@end


@implementation NSData (JSON)

- (NSString *)JSONString {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (id)JSONObject {
    NSError *error = nil;
    id obj =  [NSJSONSerialization JSONObjectWithData:self
                                           options:NSJSONReadingAllowFragments
                                             error:&error];
    if (obj == nil) {
        AppError(@"Error transorming %@ to JSONString: ", NSStringFromClass([self class]), error);
    }
    return obj;
}

@end