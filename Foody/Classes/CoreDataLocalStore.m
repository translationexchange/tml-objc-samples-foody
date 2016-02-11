//
//  CoreDataLocalStore.m
//  Foody
//
//  Created by Pasha on 1/24/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "CoreDataLocalStore.h"

@interface CoreDataLocalStore() {
    CoreDataLocalStore *_threadSafeLocalStore;
    NSManagedObjectContextConcurrencyType _concurrencyType;
    NSURL *_managedObjectModelURL;
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation CoreDataLocalStore

+ (instancetype)threadSafeLocalStore {
    return [[[self alloc] init] threadSafeLocalStore];
}

- (CoreDataLocalStore *)threadSafeLocalStore {
    if (_threadSafeLocalStore != nil) {
        return _threadSafeLocalStore;
    }
    
    __block NSManagedObjectContext *context;
    if ([NSThread isMainThread] == YES) {
        context = self.managedObjectContext;
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            context = self.managedObjectContext;
        });
    }
    
    __block CoreDataLocalStore *localStore;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        localStore = [[[self class] alloc] init];
        localStore.managedObjectContext = context;
        localStore.managedObjectModel = self.managedObjectModel;
        localStore.persistentStoreCoordinator = self.persistentStoreCoordinator;
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    _threadSafeLocalStore = localStore;
    return localStore;
}

- (instancetype)init {
    if (self = [super init]) {
        _concurrencyType = NSMainQueueConcurrencyType;
        _managedObjectModelURL = [[NSBundle mainBundle] URLForResource:@"Foody" withExtension:@"momd"];
        NSAssert(_managedObjectModelURL != nil, @"Managed object model cannot be nil");
    }
    return self;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.translationexchange.Test" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = _managedObjectModelURL;
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Recipe.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"FoodyErrorDomain" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        TMLError(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:_concurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    // for now...
    _managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    return _managedObjectContext;
}

#pragma mark - Performing Blocks
- (void)performBlock:(void (^)(void))block {
    [_managedObjectContext performBlock:block];
}

- (void)performBlockAndWait:(void (^)(void))block {
    [_managedObjectContext performBlockAndWait:block];
}

- (BOOL)hasChanges {
    return [_managedObjectContext hasChanges];
}

#pragma mark - Core Data Saving support

- (void)save:(NSError *__autoreleasing *)anError {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            TMLError(@"Unresolved error %@, %@", error, [error userInfo]);
            if (anError) {
                *anError = error;
            }
            abort();
        }
    }
}

#pragma mark - Specialized Predicates

- (NSPredicate *)predicateMatchingAttributes:(NSDictionary *)attributes {
    NSMutableArray *strings = [NSMutableArray array];
    NSMutableArray *args = [NSMutableArray array];
    for (NSString *key in attributes) {
        [strings addObject:@"%K = %@"];
        [args addObject:key];
        [args addObject:attributes[key]];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[strings componentsJoinedByString:@" AND "]
                                                argumentArray:args];
    return predicate;
}

#pragma mark - Specialized Requests

- (NSFetchRequest *)fetchRequestForEntityName:(NSString *)entityName matchingAttributes:(NSDictionary *)attributes {
    NSPredicate *predicate = [self predicateMatchingAttributes:attributes];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = predicate;
    return request;
}

- (NSFetchRequest *)fetchRequestForEntityName:(NSString *)entityName offset:(NSInteger)offset limit:(NSInteger)limit {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.fetchOffset = offset;
    request.fetchLimit = limit;
    return request;
}

- (NSFetchRequest *)fetchRequestForEntityName:(NSString *)entityName
                                withAttribute:(NSString *)attribute
                                     inValues:(NSArray *)values
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K in %@", attribute, values];
    request.predicate = predicate;
    return request;
}

- (NSPersistentStoreRequest *)deleteRequestForEntityName:(NSString *)entityName
                             excludingAttributesMatching:(NSDictionary *)attributes
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSMutableArray *subpredicates = [NSMutableArray array];
    for (NSString *key in attributes) {
        id value = attributes[key];
        if ([value isKindOfClass:[NSArray class]] == NO) {
            value = @[value];
        }
        NSPredicate *subpredicate = [NSPredicate predicateWithFormat:@"NOT %K in %@", key, value];
        [subpredicates addObject:subpredicate];
    }
    NSCompoundPredicate *predicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:subpredicates];
    fetchRequest.predicate = predicate;
    NSPersistentStoreRequest *deleteRequest;
    if (NSClassFromString(@"NSBatchDeleteRequest") != nil) {
        deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    }
    else {
        deleteRequest = fetchRequest;
    }
    return deleteRequest;
}

#pragma mark - Fetch Requests

- (NSArray *)executeFetchRequest:(NSFetchRequest *)request{
    NSError *error;
    NSArray *results = [_managedObjectContext executeFetchRequest:request error:&error];
    if (error != nil) {
        TMLError(@"Error executing fetch request: %@", error);
    }
    return results;
}

- (NSUInteger)countForFetchRequest:(NSFetchRequest *)request {
    NSError *error;
    NSUInteger count = [_managedObjectContext countForFetchRequest:request error:&error];
    if (error != nil) {
        TMLError(@"Error executing fetch request: %@", error);
    }
    return count;
}

- (NSPersistentStoreResult *)executeRequest:(NSPersistentStoreRequest *)request{
    NSError *error;
    NSPersistentStoreResult *result = [_managedObjectContext executeRequest:request error:&error];
    if (error != nil) {
        TMLError(@"Error executing request: %@", error);
    }
    return result;
}

- (void)executeDeleteRequest:(NSPersistentStoreRequest *)request {
    if ([request isKindOfClass:[NSFetchRequest class]] == YES) {
        NSArray *results = [self executeFetchRequest:(NSFetchRequest *)request];
        for (NSManagedObject *mo in results) {
            [_managedObjectContext delete:mo];
        }
    }
    else {
        [self executeRequest:request];
    }
    if ([_managedObjectContext hasChanges] == YES) {
        NSError *error = nil;
        if([_managedObjectContext save:&error] == NO) {
            TMLError(@"Error executing delete request: %@", error);
        }
    }
}

#pragma mark - Categories

- (RecipeCategoryMO *)createCategory {
    RecipeCategoryMO *result = (RecipeCategoryMO *)[NSEntityDescription insertNewObjectForEntityForName:[RecipeCategoryMO entityName]
                                                                                 inManagedObjectContext:_managedObjectContext];
    return result;
}

- (RecipeCategoryMO *)categoryWithID:(NSNumber *)uid {
    NSFetchRequest *request = [self fetchRequestForEntityName:[RecipeCategoryMO entityName]
                                           matchingAttributes:@{@"uid": uid}];
    RecipeCategoryMO *result = [[self executeFetchRequest:request] lastObject];
    return result;
}

- (NSArray *)listCategoriesFromOffset:(NSInteger)offset limit:(NSInteger)limit {
    NSFetchRequest *request = [self fetchRequestForEntityName:[RecipeCategoryMO entityName]
                                                       offset:offset
                                                        limit:limit];
    NSArray *result = [self executeFetchRequest:request];
    return result;
}

- (NSInteger)countCategories {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[RecipeCategoryMO entityName]];
    return [self countForFetchRequest:request];
}

- (NSArray *)categoriesWithIDs:(NSArray *)ids {
    NSFetchRequest *request = [self fetchRequestForEntityName:[RecipeCategoryMO entityName]
                                                withAttribute:@"uid"
                                                     inValues:ids];
    return [self executeFetchRequest:request];
}

- (void)deleteCategoriesExcludingIDs:(NSArray *)ids {
    if (ids.count == 0) {
        return;
    }
    [self executeDeleteRequest:[self deleteRequestForEntityName:[RecipeCategoryMO entityName]
                                    excludingAttributesMatching:@{@"uid": ids}]];
}

#pragma mark - Recipes

- (RecipeMO *)createRecipe {
    RecipeMO *result = (RecipeMO *)[NSEntityDescription insertNewObjectForEntityForName:[RecipeMO entityName]
                                                                 inManagedObjectContext:_managedObjectContext];
    return result;
}

- (RecipeMO *)recipeWithID:(NSNumber *)uid {
    NSFetchRequest *request = [self fetchRequestForEntityName:[RecipeMO entityName]
                                           matchingAttributes:@{@"uid": uid}];
    RecipeMO *result = [[self executeFetchRequest:request] lastObject];
    return result;
}

- (NSArray *)listRecipesFromOffset:(NSInteger)offset limit:(NSInteger)limit {
    NSFetchRequest *request = [self fetchRequestForEntityName:[RecipeMO entityName] offset:offset limit:limit];
    return [self executeFetchRequest:request];
}

- (NSInteger)countRecipes {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[RecipeMO entityName]];
    return [self countForFetchRequest:request];
}

- (NSArray *)recipesWithIDs:(NSArray *)ids {
    NSFetchRequest *request = [self fetchRequestForEntityName:[RecipeMO entityName]
                                                withAttribute:@"uid"
                                                     inValues:ids];
    return [self executeFetchRequest:request];
}

- (void)deleteRecipesExcludingIDs:(NSArray *)ids {
    if (ids.count == 0) {
        return;
    }
    [self executeDeleteRequest:[self deleteRequestForEntityName:[RecipeMO entityName]
                                    excludingAttributesMatching:@{@"uid": ids}]];
}

#pragma mark - Ingredients
- (RecipeIngredientMO *)createIngredient {
    RecipeIngredientMO *result = (RecipeIngredientMO *)[NSEntityDescription insertNewObjectForEntityForName:[RecipeIngredientMO entityName]
                                                                                     inManagedObjectContext:_managedObjectContext];
    return result;
}

- (RecipeIngredientMO *)ingredientWithID:(NSNumber *)uid {
    NSFetchRequest *request = [self fetchRequestForEntityName:[RecipeIngredientMO entityName]
                                           matchingAttributes:@{@"uid": uid}];
    RecipeIngredientMO *result = [[self executeFetchRequest:request] lastObject];
    return result;
}

- (NSArray *)ingredientsWithIDs:(NSArray *)ids {
    NSFetchRequest *request = [self fetchRequestForEntityName:[RecipeIngredientMO entityName]
                                                withAttribute:@"uid"
                                                     inValues:ids];
    return [self executeFetchRequest:request];
}

- (void)deleteIngredientsExcludingIDs:(NSArray *)ids {
    if (ids.count == 0) {
        return;
    }
    [self executeDeleteRequest:[self deleteRequestForEntityName:[RecipeIngredientMO entityName]
                                    excludingAttributesMatching:@{@"uid": ids}]];
}

#pragma mark - Directions
- (RecipeDirectionMO *)createDirection {
    RecipeDirectionMO *result = (RecipeDirectionMO *)[NSEntityDescription insertNewObjectForEntityForName:[RecipeDirectionMO entityName]
                                                                                   inManagedObjectContext:_managedObjectContext];
    return result;
}

- (RecipeDirectionMO *)directionWithID:(NSNumber *)uid {
    NSFetchRequest *request = [self fetchRequestForEntityName:[RecipeDirectionMO entityName]
                                           matchingAttributes:@{@"uid": uid}];
    RecipeDirectionMO *result = [[self executeFetchRequest:request] lastObject];
    return result;
}

- (NSArray *)directionsWithIDs:(NSArray *)ids {
    NSFetchRequest *request = [self fetchRequestForEntityName:[RecipeDirectionMO entityName]
                                                withAttribute:@"uid"
                                                     inValues:ids];
    return [self executeFetchRequest:request];
}

- (void)deleteDirectionsExcludingIDs:(NSArray *)ids {
    if (ids.count == 0) {
        return;
    }
    [self executeDeleteRequest:[self deleteRequestForEntityName:[RecipeDirectionMO entityName]
                                    excludingAttributesMatching:@{@"uid": ids}]];
}

@end
