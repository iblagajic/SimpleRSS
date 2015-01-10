//
//  SMLFetchedResultsControllerDataSource.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 19/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLFetchedResultsControllerDataSource.h"

@interface SMLFetchedResultsControllerDataSource() <NSFetchedResultsControllerDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) BOOL isUserDrivenReorder;
@property (nonatomic) BOOL didAddObject;

@end

@implementation SMLFetchedResultsControllerDataSource

- (id)initWithTableView:(UITableView*)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.dataSource = self;
    }
    return self;
}

- (void)setFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController
{
    _fetchedResultsController = fetchedResultsController;
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:NULL];
}

- (void)dealloc {
    
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionIndex {

    id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[sectionIndex];
    return section.numberOfObjects;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {

    NSString *cellIdentifier = [self.delegate identifierForCellAtIndexPath:indexPath];
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                              forIndexPath:indexPath];
    [self.delegate configureCell:cell withObject:object];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.delegate deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.allowReorderingCells) {
        case SMLTableViewAllowReorderingAll:
            return YES;
        case SMLTableViewAllowReorderingAllButFirst:
            return indexPath.row != 0;
        case SMLTableViewAllowReorderingAllButFirstAndLast:
            return (indexPath.row != 0 && (indexPath.row != self.fetchedResultsController.fetchedObjects.count - 1));
        case SMLTableViewAllowReorderingNone:
            return NO;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
   
    self.isUserDrivenReorder = YES;
    
    NSMutableArray *objects = [self.fetchedResultsController.fetchedObjects mutableCopy];
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:sourceIndexPath];
    
    [objects removeObject:object];
    [objects insertObject:object atIndex:destinationIndexPath.row];
    
    [self.delegate didReorderObjects:[objects copy]];
    
    self.isUserDrivenReorder = NO;
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {

    if (self.isUserDrivenReorder) return;
    
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (self.isUserDrivenReorder) return;
    
    UITableView *tableView = self.tableView;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.delegate configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    if (self.isUserDrivenReorder) return;
    
    switch(type) {
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {

    if (self.isUserDrivenReorder) return;
    
    [self.tableView endUpdates];
    [self updateInterface];
}

- (void)updateInterface {
    
    if ([self.delegate respondsToSelector:@selector(updateInterfaceForObjectsCount:)]) {
        NSInteger count = self.fetchedResultsController.fetchedObjects.count;
        [self.delegate updateInterfaceForObjectsCount:count];
    }
}

@end
