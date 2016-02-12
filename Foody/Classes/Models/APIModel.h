//
//  Model.h
//  Foody
//
//  Created by Pasha on 1/26/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

extern NSString * const APIModel_DescriptionPropertyName;
extern NSString * const APIModel_FeaturedIndexPropertyName;
extern NSString * const APIModel_IDPropertyName;
extern NSString * const APIModel_ImagePropertyName;
extern NSString * const APIModel_IndexPropertyName;
extern NSString * const APIModel_KeyPropertyName;
extern NSString * const APIModel_LocalePropertyName;
extern NSString * const APIModel_MeasurementsPropertyName;
extern NSString * const APIModel_NamePropertyName;
extern NSString * const APIModel_PreparationPropertyName;
extern NSString * const APIModel_QuantityPropertyName;
extern NSString * const APIModel_CategoryIDPropertyName;
extern NSString * const APIModel_RecipeIDPropertyName;

@interface APIModel : NSObject <NSCopying,NSCoding>
@property (assign, nonatomic) NSInteger uid;
- (void)decodeWithCoder:(NSCoder *)aDecoder;
@end
