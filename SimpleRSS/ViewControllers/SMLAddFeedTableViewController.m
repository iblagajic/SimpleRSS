//
//  SMLAddFeedTableViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLAddFeedTableViewController.h"
#import "SMLDataController.h"
#import "RSSFeed.h"
#import "SMLFetchedResultsControllerDataSource.h"
#import <PromiseKit/Promise.h>
#import <MRProgress/MRProgress.h>

typedef NS_ENUM(NSInteger, UIAlertViewButtonIndex) {
    UIAlertViewButtonIndexCancel,
    UIAlertViewButtonIndexAction
};

@interface SMLAddFeedTableViewController () <UISearchDisplayDelegate ,UISearchBarDelegate, UIAlertViewDelegate, UITableViewDelegate, SMLFetchedResultsControllerDataSourceDelegate>

@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) SMLFetchedResultsControllerDataSource *frcDataSource;
@property (nonatomic) UILabel *searchDisplayControllerLabel;

@end

@implementation SMLAddFeedTableViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    self.searchDisplayController.searchBar.searchBarStyle = UISearchBarStyleDefault;
    self.navigationItem.titleView.tintColor = [UIColor blackColor];
}

- (void)setup {
    
    self.frcDataSource = [[SMLFetchedResultsControllerDataSource alloc] initWithTableView:nil];
    self.searchDisplayController.searchResultsDataSource = self.frcDataSource;
    self.frcDataSource.delegate = self;
    self.frcDataSource.reuseIdentifier = @"Cell";
}


#pragma mark - SMLFetchedResultsControllerDataSourceDelegate

- (void)configureCell:(UITableViewCell*)cell withObject:(RSSFeed*)object {
    if (object.isInMyFeedsValue)
        cell.textLabel.font = [UIFont myFeedsCellTitleFont];
    else
        cell.textLabel.font = [UIFont cellTitleFont];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = object.title;
}

- (void)updateInterfaceForObjectsCount:(NSInteger)count {

    [self.searchDisplayController.searchResultsTableView reloadData];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndexPath = indexPath;
    RSSFeed *feed = [self.frcDataSource.fetchedResultsController objectAtIndexPath:indexPath];
    if (feed.isInMyFeedsValue){
        UIAlertView *removeAlert = [[UIAlertView alloc] initWithTitle:@"Remove from My Feeds?" message:feed.snippet delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Remove", nil];
        [removeAlert show];
    } else {
        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:@"Add to My Feeds?" message:feed.snippet delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Add", nil];
        [addAlert show];
    }
}


#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.frcDataSource = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UISearchDisplayController

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    self.frcDataSource.fetchedResultsController = [[SMLDataController sharedController] frcWithRSSFeedsContainingString:searchString];
    self.searchDisplayController.searchResultsDataSource = self.frcDataSource;
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    if (buttonIndex == UIAlertViewButtonIndexAction) {
        RSSFeed *feed = [self.frcDataSource.fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
        NSInteger count = self.frcDataSource.fetchedResultsController.fetchedObjects.count;
        if (feed.isInMyFeedsValue) {
            [self.dataController removeFeedFromMyFeeds:feed];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Feed Removed Successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        } else {
            [self.dataController addFeedToMyFeeds:feed withOrdinal:count];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Feed Saved Successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }
    self.selectedIndexPath = nil;
}


// This is mostly a hack, but I really really wanted to change that text
- (void)changeSearchDisplayControllerNoResultsStringTo:(NSString*)newString {
    
    if (self.searchDisplayControllerLabel) {
        self.searchDisplayControllerLabel.font = [UIFont barTitleFont];
        self.searchDisplayControllerLabel.text = newString;
    }
}

- (UILabel*)labelWithNoResultsTextInView:(UIView*)view {
    
    for (UILabel *subview in view.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel*)subview;
            if ([label.text isEqualToString:@"No Results"])
                return label;
        }
        UILabel *label = [self labelWithNoResultsTextInView:subview];
        if (label) return label;
    }
    
    return nil;
}

- (SMLDataController*)dataController {
    return [SMLDataController sharedController];
}

@end