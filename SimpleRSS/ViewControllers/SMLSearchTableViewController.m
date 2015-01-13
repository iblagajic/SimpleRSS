//
//  SMLSearchTableViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLSearchTableViewController.h"
#import "SMLDataController.h"
#import "SMLFeed.h"
#import "SMLFetchedResultsControllerDataSource.h"
#import <PromiseKit/Promise.h>

typedef NS_ENUM(NSInteger, UIAlertViewButtonIndex) {
    UIAlertViewButtonIndexCancel,
    UIAlertViewButtonIndexAction
};

@interface SMLSearchTableViewController () <UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate , UIAlertViewDelegate, UITableViewDelegate>

@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) NSTimer *searchTimer;
@property (nonatomic) SMLChannel *channel;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, readonly) SMLDataController *dataController;

@end

@implementation SMLSearchTableViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.showsCancelButton = YES;
    self.definesPresentationContext = YES;
    self.searchController.active = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
}

- (void)dealloc {
    [self.searchTimer invalidate];
}

- (void)setupWithChannel:(SMLChannel *)channel {
    self.channel = channel;
}


#pragma mark - SMLFetchedResultsControllerDataSourceDelegate

- (void)configureCell:(UITableViewCell*)cell withObject:(SMLFeed*)object {
    
    __block BOOL contains = NO;
    [object.channels enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if ([obj isEqual:self.channel]) {
            contains = YES;
            *stop = YES;
        }
    }];
    if (contains) {
        cell.textLabel.font = [UIFont smlMyFeedsCellTitleFont];
    } else {
        cell.textLabel.font = [UIFont smlCellTitleFont];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = object.title;
}

- (void)updateInterfaceForObjectsCount:(NSInteger)count {
    [self.tableView reloadData];
}

- (NSString*)identifierForCellAtIndexPath:(NSIndexPath *)indexPath {
    return @"Cell";
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SMLFeed *selectedFeed = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *feedSnippet = [NSString stringWithFormat:@"\"%@\"", selectedFeed.snippet];
    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:@"Add Feed to Channel?"
                                                       message:feedSnippet
                                                      delegate:self
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"Add", nil];
    [addAlert show];
    self.selectedIndexPath = indexPath;
}


#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchTimer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.searchTimer invalidate];
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(searchForCurrentTerm) userInfo:nil repeats:NO];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    if (buttonIndex == UIAlertViewButtonIndexAction) {
        SMLFeed *feed = [self.fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
        [self.dataController addFeed:feed toChannel:self.channel];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saved"
//                                                            message:@"Feed Added Successfully."
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
    }
    self.selectedIndexPath = nil;
}


#pragma mark - helpers

- (void)searchForCurrentTerm {
    [self.searchTimer invalidate];
    [self setup];
}

- (SMLDataController*)dataController {
    return [SMLDataController sharedController];
}

- (NSFetchedResultsController*)createFetchedResultsController {
    return [self.dataController frcWithFeedsContainingString:self.searchController.searchBar.text];
}

@end
