//
//  SMLRSSFeed.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLRSSFeed.h"

@implementation SMLRSSFeed

+ (id)itemWithDictionary:(NSDictionary*)dictionary {
    
    SMLRSSFeed *item = [[SMLRSSFeed alloc] init];
    item.title = [[dictionary objectForKey:@"title"] stringByConvertingHTMLToPlainText];
    NSString *urlString = [dictionary objectForKey:@"url"];
    item.url = [NSURL URLWithString:urlString];
    return item;
}

@end
