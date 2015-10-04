//
//  SMLAppDelegate.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 16/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMLDataController;

@interface SMLAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, readonly) SMLDataController *dataController;

@property (strong, nonatomic) UIWindow *window;

@end
