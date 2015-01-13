//
//  SMLTableViewController.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 10/01/15.
//  Copyright (c) 2015 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SMLTableViewController : UITableViewController

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

- (void)setup;
- (NSFetchedResultsController*)createFetchedResultsController;

@end
