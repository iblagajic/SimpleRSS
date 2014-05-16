//
//  SMLDetailViewController.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 16/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMLDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
