//
//  SMLWebViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 11/09/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLWebViewController.h"

@interface SMLWebViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation SMLWebViewController

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    NSURL *url = [NSURL URLWithString:self.item.link];
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
