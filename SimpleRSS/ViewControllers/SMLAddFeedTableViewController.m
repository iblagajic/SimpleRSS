//
//  SMLAddFeedTableViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLAddFeedTableViewController.h"
#import "SMLRSSFeed.h"

typedef NS_ENUM(NSInteger, UIAlertViewButtonIndex) {
    UIAlertViewButtonIndexCancel,
    UIAlertViewButtonIndexAdd
};

@interface SMLAddFeedTableViewController () <UISearchDisplayDelegate ,UISearchBarDelegate, UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *feeds;
@property (nonatomic) NSOperationQueue *searchQueue;

@end

@implementation SMLAddFeedTableViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    self.searchDisplayController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    self.feeds = [NSMutableArray array];
    self.searchQueue = [NSOperationQueue new];
    self.searchQueue.maxConcurrentOperationCount = 1;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (void)dealloc {
    
    self.feeds = nil;
    [self.searchQueue cancelAllOperations];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.searchQueue = nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) return 0;
    return self.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMLRSSFeed *feed = [self.feeds objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.font = [UIFont titleFont];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = feed.title;
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SMLRSSFeed *feed = [self.feeds objectAtIndex:indexPath.row];
    UIAlertView *exampleAlert = [[UIAlertView alloc] initWithTitle:@"Add to My Feeds?" message:feed.contentSnippet delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Add", nil];
    [exampleAlert show];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UISearchDisplayController

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    if  (![searchString isEqualToString:@""]) {
        [self.searchQueue cancelAllOperations];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.searchQueue addOperationWithBlock:^{
            NSDictionary *results = [self JSONResponseForSearchTerm:[searchString stringByAppendingString:@" "]];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self parseResults:results];
                
                [controller.searchResultsTableView reloadData];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }];
        }];
        
        return NO;
    }
    else
    {
        [self.feeds removeAllObjects];
        [controller.searchResultsTableView reloadData];
        return YES;
    }
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    
    [self.searchQueue cancelAllOperations];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == UIAlertViewButtonIndexAdd) {
        // TODO: Add to My Feeds
    }
}


#pragma mark - helpers

- (NSDictionary*)JSONResponseForSearchTerm:(NSString*)term {
    
    NSString *requestUrlString = [@"https://ajax.googleapis.com/ajax/services/feed/find?v=1.0&q=" stringByAppendingString:[term stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *requestUrl = [NSURL URLWithString:requestUrlString];

    NSError *err;
    NSString *resultString = [NSString stringWithContentsOfURL:requestUrl encoding:NSUTF8StringEncoding error:&err];
    if (err)
        NSLog(@"%@",err);
    NSParameterAssert(resultString);
    
    NSData *resultData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    if (!resultData)
        return nil;
    err = nil;
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&err];
    if (err)
        NSLog(@"%@", err);
    return result;
}

- (void)parseResults:(NSDictionary*)resultsJSON {
    
    [self.feeds removeAllObjects];
    NSDictionary *responseData = [resultsJSON objectForKey:@"responseData"];
    NSDictionary *entries = [responseData objectForKey:@"entries"];
    for (NSDictionary *entry in entries) {
        SMLRSSFeed *feed = [SMLRSSFeed itemWithDictionary:entry];
        [self.feeds addObject:feed];
    }
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
