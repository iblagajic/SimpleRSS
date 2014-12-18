//
//  SMLFetchedResultsControllerDataSource.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 19/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSUInteger, SMLTableViewAllowReordering) {
    SMLTableViewAllowReorderingAll,
    SMLTableViewAllowReorderingAllButFirst,
    SMLTableViewAllowReorderingAllButFirstAndLast,
    SMLTableViewAllowReorderingNone
};

@protocol SMLFetchedResultsControllerDataSourceDelegate <NSObject>

- (void)configureCell:(id)cell withObject:(id)object;
- (NSString*)identifierForCellAtIndexPath:(NSIndexPath*)indexPath;

@optional
- (void)deleteObject:(id)object;
- (void)updateInterfaceForObjectsCount:(NSInteger)count;
- (void)didReorderObjects:(NSArray*)array;

@end

@interface SMLFetchedResultsControllerDataSource : NSObject <UITableViewDataSource>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property id<SMLFetchedResultsControllerDataSourceDelegate> delegate;
@property (nonatomic) SMLTableViewAllowReordering allowReorderingCells;

- (id)initWithTableView:(UITableView*)tableView;

@end
