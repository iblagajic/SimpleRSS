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
#import "SMLNoDataView.h"

@interface SMLFeedsTableViewController () <NSFetchedResultsControllerDelegate, SMLFetchedResultsControllerDataSourceDelegate>

@property (nonatomic) SMLFetchedResultsControllerDataSource *frcDataSource;
@property (nonatomic) SMLChannel *channel;
@property (nonatomic) SMLNoDataView *overlayView;

@end

@implementation SMLFeedsTableViewController


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self updateInterfaceForObjectsCount:self.frcDataSource.fetchedResultsController.fetchedObjects.count];
}

-(void)dealloc {
    self.frcDataSource.delegate = nil;
}


#pragma mark - UIViewController

- (void)setupWithChannel:(SMLChannel*)channel {
    
    self.frcDataSource = [[SMLFetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    self.frcDataSource.fetchedResultsController = [[SMLDataController sharedController] frcWithFeedsForChannel:channel];
    self.frcDataSource.delegate = self;
    
    self.title = @"Edit Channel";
    
    self.channel = channel;
}


#pragma mark - SMLFetchedResultsControllerDataSourceDelegate

- (void)configureCell:(UITableViewCell*)cell withObject:(SMLFeed*)object {
    
    cell.textLabel.text = object.title;
}

- (void)deleteObject:(id)object {
    
    [[SMLDataController sharedController] removeFeed:object fromChannel:self.channel];
}

- (NSString*)identifierForCellAtIndexPath:(NSIndexPath *)indexPath {
    return @"Cell";
}

- (void)updateInterfaceForObjectsCount:(NSInteger)count {
    
    if (count == 0) {
        [self addOverlayViewIfNeeded];
    } else {
        if (self.overlayView) {
            [self.overlayView removeFromSuperview];
            self.overlayView = nil;
        }
    }
}


#pragma mark - helpers

- (void)addOverlayViewIfNeeded {
    
    if (!self.overlayView) {
        self.overlayView = [[SMLNoDataView alloc] initWithFrame:self.view.bounds message:@"You haven't added any feeds yet. Why wait?"];
        __weak SMLFeedsTableViewController *weakSelf = self;
        [self.overlayView addActionButtonWithText:@"Add Feeds" actionBlock:^{
            //            SMLFeedsTableViewController *strongSelf = weakSelf;
        }];
        [self.view addSubview:self.overlayView];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowFeed"]) {
        
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
