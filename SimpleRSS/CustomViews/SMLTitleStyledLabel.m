//
//  SMLTitleStyledLabel.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 12/09/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLTitleStyledLabel.h"

@implementation SMLTitleStyledLabel

- (void)applyStyle {
    
    [super applyStyle];
    
    self.font = [UIFont articleTitleFont];
    self.textColor = [UIColor smlTintColor];
    self.textAlignment = NSTextAlignmentCenter;
}

@end
