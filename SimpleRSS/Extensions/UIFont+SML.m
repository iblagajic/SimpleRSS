//
//  UIFont+SML.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "UIFont+SML.h"

@implementation UIFont (SML)

+ (UIFont *)sml_h1 {
    return [self avenirNextOfSize:17.0];
}

+ (UIFont *)sml_h1DemiBold {
    return [self avenirNextDemiBoldOfSize:18.0];
}

+ (UIFont *)sml_h2 {
    return [self avenirNextDemiBoldOfSize:15.0];
}

+ (UIFont *)sml_body {
    return [self avenirNextOfSize:15.0];
}

+ (UIFont *)sml_micro {
    return [self avenirNextOfSize:13.0];
}

+ (UIFont *)sml_dateFont {
    return [UIFont fontWithName:@"Trebuchet MS" size:11.0];
}

+ (UIFont *)avenirNextOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-Regular" size:size];
}

+ (UIFont *)avenirNextDemiBoldOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-DemiBold" size:size];
}

@end
