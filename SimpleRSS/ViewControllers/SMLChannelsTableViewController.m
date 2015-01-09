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
#import "SMLFeedsTableViewController.h"
#import "SMLFeedItemsTableViewController.h"
#import "SMLNoDataView.h"

@interface SMLChannelsTableViewController () <SMLFetchedResultsControllerDataSourceDelegate, UIAlertViewDelegate>

@property (nonatomic) SMLFetchedResultsControllerDataSource *frcDataSource;
@property (nonatomic, readonly) SMLDataController *dataController;
@property (nonatomic) SMLNoDataView *overlayView;

@end

@implementation SMLChannelsTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Channels";
    [self setup];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self updateInterfaceForObjectsCount:self.frcDataSource.fetchedResultsController.fetchedObjects.count];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd feeds", object.feeds.count];
}

- (void)didReorderObjects:(NSArray *)array {
    [self.dataController updateOrdinals:array];
}

- (NSString*)identifierForCellAtIndexPath:(NSIndexPath*)indexPath {
    return @"StandardCell";
}

- (void)deleteObject:(id)object {
    [self.dataController deleteChannel:object];
}

- (void)updateInterfaceForObjectsCount:(NSInteger)count {
    
    if (count == 0) {
        [self addOverlayViewIfNeeded];
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        if (self.overlayView) {
            [self.overlayView removeFromSuperview];
            self.overlayView = nil;
        }
        if (!self.navigationItem.rightBarButtonItem) {
            self.navigationItem.rightBarButtonItem = self.editButtonItem;
        }
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowChannel" sender:cell];
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

- (void)addOverlayViewIfNeeded {
    
    if (!self.overlayView) {
        self.overlayView = [[SMLNoDataView alloc] initWithFrame:self.view.bounds message:@"You don't have any channels yet. Start by creating your first channel."];
        __weak SMLChannelsTableViewController *weakSelf = self;
        [self.overlayView addActionButtonWithText:@"Create Channel" actionBlock:^{
            SMLChannelsTableViewController *strongSelf = weakSelf;
            [strongSelf addNewChannel:nil];
        }];
        [self.view addSubview:self.overlayView];
    }
}


#pragma mark - navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UITableViewCell *cell = (UITableViewCell*)sender;
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:cell];
    SMLChannel *selectedChannel = [self.frcDataSource.fetchedResultsController objectAtIndexPath:selectedIndexPath];
    
    if ([segue.identifier isEqualToString:@"ShowChannel"]) {
        
        SMLFeedItemsTableViewController *destinationViewController = segue.destinationViewController;
        [destinationViewController setupWithChannel:selectedChannel];
    }
}

@end
