//
//  SyncEngine.m
//  Foody
//
//  Created by Pasha on 1/24/16.
//  Copyright © 2016 Translation Exchange, Inc. All rights reserved.
//

#import "SyncEngine.h"
#import "APIClient.h"
#import "Recipe.h"
#import "RecipeCategory.h"
#import "RecipeDirection.h"
#import "RecipeIngredient.h"
#import "CoreDataLocalStore.h"
#import "APISerializer.h"
#import "NSObject+JSON.h"

NSString * const CategoriesKey = @"Categories";
NSString * const RecipesKey = @"Recipes";

NSString * const SyncEngineDidFinishEventName = @"SyncEngineDidFinishEventName";
NSString * const SyncEngineDidStartEventName = @"SyncEngineDidStartEventName";

#define IsSuccessfullyFinishedResponse(apiResponse)\
([apiResponse isSuccessfulResponse] == YES && (apiResponse.isPaginated == NO || apiResponse.currentPage == apiResponse.totalPages))

typedef NS_ENUM(NSInteger, SyncEngineEvent) {
    SyncEngineStartEvent,
    SyncEngineEndEvent,
    SyncEngineProgressEvent
};

NSString * const SyncEngineProgressIdentifierKey = @"progressIdentifier";

@interface SyncEngine() {
    NSInteger *_syncOperationCount;
    NSMutableDictionary *_processedIDs;
}
@property (readwrite, nonatomic, strong) APIClient *apiClient;

@end

@implementation SyncEngine

-(instancetype)init {
    RaiseAlternativeInstantiationMethod(@selector(initWithAPIClient:));
    return nil;
}

- (instancetype)initWithAPIClient:(APIClient *)apiClient {
    if (self = [super init]) {
        self.apiClient = apiClient;
    }
    return self;
}

- (void)resetProcessedIDs {
    _processedIDs = [NSMutableDictionary dictionary];
    _processedIDs[CategoriesKey] = [NSMutableSet set];
    _processedIDs[RecipesKey] = [NSMutableSet set];
}

- (void)syncDidStart {
}

- (void)syncDidEnd {
    if (_syncOperationCount == 0) {
        _lastSyncDate = [NSDate date];
        [self signalSyncEvent:SyncEngineEndEvent userInfo:nil];
    }
}

- (void)sync {
    [self syncDidStart];
    [self resetProcessedIDs];
    [self signalSyncEvent:SyncEngineStartEvent userInfo:nil];
}

- (void)signalSyncEvent:(SyncEngineEvent)event userInfo:(NSDictionary *)userInfo {
    if (event == SyncEngineStartEvent) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SyncEngineDidStartEventName object:nil];
        [self fetchCategories:nil completion:^(APIResponse *apiResponse, NSArray *result, NSError *error) {
            if (IsSuccessfullyFinishedResponse(apiResponse) == YES) {
                [self signalSyncEvent:SyncEngineProgressEvent
                             userInfo:@{
                                        SyncEngineProgressIdentifierKey: CategoriesKey
                                        }];
            }
        }];
    }
    else if (event == SyncEngineProgressEvent) {
        NSString *identifier = userInfo[SyncEngineProgressIdentifierKey];
        if ([CategoriesKey isEqualToString:identifier] == YES) {
            [self fetchRecipes:nil completion:^(APIResponse *apiResponse, NSArray *result, NSError *error) {
                if (IsSuccessfullyFinishedResponse(apiResponse) == YES) {
                    [self signalSyncEvent:SyncEngineProgressEvent
                                 userInfo:@{
                                            SyncEngineProgressIdentifierKey: RecipesKey
                                            }];
                }
            }];
        }
    }
    else if (event == SyncEngineEndEvent) {
        [self expungeObsoleteObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:SyncEngineDidFinishEventName object:nil];
    }
}

- (void)fetchWithSelector:(SEL)selector
               parameters:(NSDictionary *)parameters
               completion:(void(^)(APIResponse *apiResponse, NSArray *result, NSError *error))completion
{
    APIClient *apiClient = self.apiClient;
    _syncOperationCount++;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [apiClient performSelector:selector
                    withObject:parameters
                    withObject:^(APIResponse *apiResponse, NSArray *result, NSError *error) {
                        if (error == nil) {
                            [self importAPIResult:result];
                        }
                        if ([apiResponse isPaginated] == YES) {
                            NSInteger currentPage = apiResponse.currentPage;
                            NSInteger totalPages = apiResponse.totalPages;
                            if (currentPage < totalPages) {
                                NSMutableDictionary *newParams = [NSMutableDictionary dictionary];
                                if (parameters.count > 0) {
                                    [newParams addEntriesFromDictionary:parameters];
                                }
                                newParams[@"page"] = @(currentPage+1);
                                [self fetchWithSelector:selector
                                             parameters:newParams
                                             completion:completion];
                            }
                        }
                        _syncOperationCount--;
                        if (completion != nil) {
                            completion(apiResponse, result, error);
                        }
                        [self syncDidEnd];
                    }];
#pragma clang diagnostic pop
}

- (void)fetchCategories:(NSDictionary *)parameters
            completion:(void(^)(APIResponse *apiResponse, NSArray *categories, NSError *error))completion
{
    [self fetchWithSelector:@selector(listCategories:completion:)
                 parameters:nil
                 completion:completion];
}

- (void)fetchRecipes:(NSDictionary *)parameters
          completion:(void(^)(APIResponse *apiResponse, NSArray *categories, NSError *error))completion{
    [self fetchWithSelector:@selector(listRecipes:completion:)
                 parameters:nil
                 completion:completion];
}

#pragma mark - Importing

-(void)importAPIResult:(id)result {
    if (result == nil
        || [[NSNull null] isEqual:result] == YES) {
        return;
    }
    Class targetClass;
    NSArray *objects;
    if ([result isKindOfClass:[NSArray class]] == YES) {
        targetClass = [[result firstObject] class];
        objects = result;
    }
    else if ([result isKindOfClass:[NSDictionary class]] == YES) {
        objects = [result allValues];
        targetClass = [[objects firstObject] class];
    }
    else {
        objects = @[result];
        targetClass = [result class];
    }
    
    SEL importSelector;
    if (targetClass == [RecipeCategory class]) {
        importSelector = @selector(importAPICategories:);
    }
    else if (targetClass == [Recipe class]) {
        importSelector = @selector(importAPIRecipes:);
    }
    
    if (importSelector != nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:importSelector withObject:objects];
#pragma clang diagnostic pop
    }
    else {
        AppWarn(@"Don't know how to import %@", (targetClass != nil) ? NSStringFromClass(targetClass), targetClass);
    }
}

-(void)importAPICategories:(NSArray *)categories {
    NSArray *ids = [categories valueForKeyPath:@"uid"];
    if (ids.count == 0) {
        return;
    }
    
    [_processedIDs[CategoriesKey] addObjectsFromArray:ids];
    CoreDataLocalStore *localStore = [CoreDataLocalStore threadSafeLocalStore];
    [localStore performBlock:^{
        NSArray *existingCategories = [localStore categoriesWithIDs:ids];
        NSDictionary *existingMap = [NSDictionary dictionaryWithObjects:existingCategories
                                                                forKeys:[existingCategories valueForKeyPath:@"uid"]];
        for (RecipeCategory *apiCategory in categories) {
            RecipeCategoryMO *existingCategory = existingMap[@(apiCategory.uid)];
            if (existingCategory == nil) {
                existingCategory = [localStore createCategory];
            }
            NSData *data = [APISerializer serializeObject:apiCategory];
            [existingCategory decodeWithCoder:[[APISerializer alloc] initForReadingWithData:data]];
        }
        
        NSError *error = nil;
        if ([localStore hasChanges] == YES) {
            [localStore save:&error];
        }
        if (error != nil) {
            AppError(@"Error importing API categories: %@", error);
        }
    }];
}

- (void)importAPIRecipes:(NSArray *)recipes {
    NSArray *ids = [recipes valueForKeyPath:@"uid"];
    if (ids.count == 0) {
        return;
    }
    
    NSArray *categoryIDs = [recipes valueForKeyPath:@"categoryID"];
    if (categoryIDs.count == 0) {
        return;
    }
    
    [_processedIDs[RecipesKey] addObjectsFromArray:ids];
    CoreDataLocalStore *localStore = [CoreDataLocalStore threadSafeLocalStore];
    [localStore performBlock:^{
        NSArray *existingCategories = [localStore categoriesWithIDs:categoryIDs];
        NSDictionary *existingCategoryMap = [NSDictionary dictionaryWithObjects:existingCategories forKeys:[existingCategories valueForKeyPath:@"uid"]];
        NSArray *existingRecipes = [localStore recipesWithIDs:ids];
        NSDictionary *existingRecipesMap = [NSDictionary dictionaryWithObjects:existingRecipes forKeys:[existingRecipes valueForKeyPath:@"uid"]];
        
        for (Recipe *apiRecipe in recipes) {
            RecipeCategoryMO *category = existingCategoryMap[@(apiRecipe.categoryID)];
            if (category == nil) {
                AppWarn(@"Tried to import Recipe associated with unknown category: %i", apiRecipe.categoryID);
                continue;
            }
            RecipeMO *existingRecipe = existingRecipesMap[@(apiRecipe.uid)];
            if (existingRecipe == nil) {
                existingRecipe = [localStore createRecipe];
            }
            
            NSData *apiData = [APISerializer serializeObject:apiRecipe];
            NSDictionary *apiInfo = [apiData JSONObject];
            NSDictionary *existingInfo = [[APISerializer serializeObject:existingRecipe] JSONObject];
            if ([apiInfo isEqualToDictionary:existingInfo] == YES) {
                continue;
            }
            
            [existingRecipe decodeWithCoder:[[APISerializer alloc] initForReadingWithData:apiData]];
            
            if (category.uidValue == apiRecipe.categoryID) {
                [category.recipesSet addObject:existingRecipe];
            }
        }
        
        NSError *error = nil;
        if ([localStore hasChanges] == YES) {
            [localStore save:&error];
            [localStore.managedObjectContext processPendingChanges];
        }
        if (error != nil) {
            AppError(@"Error importing API categories: %@", error);
        }
    }];
}

#pragma mark - Expunging Obsolete Objects

- (void)expungeObsoleteObjects {
    NSArray *categoriesIDs = [_processedIDs[CategoriesKey] allObjects];
    NSArray *recipiesIDs = [_processedIDs[RecipesKey] allObjects];
    CoreDataLocalStore *localStore = [CoreDataLocalStore threadSafeLocalStore];
    [localStore performBlock:^{
        [localStore deleteCategoriesExcludingIDs:categoriesIDs];
        [localStore deleteRecipesExcludingIDs:recipiesIDs];
    }];
}

@end
