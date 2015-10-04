//
//  SMLSearchTableViewController.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMLTableViewController.h"

@class SMLDataController;
@class SMLChannel;

@interface SMLSearchTableViewController : SMLTableViewController

@property (nonatomic) SMLDataController *dataController;

- (void)setupWithChannel:(SMLChannel*)channel;

@end
