//
//  UIFont+SML.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "UIFont+SML.h"

@implementation UIFont (SML)

+ (UIFont*)titleFont {
    return [self timesNewRomanWithSize:15.0];
}

+ (UIFont*)descriptionFont {
    return [self timesNewRomanWithSize:13.0];
}

+ (UIFont*)dateFont {
    return [UIFont fontWithName:@"Trebuchet MS" size:11.0];
}

+ (UIFont*)barButtonFont {
    return [self timesNewRomanWithSize:20.0];
}

+ (UIFont*)barTitleFont {
    return [self timesNewRomanWithSize:20.0];
}

+ (UIFont*)timesNewRomanWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Times New Roman" size:size];
}

@end
