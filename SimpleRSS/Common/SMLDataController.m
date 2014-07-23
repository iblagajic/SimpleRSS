//
//  SMLDataController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 18/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLDataController.h"

#define kSMLFetchLimit 25

@interface SMLDataController()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSFetchedResultsController *frcForRSSFeedsSearch;
@property (nonatomic) NSOperationQueue *refreshOperationQueue;

@end

@implementation SMLDataController

+ (id)sharedController {
    static SMLDataController *sharedDataController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataController = [[self alloc] init];
        sharedDataController.refreshOperationQueue = [NSOperationQueue new];
        sharedDataController.refreshOperationQueue.maxConcurrentOperationCount = 1;
    });
    return sharedDataController;
}

- (void)dealloc {
    [self.refreshOperationQueue cancelAllOperations];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.refreshOperationQueue = nil;
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
        [self.refreshOperationQueue cancelAllOperations];
        return nil;
    }
    
    [self.refreshOperationQueue cancelAllOperations];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.refreshOperationQueue addOperationWithBlock:^{
        NSDictionary *results = [self JSONResponseForSearchTerm:searchTerm];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self parseFeedsJSON:results];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RSSFeed"];
    
    if (!self.frcForRSSFeedsSearch) {
        NSSortDescriptor *byTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
        fetchRequest.sortDescriptors = @[byTitle];
        self.frcForRSSFeedsSearch = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    }
    
    self.frcForRSSFeedsSearch.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchTerm];
    
    return self.frcForRSSFeedsSearch;
}

- (NSFetchedResultsController *)frcWithItemsForRSSFeed:(RSSFeed*)feed {
    
    [self.refreshOperationQueue cancelAllOperations];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.refreshOperationQueue addOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:feed.url];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *err;
        ONOXMLDocument *itemsXML = [ONOXMLDocument XMLDocumentWithData:data
                                                               error:&err];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self parseFeedItemsXML:itemsXML forFeed:feed];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RSSItem"];
    
    NSSortDescriptor *byDate = [NSSortDescriptor sortDescriptorWithKey:@"pubDate" ascending:NO];
    fetchRequest.sortDescriptors = @[byDate];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"feed = %@", feed];
    fetchRequest.fetchLimit = kSMLFetchLimit;
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.managedObjectContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    return fetchedResultsController;
}

- (void)addFeedToMyFeeds:(RSSFeed*)feed withOrdinal:(NSInteger)ordinal {
    
    feed.isInMyFeeds = @YES;
    feed.ordinal = [NSNumber numberWithInteger:ordinal];
    [self saveContext];
}

- (void)removeFeedFromMyFeeds:(RSSFeed*)feed {

    feed.isInMyFeeds = @NO;
    feed.ordinal = @-1;
    [self saveContext];
}

- (void)updateOrdinalsForFeeds:(NSArray*)objects {
    
    for (RSSFeed *feed in objects)
        feed.ordinal = [NSNumber numberWithInteger:[objects indexOfObject:feed]];
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

- (void)parseFeedsJSON:(NSDictionary*)resultsJSON {
    
    NSInteger responseStatus = [[resultsJSON objectForKey:@"responseStatus"] integerValue];
    if (responseStatus != 200) return;
    NSDictionary *responseData = [resultsJSON objectForKey:@"responseData"];
    NSDictionary *entries = [responseData objectForKey:@"entries"];
    NSMutableArray *feeds = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *entry in entries) {
        NSMutableDictionary *feed = [entry mutableCopy];
        NSString *title = [[entry objectForKey:@"title"] stringByConvertingHTMLToPlainText];
        [feed setObject:title forKey:@"title"];
        [titles addObject:title];
        [feeds addObject:feed];
    }
    NSSortDescriptor *byTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [feeds sortUsingDescriptors:@[byTitle]];
    NSArray *feedObjects = [RSSFeed arrayOfExistingFeedsForTitles:titles inContext:self.managedObjectContext];
    NSInteger i, j;
    for (i = 0, j = 0; i < feeds.count; i++) {
        NSString *title = [[feeds objectAtIndex:i] objectForKey:@"title"];
        RSSFeed *feed;
        if (feedObjects.count > j)
            feed = [feedObjects objectAtIndex:j];
        if ([title isEqualToString:feed.title]) {
            j++;
        } else {
            [RSSFeed insertFeedWithDictionary:[feeds objectAtIndex:i] inContext:self.managedObjectContext];
        }
    }
    [self saveContext];
}

- (void)parseFeedItemsXML:(ONOXMLDocument*)itemsXML forFeed:(RSSFeed*)feed {
    
    ONOXMLElement *channel = [itemsXML.rootElement firstChildWithTag:@"channel"];
    
    NSArray *items = [channel childrenWithTag:@"item"];
    
    NSMutableArray *itemsToAdd = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    
    for (ONOXMLElement *element in items) {
        NSMutableDictionary *item = [[NSDictionary dictionaryFromXML:element] mutableCopy];
        [item setObject:feed forKey:@"feed"];
        NSString *title = [[item objectForKey:@"title"] stringByConvertingHTMLToPlainText];
        [titles addObject:title];
        [itemsToAdd addObject:item];
    }
    NSSortDescriptor *byTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [itemsToAdd sortUsingDescriptors:@[byTitle]];
    NSArray *itemObjects = [RSSItem arrayOfExistingItemsForTitles:titles inContext:self.managedObjectContext];
    NSInteger i, j;
    for (i = 0, j = 0; i < itemsToAdd.count; i++) {
        NSString *title = [[itemsToAdd objectAtIndex:i] objectForKey:@"title"];
        RSSItem *item;
        if (itemObjects.count > j)
            item = [itemObjects objectAtIndex:j];
        if ([title isEqualToString:item.title]) {
            j++;
        } else {
            [RSSItem insertItemWithDictionary:[itemsToAdd objectAtIndex:i] inContext:self.managedObjectContext];
        }
    }
    [self saveContext];
}

@end
