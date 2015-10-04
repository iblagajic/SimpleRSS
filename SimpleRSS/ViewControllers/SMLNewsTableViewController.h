//
//  SMLNewsTableViewController.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 16/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMLTableViewController.h"

@class SMLDataController;
@class SMLChannel;
@class SMLFeed;

@interface SMLNewsTableViewController : SMLTableViewController

@property (nonatomic) SMLDataController *dataController;

- (void)setupWithChannel:(SMLChannel*)channel;
- (void)setupWithFeed:(SMLFeed*)feed;

@end
