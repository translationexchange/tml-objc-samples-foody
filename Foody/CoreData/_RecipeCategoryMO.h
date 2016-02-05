// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipeCategoryMO.h instead.

@import CoreData;
#import "ModelMO.h"

extern const struct RecipeCategoryMOAttributes {
	__unsafe_unretained NSString *featuredIndex;
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *locale;
	__unsafe_unretained NSString *name;
} RecipeCategoryMOAttributes;

extern const struct RecipeCategoryMORelationships {
	__unsafe_unretained NSString *recipes;
} RecipeCategoryMORelationships;

@class RecipeMO;

@interface RecipeCategoryMOID : ModelMOID {}
@end

@interface _RecipeCategoryMO : ModelMO {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RecipeCategoryMOID* objectID;

@property (nonatomic, strong) NSNumber* featuredIndex;

@property (atomic) int32_t featuredIndexValue;
- (int32_t)featuredIndexValue;
- (void)setFeaturedIndexValue:(int32_t)value_;

//- (BOOL)validateFeaturedIndex:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* key;

//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* locale;

//- (BOOL)validateLocale:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *recipes;

- (NSMutableSet*)recipesSet;

@end

@interface _RecipeCategoryMO (RecipesCoreDataGeneratedAccessors)
- (void)addRecipes:(NSSet*)value_;
- (void)removeRecipes:(NSSet*)value_;
- (void)addRecipesObject:(RecipeMO*)value_;
- (void)removeRecipesObject:(RecipeMO*)value_;

@end

@interface _RecipeCategoryMO (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveFeaturedIndex;
- (void)setPrimitiveFeaturedIndex:(NSNumber*)value;

- (int32_t)primitiveFeaturedIndexValue;
- (void)setPrimitiveFeaturedIndexValue:(int32_t)value_;

- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;

- (NSString*)primitiveLocale;
- (void)setPrimitiveLocale:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet*)primitiveRecipes;
- (void)setPrimitiveRecipes:(NSMutableSet*)value;

@end
