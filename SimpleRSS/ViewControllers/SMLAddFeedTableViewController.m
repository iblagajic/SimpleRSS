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

typedef NS_ENUM(NSInteger, UIAlertViewButtonIndex) {
    UIAlertViewButtonIndexCancel,
    UIAlertViewButtonIndexAction
};

@interface SMLAddFeedTableViewController () <UISearchDisplayDelegate, UIAlertViewDelegate, UITableViewDelegate, SMLFetchedResultsControllerDataSourceDelegate>

@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) SMLFetchedResultsControllerDataSource *frcDataSource;
@property (nonatomic) UILabel *searchDisplayControllerLabel;
@property (nonatomic) NSTimer *searchTimer;

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

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.searchTimer invalidate];
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
    
    [self.searchTimer invalidate];
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(searchForCurrentTerm) userInfo:nil repeats:NO];
    return NO;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    if (buttonIndex == UIAlertViewButtonIndexAction) {
        RSSFeed *feed = [self.frcDataSource.fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
        if (feed.isInMyFeedsValue) {
            [self.dataController removeFeedFromMyFeeds:feed];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Feed Removed Successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        } else {
            [self.dataController addFeedToMyFeeds:feed];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Feed Saved Successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }
    self.selectedIndexPath = nil;
}


#pragma mark - helpers

- (void)searchForCurrentTerm {
    
    self.frcDataSource.fetchedResultsController = [[SMLDataController sharedController] frcWithRSSFeedsContainingString:self.searchDisplayController.searchBar.text];
    self.searchDisplayController.searchResultsDataSource = self.frcDataSource;
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (SMLDataController*)dataController {
    return [SMLDataController sharedController];
}

@end
