//
//  SMLArticleViewController.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 12/09/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMLArticleViewController : UIViewController

- (void)generateArticleJSONForURLString:(NSString*)urlString andFeedName:(NSString*)name;

@end
