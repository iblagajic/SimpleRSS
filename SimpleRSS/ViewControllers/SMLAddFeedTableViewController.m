//
//  SMLAddFeedTableViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLAddFeedTableViewController.h"
#import "SMLDataController.h"
#import "SMLFeed.h"
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
@property (nonatomic) SMLChannel *channel;

@end

@implementation SMLAddFeedTableViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    self.searchDisplayController.searchBar.searchBarStyle = UISearchBarStyleDefault;
    self.navigationItem.titleView.tintColor = [UIColor blackColor];
}

- (void)dealloc {
    [self.searchTimer invalidate];
}

- (void)setupWithChannel:(SMLChannel *)channel {
    self.frcDataSource = [[SMLFetchedResultsControllerDataSource alloc] initWithTableView:nil];
    self.searchDisplayController.searchResultsDataSource = self.frcDataSource;
    self.frcDataSource.delegate = self;
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

    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (NSString*)identifierForCellAtIndexPath:(NSIndexPath *)indexPath {
    return @"Cell";
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndexPath = indexPath;
    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:@"Add Feed to Channel"
                                                       message:[NSString stringWithFormat:@"Do you want to add feed to \"%@\" channel?", self.channel.name]
                                                      delegate:self
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"Add", nil];
    [addAlert show];
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
        SMLFeed *feed = [self.frcDataSource.fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
        [self.dataController addFeed:feed toChannel:self.channel];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saved"
                                                            message:@"Feed Added Successfully."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    self.selectedIndexPath = nil;
}


#pragma mark - helpers

- (void)searchForCurrentTerm {
    
    self.frcDataSource.fetchedResultsController = [[SMLDataController sharedController] frcWithFeedsContainingString:self.searchDisplayController.searchBar.text];
    self.searchDisplayController.searchResultsDataSource = self.frcDataSource;
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (SMLDataController*)dataController {
    return [SMLDataController sharedController];
}

@end
