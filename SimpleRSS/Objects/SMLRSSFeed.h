//
//  SMLRSSFeed.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMLRSSFeed : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSURL *url;

+ (id)itemWithDictionary:(NSDictionary*)dictionary;

@end
