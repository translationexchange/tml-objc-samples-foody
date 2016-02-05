// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipeMO.m instead.

#import "_RecipeMO.h"

const struct RecipeMOAttributes RecipeMOAttributes = {
	.featuredIndex = @"featuredIndex",
	.imagePath = @"imagePath",
	.key = @"key",
	.locale = @"locale",
	.name = @"name",
	.preparationDescription = @"preparationDescription",
	.recipeDescription = @"recipeDescription",
};

const struct RecipeMORelationships RecipeMORelationships = {
	.category = @"category",
	.directions = @"directions",
	.ingredients = @"ingredients",
};

@implementation RecipeMOID
@end

@implementation _RecipeMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Recipe";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:moc_];
}

- (RecipeMOID*)objectID {
	return (RecipeMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"featuredIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"featuredIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic featuredIndex;

- (int32_t)featuredIndexValue {
	NSNumber *result = [self featuredIndex];
	return [result intValue];
}

- (void)setFeaturedIndexValue:(int32_t)value_ {
	[self setFeaturedIndex:@(value_)];
}

- (int32_t)primitiveFeaturedIndexValue {
	NSNumber *result = [self primitiveFeaturedIndex];
	return [result intValue];
}

- (void)setPrimitiveFeaturedIndexValue:(int32_t)value_ {
	[self setPrimitiveFeaturedIndex:@(value_)];
}

@dynamic imagePath;

@dynamic key;

@dynamic locale;

@dynamic name;

@dynamic preparationDescription;

@dynamic recipeDescription;

@dynamic category;

@dynamic directions;

- (NSMutableOrderedSet*)directionsSet {
	[self willAccessValueForKey:@"directions"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"directions"];

	[self didAccessValueForKey:@"directions"];
	return result;
}

@dynamic ingredients;

- (NSMutableSet*)ingredientsSet {
	[self willAccessValueForKey:@"ingredients"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"ingredients"];

	[self didAccessValueForKey:@"ingredients"];
	return result;
}

@end

@implementation _RecipeMO (DirectionsCoreDataGeneratedAccessors)
- (void)addDirections:(NSOrderedSet*)value_ {
	[self.directionsSet unionOrderedSet:value_];
}
- (void)removeDirections:(NSOrderedSet*)value_ {
	[self.directionsSet minusOrderedSet:value_];
}
- (void)addDirectionsObject:(RecipeDirectionMO*)value_ {
	[self.directionsSet addObject:value_];
}
- (void)removeDirectionsObject:(RecipeDirectionMO*)value_ {
	[self.directionsSet removeObject:value_];
}
- (void)insertObject:(RecipeDirectionMO*)value inDirectionsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"directions"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self directions]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"directions"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"directions"];
}
- (void)removeObjectFromDirectionsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"directions"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self directions]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"directions"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"directions"];
}
- (void)insertDirections:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"directions"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self directions]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"directions"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"directions"];
}
- (void)removeDirectionsAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"directions"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self directions]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"directions"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"directions"];
}
- (void)replaceObjectInDirectionsAtIndex:(NSUInteger)idx withObject:(RecipeDirectionMO*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"directions"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self directions]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"directions"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"directions"];
}
- (void)replaceDirectionsAtIndexes:(NSIndexSet *)indexes withDirections:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"directions"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self directions]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"directions"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"directions"];
}
@end

