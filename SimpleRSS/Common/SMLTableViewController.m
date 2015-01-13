//
//  SMLTableViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 10/01/15.
//  Copyright (c) 2015 Simple. All rights reserved.
//

#import "SMLTableViewController.h"
#import "SMLFetchedResultsControllerDataSource.h"
#import "SMLNoDataView.h"

@interface SMLTableViewController () <SMLFetchedResultsControllerDataSourceDelegate>

@property (nonatomic) SMLFetchedResultsControllerDataSource *frcDataSource;

@end

@implementation SMLTableViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateInterfaceForObjectsCount:self.frcDataSource.fetchedResultsController.fetchedObjects.count];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self tearDown];
}

- (void)setup {
    self.frcDataSource = [[SMLFetchedResultsControllerDataSource alloc] initWithTableView:self.tableView fetchedResultsController:[self createFetchedResultsController]];
    self.frcDataSource.allowReorderingCells = SMLTableViewAllowReorderingAll;
    self.frcDataSource.delegate = self;
}

- (void)tearDown {
    self.frcDataSource.delegate = nil;
    self.frcDataSource = nil;
}


#pragma mark - SMLFetchedResultsControllerDataSourceDelegate

- (void)configureCell:(UITableViewCell*)cell withObject:(NSManagedObject*)object {
    NSAssert(NO, @"ERROR: configureCell:withObject: not found");
}

- (NSString*)identifierForCellAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(NO, @"ERROR: identifierForCellAtIndexPath: not found");
    return nil;
}


#pragma mark - helpers

- (NSFetchedResultsController*)createFetchedResultsController {
    NSAssert(NO, @"ERROR: createFetchedResultsController getter not found");
    return nil;
}

- (NSFetchedResultsController*)fetchedResultsController {
    return self.frcDataSource.fetchedResultsController;
}

@end
