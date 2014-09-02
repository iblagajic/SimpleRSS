//
//  SMLFeedItemsTableViewController.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 16/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSFeed.h"

@interface SMLFeedItemsTableViewController : UITableViewController

- (void)setupWithFeed:(RSSFeed*)feed;

@end