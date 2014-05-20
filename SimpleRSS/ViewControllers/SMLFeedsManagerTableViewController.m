//
//  SMLFeedsManagerTableViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLFeedsManagerTableViewController.h"
#import "SMLFeedItemsViewController.h"
#import "RSSFeed.h"
#import "SMLDataController.h"
#import "SMLFetchedResultsControllerDataSource.h"

@interface SMLFeedsManagerTableViewController () <NSFetchedResultsControllerDelegate, SMLFetchedResultsControllerDataSourceDelegate>

@property (nonatomic) SMLFetchedResultsControllerDataSource *frcDataSource;

@end

@implementation SMLFeedsManagerTableViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.frcDataSource = [[SMLFetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    self.frcDataSource.fetchedResultsController = [[SMLDataController sharedController] frcWithMyRSSFeeds];
    self.frcDataSource.delegate = self;
    self.frcDataSource.reuseIdentifier = @"Cell";
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"My Feeds";
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


#pragma mark - SMLFetchedResultsControllerDataSourceDelegate

- (void)configureCell:(UITableViewCell*)cell withObject:(RSSFeed*)object {
    cell.textLabel.text = object.title;
}


#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"PushFeed"]) {
//        NSParameterAssert([sender isKindOfClass:[UITableViewCell class]]);
//        UITableViewCell *cell = (UITableViewCell*)sender;
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//        RSSFeed *feed = [self.fetchedResultsController objectAtIndexPath:indexPath];
//        SMLFeedItemsViewController *destinationViewController = (SMLFeedItemsViewController*)segue.destinationViewController;
//        destinationViewController.feed = feed;
//    }
//}

@end
