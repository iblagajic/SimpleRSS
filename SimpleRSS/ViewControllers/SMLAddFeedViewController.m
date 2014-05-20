//
//  SMLAddFeedViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLAddFeedViewController.h"
#import "SMLDataController.h"
#import "RSSFeed.h"
#import "SMLFetchedResultsControllerDataSource.h"

typedef NS_ENUM(NSInteger, UIAlertViewButtonIndex) {
    UIAlertViewButtonIndexCancel,
    UIAlertViewButtonIndexAdd
};

@interface SMLAddFeedViewController () <UISearchDisplayDelegate ,UISearchBarDelegate, UIAlertViewDelegate, UITableViewDelegate, SMLFetchedResultsControllerDataSourceDelegate>

@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) SMLFetchedResultsControllerDataSource *frcDataSource;

@end

@implementation SMLAddFeedViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.frcDataSource = [[SMLFetchedResultsControllerDataSource alloc] initWithTableView:self.searchDisplayController.searchResultsTableView];
    self.frcDataSource.delegate = self;
    self.frcDataSource.reuseIdentifier = @"Cell";
    
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    self.searchDisplayController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.searchDisplayController.searchBar becomeFirstResponder];
}


#pragma mark - SMLFetchedResultsControllerDataSourceDelegate

- (void)configureCell:(UITableViewCell*)cell withObject:(RSSFeed*)object {
    cell.textLabel.font = [UIFont titleFont];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = object.title;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndexPath = indexPath;
    RSSFeed *feed = [self.frcDataSource.fetchedResultsController objectAtIndexPath:indexPath];
    UIAlertView *exampleAlert = [[UIAlertView alloc] initWithTitle:@"Add to My Feeds?" message:feed.snippet delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Add", nil];
    [exampleAlert show];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UISearchDisplayController

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    self.frcDataSource.fetchedResultsController = [[SMLDataController sharedController] frcWithRSSFeedsContainingString:[searchString stringByAppendingString:@" "]];
    return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    
    [self changeSearchDisplayControllerNoResultsStringTo:@"Searching..."];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    
    self.frcDataSource.fetchedResultsController = [[SMLDataController sharedController] frcWithRSSFeedsContainingString:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    if (buttonIndex == UIAlertViewButtonIndexAdd) {
        RSSFeed *feed = [self.frcDataSource.fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
        [self.dataController addFeedToMyFeeds:feed];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"RSS Saved Successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    self.selectedIndexPath = nil;
}




// This is mostly a hack, but I really really wanted to change that text
- (void)changeSearchDisplayControllerNoResultsStringTo:(NSString*)newString {
    
    UILabel *noResultsLabel = [self labelWithNoResultsTextInView:self.searchDisplayController.searchResultsTableView];
    if (noResultsLabel) {
        noResultsLabel.font = [UIFont barTitleFont];
        noResultsLabel.text = newString;
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
