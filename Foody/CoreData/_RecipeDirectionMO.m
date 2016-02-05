// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipeDirectionMO.m instead.

#import "_RecipeDirectionMO.h"

const struct RecipeDirectionMOAttributes RecipeDirectionMOAttributes = {
	.directionDescription = @"directionDescription",
	.index = @"index",
};

const struct RecipeDirectionMORelationships RecipeDirectionMORelationships = {
	.recipe = @"recipe",
};

@implementation RecipeDirectionMOID
@end

@implementation _RecipeDirectionMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RecipeDirection" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RecipeDirection";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RecipeDirection" inManagedObjectContext:moc_];
}

- (RecipeDirectionMOID*)objectID {
	return (RecipeDirectionMOID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic directionDescription;

@dynamic index;

- (int32_t)indexValue {
	NSNumber *result = [self index];
	return [result intValue];
}

- (void)setIndexValue:(int32_t)value_ {
	[self setIndex:@(value_)];
}

- (int32_t)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result intValue];
}

- (void)setPrimitiveIndexValue:(int32_t)value_ {
	[self setPrimitiveIndex:@(value_)];
}

@dynamic recipe;

@end

