//
//  UIColor+SML.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 04/07/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "UIColor+SML.h"

@implementation UIColor (SML)

+ (UIColor*)smlTintColor {
    return [UIColor smlTintColorWithAlpha:1.0];
}

+ (UIColor*)smlTintColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:47.0/255.0 green:98.0/255.0 blue:217.0/255.0 alpha:alpha];
}

@end
