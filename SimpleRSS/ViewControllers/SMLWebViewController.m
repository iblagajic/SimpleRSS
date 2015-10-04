//
//  SMLWebViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 11/09/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLWebViewController.h"
#import "SMLItem.h"
#import <PromiseKit.h>

#define kReadabilityParserURL @"https://readability.com/api/content/v1/parser?url=%@&token=%@"

@interface SMLWebViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation SMLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadArticleJSON];
}

- (void)loadArticleJSON {
    
    self.title = self.item.title;
    NSString *readabilityPath = [NSString stringWithFormat:kReadabilityParserURL, self.item.link, kReadabilityParserAPIKey];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *encodedPath = [readabilityPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    PMKPromise *feedsPromise = [NSURLConnection GET:encodedPath];
    feedsPromise.then(^(NSDictionary *resultsDictionary) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSString *htmlString = [self articleContentFromDictionary:resultsDictionary];
        [self.webView loadHTMLString:htmlString baseURL:nil];
    }).catch(^(NSError *err) {
        NSLog(@"%@", err.description);
    });
}

- (NSString*)articleContentFromDictionary:(NSDictionary *)dict {
    if (![[dict objectForKey:@"content"] isKindOfClass:NSString.class]) {
        return nil;
    }
    return [dict objectForKey:@"content"];
}

@end
