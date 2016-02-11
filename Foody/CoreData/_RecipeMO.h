// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipeMO.h instead.

@import CoreData;
#import "ModelMO.h"

extern const struct RecipeMOAttributes {
	__unsafe_unretained NSString *featuredIndex;
	__unsafe_unretained NSString *imagePath;
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *locale;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *preparationDescription;
	__unsafe_unretained NSString *recipeDescription;
} RecipeMOAttributes;

extern const struct RecipeMORelationships {
	__unsafe_unretained NSString *category;
	__unsafe_unretained NSString *directions;
	__unsafe_unretained NSString *ingredients;
} RecipeMORelationships;

@class RecipeCategoryMO;
@class RecipeDirectionMO;
@class RecipeIngredientMO;

@interface RecipeMOID : ModelMOID {}
@end

@interface _RecipeMO : ModelMO {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RecipeMOID* objectID;

@property (nonatomic, strong) NSNumber* featuredIndex;

@property (atomic) int32_t featuredIndexValue;
- (int32_t)featuredIndexValue;
- (void)setFeaturedIndexValue:(int32_t)value_;

//- (BOOL)validateFeaturedIndex:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* imagePath;

//- (BOOL)validateImagePath:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* key;

//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* locale;

//- (BOOL)validateLocale:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* preparationDescription;

//- (BOOL)validatePreparationDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* recipeDescription;

//- (BOOL)validateRecipeDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RecipeCategoryMO *category;

//- (BOOL)validateCategory:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *directions;

- (NSMutableOrderedSet*)directionsSet;

@property (nonatomic, strong) NSOrderedSet *ingredients;

- (NSMutableOrderedSet*)ingredientsSet;

@end

@interface _RecipeMO (DirectionsCoreDataGeneratedAccessors)
- (void)addDirections:(NSOrderedSet*)value_;
- (void)removeDirections:(NSOrderedSet*)value_;
- (void)addDirectionsObject:(RecipeDirectionMO*)value_;
- (void)removeDirectionsObject:(RecipeDirectionMO*)value_;

- (void)insertObject:(RecipeDirectionMO*)value inDirectionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDirectionsAtIndex:(NSUInteger)idx;
- (void)insertDirections:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDirectionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDirectionsAtIndex:(NSUInteger)idx withObject:(RecipeDirectionMO*)value;
- (void)replaceDirectionsAtIndexes:(NSIndexSet *)indexes withDirections:(NSArray *)values;

@end

@interface _RecipeMO (IngredientsCoreDataGeneratedAccessors)
- (void)addIngredients:(NSOrderedSet*)value_;
- (void)removeIngredients:(NSOrderedSet*)value_;
- (void)addIngredientsObject:(RecipeIngredientMO*)value_;
- (void)removeIngredientsObject:(RecipeIngredientMO*)value_;

- (void)insertObject:(RecipeIngredientMO*)value inIngredientsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromIngredientsAtIndex:(NSUInteger)idx;
- (void)insertIngredients:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeIngredientsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInIngredientsAtIndex:(NSUInteger)idx withObject:(RecipeIngredientMO*)value;
- (void)replaceIngredientsAtIndexes:(NSIndexSet *)indexes withIngredients:(NSArray *)values;

@end

@interface _RecipeMO (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveFeaturedIndex;
- (void)setPrimitiveFeaturedIndex:(NSNumber*)value;

- (int32_t)primitiveFeaturedIndexValue;
- (void)setPrimitiveFeaturedIndexValue:(int32_t)value_;

- (NSString*)primitiveImagePath;
- (void)setPrimitiveImagePath:(NSString*)value;

- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;

- (NSString*)primitiveLocale;
- (void)setPrimitiveLocale:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitivePreparationDescription;
- (void)setPrimitivePreparationDescription:(NSString*)value;

- (NSString*)primitiveRecipeDescription;
- (void)setPrimitiveRecipeDescription:(NSString*)value;

- (RecipeCategoryMO*)primitiveCategory;
- (void)setPrimitiveCategory:(RecipeCategoryMO*)value;

- (NSMutableOrderedSet*)primitiveDirections;
- (void)setPrimitiveDirections:(NSMutableOrderedSet*)value;

- (NSMutableOrderedSet*)primitiveIngredients;
- (void)setPrimitiveIngredients:(NSMutableOrderedSet*)value;

@end
