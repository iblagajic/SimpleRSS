//
//  SMLFeedsTableViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLFeedsTableViewController.h"
#import "SMLFeedItemsTableViewController.h"
#import "SMLDataController.h"
#import "SMLFetchedResultsControllerDataSource.h"
#import "SMLAddFeedTableViewController.h"

@interface SMLFeedsTableViewController () <NSFetchedResultsControllerDelegate, SMLFetchedResultsControllerDataSourceDelegate>

@property (nonatomic) SMLFetchedResultsControllerDataSource *frcDataSource;

@end

@implementation SMLFeedsTableViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSParameterAssert(self.channel);
    self.title = self.channel.name;
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {

    [super setEditing:editing animated:animated];
}

- (void)setup {
    
    self.frcDataSource = [[SMLFetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    self.frcDataSource.fetchedResultsController = [[SMLDataController sharedController] frcWithFeedsForChannel:self.channel];
    self.frcDataSource.delegate = self;
}


#pragma mark - SMLFetchedResultsControllerDataSourceDelegate

- (void)configureCell:(UITableViewCell*)cell withObject:(SMLFeed*)object {
    
    cell.textLabel.text = object.title;
}

- (void)deleteObject:(id)object {
    
//    [[SMLDataController sharedController] removeFeedFromMyFeeds:object];
}

- (void)updateInterfaceForObjectsCount:(NSInteger)count {

//    if (count == 0) {
//        if (self.tableView.editing) {
//            self.editing = NO;
//        }
//    }
//    self.navigationItem.rightBarButtonItem.enabled = count != 0;
}

- (NSString*)identifierForCellAtIndexPath:(NSIndexPath *)indexPath {
    return @"Cell";
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowFeed"]) {
        NSParameterAssert([sender isKindOfClass:[UITableViewCell class]]);
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        SMLFeed *feed = [self.frcDataSource.fetchedResultsController objectAtIndexPath:indexPath];
        SMLFeedItemsTableViewController *destinationViewController = (SMLFeedItemsTableViewController*)segue.destinationViewController;
        [destinationViewController setupWithFeed:feed];
    } else if ([segue.identifier isEqualToString:@"ShowSearch"]) {
        UINavigationController *destinationNavigationController = (UINavigationController*)segue.destinationViewController;
        SMLAddFeedTableViewController *searchViewController = (SMLAddFeedTableViewController*)destinationNavigationController.topViewController;
        [searchViewController setupWithChannel:self.channel];
    }
}

@end
