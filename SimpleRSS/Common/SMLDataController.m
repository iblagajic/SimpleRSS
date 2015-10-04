//
//  SMLDataController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 18/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLDataController.h"
#import <PromiseKit.h>

#define kSMLFetchLimit 25

@interface SMLDataController()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *frcForRSSFeedsSearch;
@property (nonatomic, assign) NSUInteger *liveOperationsCounter;

@end

@implementation SMLDataController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSaveNotification];
    }
    return self;
}

- (void)setupSaveNotification
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification* notification) {
                                                      NSManagedObjectContext *moc = self.managedObjectContext;
                                                      if (notification.object != moc) {
                                                          [moc performBlock:^(){
                                                              [moc mergeChangesFromContextDidSaveNotification:notification];
                                                          }];
                                                      }
                                                  }];
}

- (void)dealloc {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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


#pragma mark - SMLChannel

- (NSFetchedResultsController *)frcWithChannels {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMLChannel"];

    NSSortDescriptor *byOrdinal = [NSSortDescriptor sortDescriptorWithKey:@"ordinal" ascending:YES];
    fetchRequest.sortDescriptors = @[byOrdinal];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:self.managedObjectContext
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    return frc;
}

- (SMLChannel*)addChannelWithName:(NSString*)name {
    NSArray *channels = [SMLChannel channelsInContext:self.managedObjectContext];
    NSNumber *ordinal = @(channels.count);
    SMLChannel *channel = [SMLChannel addChannelWithName:name
                                                 ordinal:ordinal
                                               inContext:self.managedObjectContext];
    [self saveContext];
    return channel;
}

- (void)deleteChannel:(SMLChannel*)channel {
    [self.managedObjectContext deleteObject:channel];
    [self saveContext];
}

- (void)updateOrdinals:(NSArray*)objects {
    
    for (int i = 0; i < objects.count; i++) {
        NSManagedObject *mo = objects[i];
        [mo setValue:@(i) forKey:@"ordinal"];
    }
    [self saveContext];
}


#pragma mark - SMLFeed

- (NSFetchedResultsController*)frcWithFeedsForChannel:(SMLChannel*)channel {
    
    NSParameterAssert(channel);
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMLFeed"];
    
    NSSortDescriptor *byTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    fetchRequest.sortDescriptors = @[byTitle];
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:self.managedObjectContext
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    
    frc.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"channels CONTAINS[cd] %@", channel];
    
    return frc;
}

- (NSFetchedResultsController *)frcWithFeedsContainingString:(NSString*)searchTerm {
    
    if (!searchTerm || [searchTerm isEqualToString:@""]) {
        return nil;
    }
    
    self.liveOperationsCounter = 0;
    
    PMKPromise *refreshPromise = [self JSONResponseForSearchTerm:searchTerm];
    refreshPromise.then(^(NSDictionary *resultsDictionary) {
        NSManagedObjectContext * privateContext = [self newPrivateContext];
        [privateContext performBlockAndWait:^{
            [self parseFeedsJSON:resultsDictionary inContext:privateContext];
            self.liveOperationsCounter--;
            if (self.liveOperationsCounter == 0) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
        }];
    }).catch(^(NSError *error) {
        NSLog(@"%@", error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMLFeed"];
    
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


#pragma mark - SMLItem

- (NSFetchedResultsController *)frcWithItemsForChannel:(SMLChannel*)channel {
    
    NSManagedObjectContext *privateContext = [self newPrivateContext];
    [privateContext performBlockAndWait:^{
        for (SMLFeed *feed in channel.feeds) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            [NSURLConnection GET:feed.url].then(^(NSData *itemsData) {
                
                NSError *err;
                ONOXMLDocument *itemsXML = [ONOXMLDocument XMLDocumentWithData:itemsData
                                                                         error:&err];
                [self parseFeedItemsXML:itemsXML forFeed:feed inContext:privateContext];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }).catch(^(NSError *error) {
                NSLog(@"%@", error);
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }
    }];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMLItem"];
    
    NSSortDescriptor *byDate = [NSSortDescriptor sortDescriptorWithKey:@"pubDate" ascending:NO];
    fetchRequest.sortDescriptors = @[byDate];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"feed.channels CONTAINS[cd] %@", channel];
    fetchRequest.fetchLimit = kSMLFetchLimit;
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:self.managedObjectContext
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    return frc;
}

- (NSFetchedResultsController *)frcWithItemsForFeed:(SMLFeed*)feed {
    
    NSManagedObjectContext *privateContext = [self newPrivateContext];
    [privateContext performBlockAndWait:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [NSURLConnection GET:feed.url].then(^(NSData *itemsData) {
            NSError *err;
            ONOXMLDocument *itemsXML = [ONOXMLDocument XMLDocumentWithData:itemsData
                                                                     error:&err];
            [self parseFeedItemsXML:itemsXML forFeed:feed inContext:privateContext];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }).catch(^(NSError *error) {
            NSLog(@"%@", error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        self.liveOperationsCounter ++;
    }];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SMLItem"];
    
    NSSortDescriptor *byDate = [NSSortDescriptor sortDescriptorWithKey:@"pubDate" ascending:NO];
    fetchRequest.sortDescriptors = @[byDate];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"feed = %@", feed];
    fetchRequest.fetchLimit = kSMLFetchLimit;
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:self.managedObjectContext
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    return frc;
}

- (NSArray*)mySMLFeeds {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RSSFeed"];
    
    NSSortDescriptor *byOrdinal = [NSSortDescriptor sortDescriptorWithKey:@"ordinal" ascending:YES];
    fetchRequest.sortDescriptors = @[byOrdinal];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isInMyFeeds = YES", nil];
    
    NSArray *feeds = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return feeds;
}



- (void)addFeed:(SMLFeed*)feed toChannel:(SMLChannel*)channel {
    if (![feed.managedObjectContext isEqual:channel.managedObjectContext]) {
        NSLog(@"err");
    }
    [feed addChannelsObject:channel];
    [feed.managedObjectContext save:nil];
}

- (void)removeFeed:(SMLFeed*)feed fromChannel:(SMLChannel*)channel {
    
    [feed removeChannelsObject:channel];
    [feed.managedObjectContext save:nil];
}


#pragma mark - helpers

- (PMKPromise*)JSONResponseForSearchTerm:(NSString*)term {
    NSString *urlTerm = [term stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *requestUrlString = [@"https://ajax.googleapis.com/ajax/services/feed/find?v=1.0&q=" stringByAppendingString:urlTerm];
    NSURL *requestUrl = [NSURL URLWithString:requestUrlString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    PMKPromise *feedsPromise = [NSURLConnection GET:requestUrl];
    self.liveOperationsCounter ++;
    
    return feedsPromise;
}

- (void)parseFeedsJSON:(NSDictionary *)resultsJSON inContext:(NSManagedObjectContext *)context {
    
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
    NSArray *feedObjects = [SMLFeed arrayOfExistingFeedsForTitles:titles inContext:context];
    NSInteger i, j;
    for (i = 0, j = 0; i < feeds.count; i++) {
        NSString *title = [[feeds objectAtIndex:i] objectForKey:@"title"];
        SMLFeed *feed;
        if (feedObjects.count > j)
            feed = [feedObjects objectAtIndex:j];
        if ([title isEqualToString:feed.title]) {
            j++;
        } else {
            [SMLFeed insertFeedWithDictionary:[feeds objectAtIndex:i] inContext:context];
        }
    }
    [context save:nil];
}

- (void)parseFeedItemsXML:(ONOXMLDocument *)itemsXML
                  forFeed:(SMLFeed *)feed
                inContext:(NSManagedObjectContext *)context {
    
    if (![feed.managedObjectContext isEqual:context]) {
        feed = [context objectWithID:[feed objectID]];
    }
    ONOXMLElement *channel = [itemsXML.rootElement firstChildWithTag:@"channel"];
    
    NSArray *items = [channel childrenWithTag:@"item"];
    
    NSMutableArray *itemsToAdd = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    
    for (ONOXMLElement *element in items) {
        NSMutableDictionary *item = [[NSDictionary dictionaryFromXML:element] mutableCopy];
        [item setObject:feed forKey:@"feed"];
        NSString *title = [item objectForKey:@"title"] /*stringByConvertingHTMLToPlainText] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]*/;
        [titles addObject:title];
        [itemsToAdd addObject:item];
    }
    NSSortDescriptor *byTitle = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    [itemsToAdd sortUsingDescriptors:@[byTitle]];
    NSArray *itemObjects = [SMLItem arrayOfExistingItemsForTitles:titles inContext:context];
    NSInteger i, j;
    for (i = 0, j = 0; i < itemsToAdd.count; i++) {
        NSString *title = [[itemsToAdd objectAtIndex:i] objectForKey:@"title"];
        SMLItem *item;
        if (itemObjects.count > j) {
            item = [itemObjects objectAtIndex:j];
        }
        if ([[title stringByRemovingNewLinesAndWhitespace] isEqualToString:[item.title stringByRemovingNewLinesAndWhitespace]]) {
            j++;
        } else {
            [SMLItem insertItemWithDictionary:[itemsToAdd objectAtIndex:i] inContext:context];
        }
    }
    [context save:nil];
}

#pragma mark - private context

- (NSManagedObjectContext *)newPrivateContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    return context;
}

@end
