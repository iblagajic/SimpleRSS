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
    return [UIFont fontWithName:@"Times New Roman" size:14.0];
}

+ (UIFont*)descriptionFont {
    return [UIFont fontWithName:@"Times New Roman" size:12.0];
}

+ (UIFont*)dateFont {
    return [UIFont fontWithName:@"Trebuchet MS" size:11.0];
}

@end
