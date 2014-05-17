//
//  SMLAddFeedTableViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLAddFeedTableViewController.h"
#import "SMLRSSFeed.h"

@interface SMLAddFeedTableViewController () <UISearchDisplayDelegate ,UISearchBarDelegate>

@property (nonatomic) NSMutableArray *feeds;

@end

@implementation SMLAddFeedTableViewController


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    self.searchDisplayController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    self.feeds = [NSMutableArray array];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMLRSSFeed *feed = [self.feeds objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = feed.title;
    return cell;
}


#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UISearchDisplayController

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    NSDictionary *results = [self JSONResponseForSearchTerm:searchString];
    [self parseResults:results];
    return YES;
}


#pragma mark - helpers

- (NSDictionary*)JSONResponseForSearchTerm:(NSString*)term {
    
    NSString *requestUrlString = [@"https://ajax.googleapis.com/ajax/services/feed/find?v=1.0&q=" stringByAppendingString:term];
    NSURL *requestUrl = [NSURL URLWithString:requestUrlString];
    NSError *err;
    NSString *resultString = [NSString stringWithContentsOfURL:requestUrl encoding:NSUTF8StringEncoding error:&err];
    if (err) {
        NSLog(@"%@",err);
    }
    NSData *resultData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    err = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"%@", err);
    }
    return result;
}

- (void)parseResults:(NSDictionary*)resultsJSON {
    
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
