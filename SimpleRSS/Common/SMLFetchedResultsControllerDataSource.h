//
//  SMLFetchedResultsControllerDataSource.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 19/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol SMLFetchedResultsControllerDataSourceDelegate <NSObject>

- (void)configureCell:(id)cell withObject:(id)object;

@optional
- (void)deleteObject:(id)object;
- (void)updateInterfaceForObjectsCount:(NSInteger)count;
- (void)objectMovedFrom:(NSIndexPath*)fromIndexPath to:(NSIndexPath*)toIndexPath;

@end

@interface SMLFetchedResultsControllerDataSource : NSObject <UITableViewDataSource>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property id<SMLFetchedResultsControllerDataSourceDelegate> delegate;
@property (nonatomic) NSString *reuseIdentifier;
@property (nonatomic) BOOL allowReorderingCells;

- (id)initWithTableView:(UITableView*)tableView;

@end
