//
//  SMLRSSItem.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLRSSItem.h"

@implementation SMLRSSItem

+ (id)itemWithXMLElement:(ONOXMLElement*)element {
    
    SMLRSSItem *item = [[SMLRSSItem alloc] init];
    item.title = [[element firstChildWithTag:@"title"] stringValue];
    item.link = [[element firstChildWithTag:@"link"] stringValue];
    item.description = [[element firstChildWithTag:@"description"] stringValue];
    NSString *dateString = [[element firstChildWithTag:@"pubDate"] stringValue];
    item.pubDate = [NSDate dateFromStringWithStandardFormatting:dateString];
    
    return item;
}

@end
