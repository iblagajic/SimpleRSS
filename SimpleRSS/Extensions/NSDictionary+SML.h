//
//  NSDictionary+SML.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 28/06/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ono.h"

@interface NSDictionary (SML)

+ (NSDictionary*)dictionaryFromXML:(ONOXMLElement*)xml;

@end
