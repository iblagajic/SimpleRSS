//
//  NSDictionary+SML.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 28/06/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "NSDictionary+SML.h"

@implementation NSDictionary (SML)

+ (NSDictionary*)dictionaryFromXML:(ONOXMLElement*)xml {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    for (ONOXMLElement *element in xml.children) {
        [dictionary setObject:element.stringValue forKey:element.tag];
    }
    return dictionary;
}

@end
