//
//  SMLAddFeedTableViewController.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMLChannel.h"

@interface SMLAddFeedTableViewController : UITableViewController

- (void)setupWithChannel:(SMLChannel*)channel;

@end
