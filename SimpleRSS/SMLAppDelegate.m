//
//  SMLAppDelegate.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 16/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLAppDelegate.h"
#import "SMLDataController.h"

@interface SMLAppDelegate ()

@property (nonatomic) SMLDataController *dataController;

@end

@implementation SMLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationController class], nil] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont sml_h1] } forState:UIControlStateNormal];
    [UITextField appearanceWhenContainedIn:[UINavigationController class], nil].tintColor = [UIColor smlTintColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.dataController = [[SMLDataController alloc] init];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.dataController saveContext];
}

@end
