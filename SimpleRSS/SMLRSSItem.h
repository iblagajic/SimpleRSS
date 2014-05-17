//
//  SMLRSSItem.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ono.h"

@interface SMLRSSItem : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *link;
@property (nonatomic) NSString *description;
@property (nonatomic) NSDate *pubDate;

+ (id)itemWithXMLElement:(ONOXMLElement*)element;

@end
