// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipeDirectionMO.h instead.

@import CoreData;
#import "ModelMO.h"

extern const struct RecipeDirectionMOAttributes {
	__unsafe_unretained NSString *directionDescription;
	__unsafe_unretained NSString *index;
} RecipeDirectionMOAttributes;

extern const struct RecipeDirectionMORelationships {
	__unsafe_unretained NSString *recipe;
} RecipeDirectionMORelationships;

@class RecipeMO;

@interface RecipeDirectionMOID : ModelMOID {}
@end

@interface _RecipeDirectionMO : ModelMO {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RecipeDirectionMOID* objectID;

@property (nonatomic, strong) NSString* directionDescription;

//- (BOOL)validateDirectionDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* index;

@property (atomic) int32_t indexValue;
- (int32_t)indexValue;
- (void)setIndexValue:(int32_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RecipeMO *recipe;

//- (BOOL)validateRecipe:(id*)value_ error:(NSError**)error_;

@end

@interface _RecipeDirectionMO (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDirectionDescription;
- (void)setPrimitiveDirectionDescription:(NSString*)value;

- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int32_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int32_t)value_;

- (RecipeMO*)primitiveRecipe;
- (void)setPrimitiveRecipe:(RecipeMO*)value;

@end
