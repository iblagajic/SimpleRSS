//
//  SMLFeedsManagerTableViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLFeedsManagerTableViewController.h"
#import "SMLFeedItemsTableViewController.h"
#import "RSSFeed.h"
#import "SMLDataController.h"
#import "SMLFetchedResultsControllerDataSource.h"
#import "SMLAddFeedTableViewController.h"

@interface SMLFeedsManagerTableViewController () <NSFetchedResultsControllerDelegate, SMLFetchedResultsControllerDataSourceDelegate>

@property (nonatomic) SMLFetchedResultsControllerDataSource *frcDataSource;

@end

@implementation SMLFeedsManagerTableViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"My Feeds";
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setup];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.frcDataSource.delegate = nil;
    self.frcDataSource = nil;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {

    [super setEditing:editing animated:animated];
    
    self.navigationItem.leftBarButtonItem.enabled = !editing;
}

- (void)setup {
    
    self.frcDataSource = [[SMLFetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    self.frcDataSource.fetchedResultsController = [[SMLDataController sharedController] frcWithMyRSSFeeds];
    self.frcDataSource.delegate = self;
    self.frcDataSource.reuseIdentifier = @"Cell";
    self.frcDataSource.allowReorderingCells = YES;
}


#pragma mark - SMLFetchedResultsControllerDataSourceDelegate

- (void)configureCell:(UITableViewCell*)cell withObject:(RSSFeed*)object {
    
    cell.textLabel.text = object.title;
}

- (void)deleteObject:(id)object {
    
    [[SMLDataController sharedController] removeFeedFromMyFeeds:object];
}

- (void)updateInterfaceForObjectsCount:(NSInteger)count {

    if (count == 0) {
        if (self.tableView.editing) {
            self.editing = NO;
        }
    }
    self.navigationItem.rightBarButtonItem.enabled = count != 0;
}

- (void)objectMovedFrom:(NSIndexPath *)fromIndexPath to:(NSIndexPath *)toIndexPath {
   
    NSMutableArray *objects = [self.frcDataSource.fetchedResultsController.fetchedObjects mutableCopy];
    id objectToMove = [objects objectAtIndex:fromIndexPath.row];
    [objects removeObjectAtIndex:fromIndexPath.row];
    [objects insertObject:objectToMove atIndex:toIndexPath.row];
    
    [[SMLDataController sharedController] updateOrdinalsForFeeds:objects];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowFeed"]) {
        NSParameterAssert([sender isKindOfClass:[UITableViewCell class]]);
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        RSSFeed *feed = [self.frcDataSource.fetchedResultsController objectAtIndexPath:indexPath];
        SMLFeedItemsTableViewController *destinationViewController = (SMLFeedItemsTableViewController*)segue.destinationViewController;
        [destinationViewController setupWithFeed:feed];
    } else if ([segue.identifier isEqualToString:@"ShowSearch"]) {
        UINavigationController *destinationNavigationController = (UINavigationController*)segue.destinationViewController;
        SMLAddFeedTableViewController *searchViewController = (SMLAddFeedTableViewController*)destinationNavigationController.topViewController;
        [searchViewController setup];
    }
}

@end
