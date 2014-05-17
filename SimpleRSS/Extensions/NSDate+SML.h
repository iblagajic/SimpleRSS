//
//  NSDate+SML.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SML)

+ (NSDate*)dateFromStringWithStandardFormatting:(NSString*)dateString;
- (NSString*)mediumStyleDateString;

@end
