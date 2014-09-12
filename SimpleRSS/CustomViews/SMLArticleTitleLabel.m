//
//  SMLArticleTitleLabel.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 12/09/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLArticleTitleLabel.h"

@implementation SMLArticleTitleLabel

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
    
    self.font = [UIFont articleTitleFont];
    self.textColor = [UIColor smlTintColor];
    self.textAlignment = NSTextAlignmentCenter;
}

@end
