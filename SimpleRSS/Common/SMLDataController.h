//
//  SMLDataController.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 18/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RSSFeed.h"
#import "RSSItem.h"

@interface SMLDataController : NSObject

+ (id)sharedController;
- (NSFetchedResultsController *)frcWithMyRSSFeeds;
- (NSFetchedResultsController *)frcWithItemsForRSSFeed:(RSSFeed*)feed;
- (NSFetchedResultsController *)frcWithRSSFeedsContainingString:(NSString*)searchTerm;
- (void)addFeedToMyFeeds:(RSSFeed*)feed;
- (void)removeFeedFromMyFeeds:(RSSFeed*)feed;
- (void)updateOrdinalsForMyFeeds;

@end
