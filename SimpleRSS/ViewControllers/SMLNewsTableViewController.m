//
//  SMLNewsTableViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 16/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLNewsTableViewController.h"
#import "UIViewController+ScrollingNavbar.h"
#import "SMLItem.h"
#import "SMLFetchedResultsControllerDataSource.h"
#import "SMLDataController.h"
#import "SMLArticleViewController.h"
#import "SMLFeedsTableViewController.h"
#import "SMLNoDataView.h"
#import "SMLSearchTableViewController.h"

#define kCellPadding         20.0
#define kCellTextPadding     12.0
#define kSmallLabelHeight    12.0

@interface SMLNewsTableViewController () <NSFetchedResultsControllerDelegate, SMLFetchedResultsControllerDataSourceDelegate>

@property (nonatomic) SMLFetchedResultsControllerDataSource *frcDataSource;
@property (nonatomic) SMLChannel *channel;
@property (nonatomic) SMLFeed *feed;
@property (nonatomic) SMLNoDataView *overlayView;
@property (nonatomic, readonly) SMLDataController *dataController;

@end

@implementation SMLNewsTableViewController


- (void)setupWithChannel:(SMLChannel*)channel {
    self.title = channel.name;
    self.channel = channel;
}

- (void)setupWithFeed:(SMLFeed*)feed {
    self.title = feed.title;
    self.feed = feed;
}


#pragma mark - SMLFetchedResultsControllerDataSourceDelegate

- (void)configureCell:(UITableViewCell*)cell withObject:(id)object {
    
    for (UIView *subview in cell.contentView.subviews)
         [subview removeFromSuperview];
    
    SMLItem *item = (SMLItem*)object;
    
    CGFloat height = kCellPadding;
    
    CGRect feedFrame = CGRectMake(kCellTextPadding,
                                  height,
                                  (CGRectGetWidth(self.tableView.frame) - 2*kCellTextPadding)/2,
                                  kSmallLabelHeight);
    UILabel *feedLabel = [UILabel cellFeedLabelWithFrame:feedFrame andText:item.feed.title];
    height += CGRectGetHeight(feedFrame) + kCellTextPadding/2;
    [cell.contentView addSubview:feedLabel];

    CGRect titleFrame = CGRectMake(kCellTextPadding,
                                   height,
                                   CGRectGetWidth(self.tableView.frame) - 2*kCellTextPadding,
                                   [UILabel heightForTitleLabelWithText:item.title andMaximumSize:self.maximumLabelSize]);
    UILabel *titleLabel = [UILabel cellTitleLabelWithFrame:titleFrame andText:item.title];
    height += CGRectGetHeight(titleFrame) + kCellTextPadding;
    [cell.contentView addSubview:titleLabel];
    
    CGRect descriptionFrame = CGRectMake(kCellTextPadding,
                                         height,
                                         CGRectGetWidth(self.tableView.frame) - 2*kCellTextPadding,
                                         [UILabel heightForDescriptionLabelWithText:item.text andMaximumSize:self.maximumLabelSize]);
    UILabel *descriptionLabel = [UILabel cellDescriptionLabelWithFrame:descriptionFrame andText:item.text];
    height += CGRectGetHeight(descriptionFrame) + kCellTextPadding/2;
    [cell.contentView addSubview:descriptionLabel];

    NSString *dateString = [item.pubDate mediumStyleDateString];
    CGRect dateFrame = CGRectMake(kCellTextPadding,
                                  height,
                                  (CGRectGetWidth(self.tableView.frame) - 2*kCellTextPadding)/2,
                                  kSmallLabelHeight);
    UILabel *dateLabel = [UILabel cellDateLabelWithFrame:dateFrame andText:dateString];
    [cell.contentView addSubview:dateLabel];
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


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SMLItem *item = [self.frcDataSource.fetchedResultsController objectAtIndexPath:indexPath];
    return [self heightForCellWithSMLItem:item];
}


#pragma mark - helpers

- (CGFloat)heightForCellWithSMLItem:(SMLItem*)item {
    
    CGFloat height = 2*kCellPadding;
    
    height += kSmallLabelHeight;
    height += kCellTextPadding/2;
    
    height += [UILabel heightForTitleLabelWithText:item.title andMaximumSize:self.maximumLabelSize];
    height += kCellTextPadding;

    height += [UILabel heightForDescriptionLabelWithText:item.text andMaximumSize:self.maximumLabelSize];
    height += kCellTextPadding/2;

    height += kSmallLabelHeight;
    
//    NSLog(@"Predicted height: %f", height);

    return height;
}

- (CGSize)maximumLabelSize {
    
    CGSize size = self.tableView.frame.size;
    size.width -= 2*kCellTextPadding;
    size.height = 120.0;
    
    return size;
}

- (void)addOverlayViewIfNeeded {
    
    if (!self.overlayView) {
        self.overlayView = [[SMLNoDataView alloc] initWithFrame:self.view.bounds message:@"There aren't any news to show at the moment. Please add some feeds to channel."];
        __weak SMLNewsTableViewController *weakSelf = self;
        [self.overlayView addActionButtonWithText:@"Add Feeds" actionBlock:^{
            SMLNewsTableViewController *strongSelf = weakSelf;
            [strongSelf performSegueWithIdentifier:@"ShowSearch" sender:nil];
        }];
        [self.view addSubview:self.overlayView];
    }
}

- (NSFetchedResultsController*)fetchedResultsController {
    if (self.channel) {
        return [self.dataController frcWithItemsForChannel:self.channel];
    }
    else if (self.feed) {
        return [self.dataController frcWithItemsForFeed:self.feed];
    }
    return nil;
}

- (SMLDataController*)dataController {
    return [SMLDataController sharedController];
}


#pragma mark - navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowArticle"]) {
        NSParameterAssert([sender isKindOfClass:[UITableViewCell class]]);
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        SMLItem *item = [self.frcDataSource.fetchedResultsController objectAtIndexPath:indexPath];
        UINavigationController *destinationNavigationController = segue.destinationViewController;
        SMLArticleViewController *destinationViewController = (SMLArticleViewController*)destinationNavigationController.topViewController;
        [destinationViewController generateArticleJSONForURLString:item.link andFeedName:item.feed.title];
    }
    else if ([segue.identifier isEqualToString:@"ShowChannelSettings"]) {
        SMLFeedsTableViewController *destinationViewController = segue.destinationViewController;
        [destinationViewController setupWithChannel:self.channel];
    }
    else if ([segue.identifier isEqualToString:@"ShowSearch"]) {
        UINavigationController *destinationNavigationController = (UINavigationController*)segue.destinationViewController;
        SMLSearchTableViewController *searchViewController = (SMLSearchTableViewController*)destinationNavigationController.topViewController;
        [searchViewController setupWithChannel:self.channel];
    }
}

@end
