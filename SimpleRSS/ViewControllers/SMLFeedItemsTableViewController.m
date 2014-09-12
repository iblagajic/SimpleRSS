//
//  SMLFeedItemsTableViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 16/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLFeedItemsTableViewController.h"
#import "UIViewController+ScrollingNavbar.h"
#import "RSSItem.h"
#import "SMLFetchedResultsControllerDataSource.h"
#import "SMLDataController.h"
#import "SMLWebViewController.h"

#define kCellPadding 20.0
#define kCellTextPadding 12.0
#define kBottomLabelHeight 11.0

@interface SMLFeedItemsTableViewController () <NSFetchedResultsControllerDelegate, SMLFetchedResultsControllerDataSourceDelegate>

@property (strong, nonatomic) SMLFetchedResultsControllerDataSource *frcDataSource;
@property (strong, nonatomic) RSSFeed *feed;

@end

@implementation SMLFeedItemsTableViewController

- (void)setupWithFeed:(RSSFeed*)feed {
    
    self.feed = feed;
    self.frcDataSource = [[SMLFetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    self.frcDataSource.fetchedResultsController = [[SMLDataController sharedController] frcWithItemsForRSSFeed:self.feed];
    self.frcDataSource.delegate = self;
    self.frcDataSource.reuseIdentifier = @"Cell";
    
    self.title = self.feed.title;
}


#pragma mark - SMLMasterViewController

- (void)configureCell:(UITableViewCell*)cell withObject:(id)object {
    
    for (UIView *subview in cell.contentView.subviews)
         [subview removeFromSuperview];
    
    RSSItem *item = (RSSItem*)object;
    
    CGFloat height = kCellPadding;

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
    height += CGRectGetHeight(descriptionFrame) + 1.5 * kCellTextPadding;
    [cell.contentView addSubview:descriptionLabel];

    NSString *dateString = [item.pubDate mediumStyleDateString];
    CGRect dateFrame = CGRectMake(kCellTextPadding,
                                  height,
                                  (CGRectGetWidth(self.tableView.frame) - 2*kCellTextPadding)/2,
                                  kBottomLabelHeight);
    UILabel *dateLabel = [UILabel cellDateLabelWithFrame:dateFrame andText:dateString];
    [cell.contentView addSubview:dateLabel];
    
    CGRect feedFrame = CGRectMake(kCellTextPadding + (CGRectGetWidth(self.tableView.frame) - 2*kCellTextPadding)/2,
                                  height,
                                  (CGRectGetWidth(self.tableView.frame) - 2*kCellTextPadding)/2,
                                  kBottomLabelHeight);
    UILabel *feedLabel = [UILabel cellFeedLabelWithFrame:feedFrame andText:item.feed.title];
    height += CGRectGetHeight(feedFrame) + kCellTextPadding;
    [cell.contentView addSubview:feedLabel];
    
//    height += CGRectGetHeight(dateFrame) + kCellPadding;
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RSSItem *item = [self.frcDataSource.fetchedResultsController objectAtIndexPath:indexPath];
    return [self heightForCellWithRSSItem:item];
}


#pragma mark - helpers

- (CGFloat)heightForCellWithRSSItem:(RSSItem*)item {
    
    CGFloat height = 2*kCellPadding;
    
    height += [UILabel heightForTitleLabelWithText:item.title andMaximumSize:self.maximumLabelSize];
    height += kCellTextPadding;

    height += [UILabel heightForDescriptionLabelWithText:item.text andMaximumSize:self.maximumLabelSize];
    height += kCellTextPadding;

    height += kBottomLabelHeight;
    
//    NSLog(@"Predicted height: %f", height);

    return height;
}

- (CGSize)maximumLabelSize {
    
    CGSize size = self.tableView.frame.size;
    size.width -= 2*kCellTextPadding;
    size.height = MAXFLOAT;
    
    return size;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowWeb"]) {
        NSParameterAssert([sender isKindOfClass:[UITableViewCell class]]);
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        RSSItem *item = [self.frcDataSource.fetchedResultsController objectAtIndexPath:indexPath];
        UINavigationController *destinationNavigationController = segue.destinationViewController;
        SMLWebViewController *destinationViewController = (SMLWebViewController*)destinationNavigationController.topViewController;
        destinationViewController.item = item;
    }
}

@end
