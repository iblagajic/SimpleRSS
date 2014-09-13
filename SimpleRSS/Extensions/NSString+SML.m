//
//  NSString+SML.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 13/09/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "NSString+SML.h"

@implementation NSString (SML)

- (NSString*)stringWithASCIIStringEncoding {
    
    NSData *data = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end
