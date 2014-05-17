//
//  NSDate+SML.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "NSDate+SML.h"

@implementation NSDate (SML)

+ (NSDate*)dateFromStringWithStandardFormatting:(NSString*)dateString {

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, d LLL yyyy HH:mm:ss zzz"];
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
}

- (NSString*)mediumStyleDateString {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    return [formatter stringFromDate:self];
}

@end
