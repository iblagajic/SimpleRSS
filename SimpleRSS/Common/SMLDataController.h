//
//  SMLDataController.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 18/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMLFeed.h"
#import "SMLItem.h"
#import "SMLChannel.h"

@interface SMLDataController : NSObject

+ (id)sharedController;

- (NSFetchedResultsController *)frcWithChannels;
- (void)addChannelWithName:(NSString*)name;
- (void)deleteChannel:(SMLChannel*)channel;

- (NSFetchedResultsController*)frcWithFeedsForChannel:(SMLChannel*)channel;

- (NSFetchedResultsController *)frcWithItemsForSMLFeed:(SMLFeed*)feed;
- (NSFetchedResultsController *)frcWithFeedsContainingString:(NSString*)searchTerm;

- (void)addFeedToMyFeeds:(SMLFeed*)feed;
- (void)removeFeedFromMyFeeds:(SMLFeed*)feed;

- (void)updateOrdinals:(NSArray*)objects;

@end
