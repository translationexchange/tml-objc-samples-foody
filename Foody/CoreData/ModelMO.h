#import "_ModelMO.h"
#import "APIModel.h"

@interface ModelMO : _ModelMO <NSCoding> {}
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (void)decodeWithCoder:(NSCoder *)aCoder;
@end
