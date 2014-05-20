//
//  SMLFetchedResultsControllerDataSource.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 19/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol SMLFetchedResultsControllerDataSourceDelegate

- (void)configureCell:(id)cell withObject:(id)object;

@end

@interface SMLFetchedResultsControllerDataSource : NSObject <UITableViewDataSource>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property id<SMLFetchedResultsControllerDataSourceDelegate> delegate;
@property (nonatomic) NSString *reuseIdentifier;

- (id)initWithTableView:(UITableView*)tableView;

@end
