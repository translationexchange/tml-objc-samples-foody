#import "ModelMO.h"

@interface ModelMO ()

// Private interface goes here.

@end

@implementation ModelMO

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.uidValue forKey:APIModel_IDPropertyName];
}

- (void)decodeWithCoder:(NSCoder *)aCoder {
    NSInteger newValue = [aCoder decodeIntegerForKey:APIModel_IDPropertyName];
    if (newValue != self.uidValue) {
        self.uidValue = newValue;
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        [self decodeWithCoder:aDecoder];
    }
    return self;
}

@end
