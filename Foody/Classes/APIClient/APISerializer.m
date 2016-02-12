//
//  APISerializer.m
//  Demo
//
//  Created by Pasha on 11/11/15.
//  Copyright © 2015 TmlHub Inc. All rights reserved.
//

#import "NSObject+JSON.h"
#import "APISerializer.h"
#import "APIModel.h"

@interface APISerializer()

@property (readwrite, nonatomic) NSMutableDictionary *info;

@end


@implementation APISerializer

+ (NSData *)serializeObject:(id)object {
    NSError *error = nil;
    NSData *result = nil;
    if (object == nil || [[NSNull null] isEqual:object] == YES) {
        return [[[NSNull null] JSONString] dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ([object isKindOfClass:[NSNumber class]] == YES) {
        return [[(NSNumber *)object JSONString] dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ([object isKindOfClass:[NSString class]] == YES) {
        return [[(NSString *)object JSONString] dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ([object isKindOfClass:[NSArray class]] == YES) {
        NSMutableArray *array = [NSMutableArray array];
        for (id item in (NSArray *)object) {
            [array addObject:[[APISerializer serializeObject:item] JSONObject]];
        }
        result = [NSJSONSerialization dataWithJSONObject:array
                                                 options:0
                                                   error:&error];
        if (error != nil) {
            AppError(@"APISerializer error: %@", error);
        }
        return result;
    }
    else if ([object isKindOfClass:[NSDictionary class]] == YES) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (id key in (NSDictionary *)object) {
            NSString *keyString = ([key isKindOfClass:[NSString class]] == YES) ? (NSString *)key : [NSString stringWithFormat:@"%@", key];
            dict[keyString] = [[APISerializer serializeObject:object[key]] JSONObject];
        }
        result = [NSJSONSerialization dataWithJSONObject:dict
                                                 options:0
                                                   error:&error];
        if (error != nil) {
            AppError(@"APISerializer error: %@", error);
        }
        return result;
    }
    APISerializer *serializer = [[APISerializer alloc] init];
    [object encodeWithCoder:serializer];
    result = [NSJSONSerialization dataWithJSONObject:serializer.info options:0 error:&error];
    if (error != nil) {
        AppError(@"APISerializer error: %@", error);
    }
    return result;
}

+ (id)materializeData:(NSData *)data 
            withClass:(Class)aClass
{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingAllowFragments
                                                  error:&error];
    if (error != nil) {
        AppError(@"Error materializing data: %@", error);
    };
    
    if (result == nil) {
        return result;
    }
    
    result = [self materializeObject:result 
                           withClass:aClass ];
    return result;
}

+ (id)materializeObject:(id)object
              withClass:(Class)aClass
{
    id result = nil;
    if ([object isKindOfClass:aClass] == YES) {
        return object;
    }
    if (object == nil || [[NSNull null] isEqual:object] == YES) {
        return [NSNull null];
    }
    if ([object isKindOfClass:[NSNumber class]] == YES
        || [object isKindOfClass:[NSString class]] == YES) {
        return object;
    }
    APISerializer *serializer = [[APISerializer alloc] init];
    if ([object isKindOfClass:[NSArray class]] == YES) {
        NSMutableArray *array = [NSMutableArray array];
        for (id item in (NSArray *)object) {
            id decodedItem = [APISerializer materializeObject:item
                                                       withClass:aClass];
            if (decodedItem != nil) {
                [array addObject:decodedItem];
            }
        }
        result = [array copy];
    }
    else if ([object isKindOfClass:[NSDictionary class]] == YES) {
        serializer.info = object;
        if (aClass != nil) {
            result = [(id<NSCoding>)[aClass alloc] initWithCoder:serializer];
        }
        else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (NSString *key in (NSDictionary *)object) {
                Class decodeClass = nil;
                id item = [(NSDictionary *)object valueForKey:key];
                id decodedItem = [APISerializer materializeObject:item
                                                           withClass:decodeClass];
                if (decodedItem != nil) {
                    dict[key] = decodedItem;
                }
            }
            result = dict;
        }
    }
    return result;
}

- (instancetype)init {
    if (self = [super init]) {
        _info = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initForReadingWithData:(NSData *)data {
    if (self = [self init]) {
        NSError *error;
        _info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error != nil) {
            NSException *exception = [[NSException alloc] initWithName:@"APISerializer"
                                                                reason:@"Error instantiating as coder for reading with data"
                                                              userInfo:@{
                                                                         @"error": error
                                                                         }];
            [exception raise];
        }
    }
    return self;
}

- (BOOL)allowsKeyedCoding {
    return YES;
}

#pragma mark - Encoding

- (void)encodeObject:(id)objv forKey:(NSString *)key {
    id val = nil;
    if (objv == nil) {
        return;
    }
    
    if ([objv isKindOfClass:[NSString class]] == YES
        || [objv isKindOfClass:[NSNumber class]] == YES) {
        val = objv;
    }
    else if ([objv isKindOfClass:[NSArray class]] == YES) {
        val = [[APISerializer serializeObject:objv] JSONObject];
    }
    if ([objv isKindOfClass:[NSDictionary class]] == YES) {
        val = [[APISerializer serializeObject:objv] JSONObject];
    }
    else if ([objv isKindOfClass:[APIModel class]] == YES) {
        val = [[APISerializer serializeObject:objv] JSONObject];
    }
    if (val != nil) {
        _info[key] = val;
    }
}

- (void)encodeInteger:(NSInteger)intv forKey:(NSString *)key {
    _info[key] = [NSNumber numberWithInteger:intv];
}

- (void)encodeInt64:(int64_t)intv forKey:(NSString *)key {
    _info[key] = [NSNumber numberWithInteger:(NSInteger)intv];
}

- (void)encodeInt32:(int32_t)intv forKey:(NSString *)key {
    _info[key] = [NSNumber numberWithInteger:intv];
}

- (void)encodeInt:(int)intv forKey:(NSString *)key {
    _info[key] = [NSNumber numberWithInteger:intv];
}

- (void)encodeBool:(BOOL)boolv forKey:(NSString *)key {
    _info[key] = @(boolv);
}

#pragma mark - Decoding

- (id)decodeObjectForKey:(NSString *)key {
    return _info[key];
}

- (NSInteger)decodeIntegerForKey:(NSString *)key {
    return [_info[key] integerValue];
}

-(int64_t)decodeInt64ForKey:(NSString *)key {
    return (int64_t)[_info[key] integerValue];
}

- (int32_t)decodeInt32ForKey:(NSString *)key {
    return (int32_t)[_info[key] integerValue];
}

- (int)decodeIntForKey:(NSString *)key {
    return (int)[_info[key] integerValue];
}

- (BOOL)decodeBoolForKey:(NSString *)key {
    return [_info[key] boolValue];
}

@end