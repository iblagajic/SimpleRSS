//
//  SMLErrorStyledLabel.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 13/09/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLErrorStyledLabel.h"

@implementation SMLErrorStyledLabel

- (void)applyStyle {
    
    [super applyStyle];
    
    self.font = [UIFont smlStandardTextFont];
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = [UIColor darkGrayColor];
}

@end
