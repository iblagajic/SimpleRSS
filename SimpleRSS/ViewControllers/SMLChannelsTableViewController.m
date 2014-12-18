//
//  SMLChannelsTableViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 09/12/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLChannelsTableViewController.h"
#import "SMLFetchedResultsControllerDataSource.h"
#import "SMLDataController.h"

@interface SMLChannelsTableViewController () <SMLFetchedResultsControllerDataSourceDelegate, UIAlertViewDelegate>

@property (nonatomic) SMLFetchedResultsControllerDataSource *frcDataSource;
@property (nonatomic, readonly) SMLDataController *dataController;

@end

@implementation SMLChannelsTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Channels";
    [self setup];
}

- (void)setup {
    
    self.frcDataSource = [[SMLFetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    self.frcDataSource.fetchedResultsController = [self.dataController frcWithChannels];
    self.frcDataSource.allowReorderingCells = SMLTableViewAllowReorderingAll;
    self.frcDataSource.delegate = self;
}


#pragma mark - actions

- (IBAction)addNewChannel:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add new channel"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Add", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].placeholder = @"Name";
    [alertView show];
}


#pragma mark - SMLFetchedResultsControllerDataSourceDelegate

- (void)configureCell:(UITableViewCell*)cell withObject:(SMLChannel*)object {
    
    cell.textLabel.text = object.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d feeds", object.feeds.count];
}

- (void)didReorderObjects:(NSArray *)array {
    [self.dataController updateOrdinals:array];
}

- (NSString*)identifierForCellAtIndexPath:(NSIndexPath*)indexPath {
    
    return @"StandardCell";
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowChannelItems" sender:cell];
}

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                      title:@"More"
                                                                    handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                        
                                                                    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                      title:@"Delete"
                                                                    handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                        [self.dataController deleteChannel:[self channelAtIndexPath:indexPath]];
                                                                    }];
    
    return @[deleteAction, moreAction];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        NSString *name = [alertView textFieldAtIndex:0].text;
        [self.dataController addChannelWithName:name];
    }
}


#pragma mark - helpers

- (SMLDataController*)dataController {
    return [SMLDataController sharedController];
}

- (SMLChannel*)channelAtIndexPath:(NSIndexPath*)indexPath {
    
    return [self.frcDataSource.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
}


#pragma mark - navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowChannelItems"]) {
        
    }
}

@end
