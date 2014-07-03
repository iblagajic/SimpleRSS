//
//  SMLFeedItemsViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 16/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLFeedItemsViewController.h"
#import "UIViewController+ScrollingNavbar.h"
#import "RSSItem.h"
#import "SMLFetchedResultsControllerDataSource.h"
#import "SMLDataController.h"

#define kCellPadding 10.0

@interface SMLFeedItemsViewController () <NSFetchedResultsControllerDelegate, SMLFetchedResultsControllerDataSourceDelegate>

@property (strong, nonatomic) SMLFetchedResultsControllerDataSource *frcDataSource;
@property (strong, nonatomic) RSSFeed *feed;

@end

@implementation SMLFeedItemsViewController

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

    CGRect titleFrame = CGRectMake(kCellPadding,
                                   height,
                                   CGRectGetWidth(self.tableView.frame) - 2*kCellPadding,
                                   [UILabel heightForTitleLabelWithText:item.title andMaximumSize:self.maximumLabelSize]);
    UILabel *titleLabel = [UILabel cellTitleLabelWithFrame:titleFrame andText:item.title];
    height += CGRectGetHeight(titleFrame) + kCellPadding;
    [cell.contentView addSubview:titleLabel];
    
    CGRect descriptionFrame = CGRectMake(kCellPadding,
                                         height,
                                         CGRectGetWidth(self.tableView.frame) - 2*kCellPadding,
                                         [UILabel heightForDescriptionLabelWithText:item.text andMaximumSize:self.maximumLabelSize]);
    UILabel *descriptionLabel = [UILabel cellDescriptionLabelWithFrame:descriptionFrame andText:item.text];
    height += CGRectGetHeight(descriptionFrame) + kCellPadding;
    [cell.contentView addSubview:descriptionLabel];

    NSString *dateString = [item.pubDate mediumStyleDateString];
    CGRect dateFrame = CGRectMake(kCellPadding,
                                  height,
                                  CGRectGetWidth(self.tableView.frame) - 2*kCellPadding,
                                  [UILabel heightForDateLabelWithText:dateString andMaximumSize:self.maximumLabelSize]);
    UILabel *dateLabel = [UILabel cellDateLabelWithFrame:dateFrame andText:dateString];
    [cell.contentView addSubview:dateLabel];
    
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
    height += kCellPadding;

    height += [UILabel heightForDescriptionLabelWithText:item.text andMaximumSize:self.maximumLabelSize];
    height += kCellPadding;

    height += [UILabel heightForDateLabelWithText:[item.pubDate mediumStyleDateString] andMaximumSize:self.maximumLabelSize];
    
//    NSLog(@"Predicted height: %f", height);

    return height;
}

- (CGSize)maximumLabelSize {
    
    CGSize size = self.tableView.frame.size;
    size.width -= 2*kCellPadding;
    size.height = MAXFLOAT;
    
    return size;
}

@end
