//
//  UIFont+SML.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "UIFont+SML.h"

@implementation UIFont (SML)

+ (UIFont*)feedFont {
    return [self avenirNextOfSize:11.0];
}

+ (UIFont*)titleFont {
    return [self avenirNextOfSize:17.0];
}

+ (UIFont*)cellTitleFont {
    return [self avenirNextOfSize:15.0];
}

+ (UIFont*)myFeedsCellTitleFont {
    return [self avenirNextDemiBoldOfSize:15.0];
}

+ (UIFont*)descriptionFont {
    return [self avenirNextOfSize:15.0];
}

+ (UIFont*)dateFont {
    return [UIFont fontWithName:@"Trebuchet MS" size:11.0];
}

+ (UIFont*)barButtonFont {
    return [self avenirNextOfSize:18.0];
}

+ (UIFont*)barTitleFont {
    return [self avenirNextDemiBoldOfSize:18.0];
}

+ (UIFont*)articleTitleFont {
    return [self avenirNextDemiBoldOfSize:20.0];
}

+ (UIFont*)standardTextFont {
    return [self avenirNextOfSize:17.0];
}

+ (UIFont*)avenirNextOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-Regular" size:size];
}

+ (UIFont*)avenirNextDemiBoldOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-DemiBold" size:size];
}

@end
