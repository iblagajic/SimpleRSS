//
//  SMLFeedsTableViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLFeedsTableViewController.h"
#import "SMLNewsTableViewController.h"
#import "SMLDataController.h"
#import "SMLFetchedResultsControllerDataSource.h"
#import "SMLSearchTableViewController.h"
#import "SMLNoDataView.h"

@interface SMLFeedsTableViewController () <NSFetchedResultsControllerDelegate, SMLFetchedResultsControllerDataSourceDelegate>

@property (nonatomic) SMLFetchedResultsControllerDataSource *frcDataSource;
@property (nonatomic) SMLChannel *channel;
@property (nonatomic) SMLNoDataView *overlayView;
@property (nonatomic, readonly) SMLDataController *dataController;

@end

@implementation SMLFeedsTableViewController


- (void)setupWithChannel:(SMLChannel*)channel {
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
            SMLFeedsTableViewController *strongSelf = weakSelf;
            [strongSelf performSegueWithIdentifier:@"ShowSearch" sender:nil];
        }];
        [self.view addSubview:self.overlayView];
    }
}

- (NSFetchedResultsController*)fetchedResultsController {
    return [self.dataController frcWithFeedsForChannel:self.channel];
}

- (SMLDataController*)dataController {
    return [SMLDataController sharedController];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowNews"]) {
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:cell];
        SMLFeed *selectedFeed = [self.frcDataSource.fetchedResultsController objectAtIndexPath:selectedIndexPath];
        SMLNewsTableViewController *destinationViewController = segue.destinationViewController;
        [destinationViewController setupWithFeed:selectedFeed];
    }
    else if ([segue.identifier isEqualToString:@"ShowSearch"]) {
        UINavigationController *destinationNavigationController = (UINavigationController*)segue.destinationViewController;
        SMLSearchTableViewController *searchViewController = (SMLSearchTableViewController*)destinationNavigationController.topViewController;
        [searchViewController setupWithChannel:self.channel];
    }
}

@end
