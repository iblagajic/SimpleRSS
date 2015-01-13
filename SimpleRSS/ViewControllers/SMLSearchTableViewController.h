//
//  SMLSearchTableViewController.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMLTableViewController.h"
#import "SMLChannel.h"

@interface SMLSearchTableViewController : SMLTableViewController

- (void)setupWithChannel:(SMLChannel*)channel;

@end
