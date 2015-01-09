//
//  UIFont+SML.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "UIFont+SML.h"

@implementation UIFont (SML)

+ (UIFont*)smlFeedFont {
    return [self avenirNextOfSize:11.0];
}

+ (UIFont*)smlTitleFont {
    return [self avenirNextOfSize:17.0];
}

+ (UIFont*)smlCellTitleFont {
    return [self avenirNextOfSize:15.0];
}

+ (UIFont*)smlMyFeedsCellTitleFont {
    return [self avenirNextDemiBoldOfSize:15.0];
}

+ (UIFont*)smlDescriptionFont {
    return [self avenirNextOfSize:15.0];
}

+ (UIFont*)smlDateFont {
    return [UIFont fontWithName:@"Trebuchet MS" size:11.0];
}

+ (UIFont*)smlBarButtonFont {
    return [self avenirNextOfSize:18.0];
}

+ (UIFont*)smlBarTitleFont {
    return [self avenirNextDemiBoldOfSize:18.0];
}

+ (UIFont*)smlArticleTitleFont {
    return [self avenirNextDemiBoldOfSize:20.0];
}

+ (UIFont*)smlStandardTextFont {
    return [self avenirNextOfSize:17.0];
}

+ (UIFont*)avenirNextOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-Regular" size:size];
}

+ (UIFont*)avenirNextDemiBoldOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-DemiBold" size:size];
}

@end
