//
//  SMLNoDataView.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 08/01/15.
//  Copyright (c) 2015 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)();

@interface SMLNoDataView : UIView

- (instancetype)initWithFrame:(CGRect)frame message:(NSString*)message;
- (void)addActionButtonWithText:(NSString*)buttonText actionBlock:(ActionBlock)actionBlock;

@end
