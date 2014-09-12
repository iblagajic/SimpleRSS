//
//  SMLWebViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 11/09/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLWebViewController.h"

#define kReadabilityToken @"ddd2fc89a569f7d858b8bb3163b5c1a260225e73"

@interface SMLWebViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation SMLWebViewController

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    NSString *urlString = [NSString stringWithFormat:@"https://readability.com/m?url=%@", self.item.link];
    NSURL *url = [NSURL URLWithString:urlString];
    [self loadUrl:url];
    self.title = self.item.title;
}

- (void)loadUrl:(NSURL*)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.webView reload];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
