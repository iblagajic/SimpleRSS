//
//  SMLDataController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 18/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLDataController.h"

@interface SMLDataController()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSFetchedResultsController *frcForRSSFeedsSearch;
@property (nonatomic) NSOperationQueue *searchQueue;

@end

@implementation SMLDataController

+ (id)sharedController {
    static SMLDataController *sharedDataController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataController = [[self alloc] init];
        sharedDataController.searchQueue = [NSOperationQueue new];
        sharedDataController.searchQueue.maxConcurrentOperationCount = 1;
    });
    return sharedDataController;
}

- (void)dealloc {
    [self.searchQueue cancelAllOperations];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.searchQueue = nil;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        NSParameterAssert(_managedObjectContext);
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SimpleRSS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSParameterAssert(_managedObjectModel);
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SimpleRSS.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - helpers

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - public methods

- (NSFetchedResultsController *)frcWithMyRSSFeeds {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RSSFeed"];

    NSSortDescriptor *byOrdinal = [NSSortDescriptor sortDescriptorWithKey:@"ordinal" ascending:YES];
    fetchRequest.sortDescriptors = @[byOrdinal];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isInMyFeeds = YES", nil];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.managedObjectContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    return fetchedResultsController;
}

- (NSFetchedResultsController *)frcWithRSSFeedsContainingString:(NSString*)searchTerm {
    
    if (!searchTerm || [searchTerm isEqualToString:@""]) {
        [self.searchQueue cancelAllOperations];
        return nil;
    }
    
    [self.searchQueue cancelAllOperations];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.searchQueue addOperationWithBlock:^{
        NSDictionary *results = [self JSONResponseForSearchTerm:searchTerm];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self parseResults:results];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RSSFeed"];
    
    if (self.frcForRSSFeedsSearch) {
        NSSortDescriptor *byTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
        fetchRequest.sortDescriptors = @[byTitle];
        self.frcForRSSFeedsSearch = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:@"MyFeeds"];
    }
    
    self.frcForRSSFeedsSearch.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchTerm];
    
    return self.frcForRSSFeedsSearch;
}

- (NSFetchedResultsController *)frcWithItemsForRSSFeed:(RSSFeed*)feed {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RSSItem"];
    
    NSSortDescriptor *byDate = [NSSortDescriptor sortDescriptorWithKey:@"pubDate" ascending:YES];
    fetchRequest.sortDescriptors = @[byDate];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"feed = %@", feed];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.managedObjectContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:feed.title];
    return fetchedResultsController;
}

- (void)addFeedToMyFeeds:(RSSFeed*)feed {
    feed.isInMyFeeds = @YES;
    [self saveContext];
}


#pragma mark - helpers

- (NSDictionary*)JSONResponseForSearchTerm:(NSString*)term {
    
    NSString *requestUrlString = [@"https://ajax.googleapis.com/ajax/services/feed/find?v=1.0&q=" stringByAppendingString:[term stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *requestUrl = [NSURL URLWithString:requestUrlString];
    
    NSError *err;
    NSString *resultString = [NSString stringWithContentsOfURL:requestUrl encoding:NSUTF8StringEncoding error:&err];
    if (err)
        NSLog(@"%@",err);
    
    NSData *resultData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    if (!resultData)
        return nil;
    err = nil;
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&err];
    if (err)
        NSLog(@"%@", err);
    return result;
}

- (void)parseResults:(NSDictionary*)resultsJSON {
    
    NSDictionary *responseData = [resultsJSON objectForKey:@"responseData"];
    NSDictionary *entries = [responseData objectForKey:@"entries"];
    for (NSDictionary *entry in entries) {
        RSSFeed *feed = [RSSFeed feedWithDictionary:entry inContext:self.managedObjectContext];
        NSLog(@"%@", [feed description]);
    }
    
    [self saveContext];
}

@end
