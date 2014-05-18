//
//  SMLNavigationItem.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 18/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLNavigationItem.h"

@implementation SMLNavigationItem

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
    
    self.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

@end
