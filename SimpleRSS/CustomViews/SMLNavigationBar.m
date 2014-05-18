//
//  SMLNavigationBar.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 18/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLNavigationBar.h"

@implementation SMLNavigationBar

- (id)init {
    self = [super init];
    if (self)
        [self applyStyle];
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self applyStyle];
}

- (void)applyStyle {
    
    self.titleTextAttributes = @{NSFontAttributeName : [UIFont barTitleFont]};
}

@end
