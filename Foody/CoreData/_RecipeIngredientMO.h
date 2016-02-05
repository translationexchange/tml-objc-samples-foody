// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipeIngredientMO.h instead.

@import CoreData;
#import "ModelMO.h"

extern const struct RecipeIngredientMOAttributes {
	__unsafe_unretained NSString *index;
	__unsafe_unretained NSString *measurement;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *quantity;
} RecipeIngredientMOAttributes;

extern const struct RecipeIngredientMORelationships {
	__unsafe_unretained NSString *recipe;
} RecipeIngredientMORelationships;

@class RecipeMO;

@interface RecipeIngredientMOID : ModelMOID {}
@end

@interface _RecipeIngredientMO : ModelMO {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RecipeIngredientMOID* objectID;

@property (nonatomic, strong) NSNumber* index;

@property (atomic) int32_t indexValue;
- (int32_t)indexValue;
- (void)setIndexValue:(int32_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* measurement;

//- (BOOL)validateMeasurement:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* quantity;

//- (BOOL)validateQuantity:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RecipeMO *recipe;

//- (BOOL)validateRecipe:(id*)value_ error:(NSError**)error_;

@end

@interface _RecipeIngredientMO (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int32_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int32_t)value_;

- (NSString*)primitiveMeasurement;
- (void)setPrimitiveMeasurement:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveQuantity;
- (void)setPrimitiveQuantity:(NSString*)value;

- (RecipeMO*)primitiveRecipe;
- (void)setPrimitiveRecipe:(RecipeMO*)value;

@end
