//
//  FDirection.m
//  Foody
//
//  Created by Michael Berkovich on 10/14/15.
//  Copyright © 2015 Translation Exchange, Inc. All rights reserved.
//

#import "FDirection.h"

@implementation FDirection

- (id)copyWithZone:(NSZone *)zone {
    FDirection *copy = [[FDirection alloc] init];
    copy.directionID = self.directionID;
    copy.index = self.index;
    copy.directionDescription = self.directionDescription;
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.directionID forKey:@"id"];
    [aCoder encodeInteger:self.index forKey:@"index"];
    [aCoder encodeObject:self.directionDescription forKey:@"description"];
}

- (void)decodeWithCoder:(NSCoder *)aDecoder {
    self.directionID = [aDecoder decodeIntegerForKey:@"id"];
    self.index = [aDecoder decodeIntegerForKey:@"index"];
    self.directionDescription = [aDecoder decodeObjectForKey:@"description"];
}

-(BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if ([self isKindOfClass:[FDirection class]] == NO) {
        return NO;
    }
    return [self isEqualToDirection:(FDirection *)object];
}

-(BOOL)isEqualToDirection:(FDirection *)direction {
    return (self.directionID == direction.directionID
            && self.index == direction.index
            && (self.directionDescription == direction.directionDescription
                || [self.directionDescription isEqualToString:direction.directionDescription]));
}

@end
