//
//  SMLArticleViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 12/09/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLArticleViewController.h"
#import <PromiseKit.h>

#define kScrollViewPaddingTop 20.0
#define kLabelPadding 20.0
#define kSidePadding 10.0
#define kReadabilityParserAPIKey @"ddd2fc89a569f7d858b8bb3163b5c1a260225e73"

@interface SMLArticleViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong) NSDictionary *articleJSON;
@property (nonatomic, weak) PMKPromise *promise;

@end

@implementation SMLArticleViewController


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, [self heightForContent]);
}


#pragma mark - public

- (void)generateArticleJSONForURLString:(NSString*)urlString andFeedName:(NSString*)name {
    
    self.title = name;
    NSString *readabilityURLString = [NSString stringWithFormat:@"https://readability.com/api/content/v1/parser?url=%@&token=%@", urlString, kReadabilityParserAPIKey];
    self.promise = [self promiseWithJSONResponseForURL:[readabilityURLString stringWithASCIIStringEncoding]];
    self.promise.then(^(NSDictionary *resultsDictionary) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.articleJSON = resultsDictionary;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, [self heightForContent]);
        [self updateLabels];
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.scrollView.alpha = 1.0;
                         }];
    }).catch(^(NSError *err) {
        NSLog(@"%@", err.description);
        self.activityIndicator.hidden = YES;
        self.errorLabel.text = @"No data available";
        self.errorLabel.hidden = NO;
    });
}


#pragma mark - helpers

- (CGFloat)heightForContent {
    
    CGFloat height = 2*kScrollViewPaddingTop;
    
    height += [UILabel heightForArticleTitleLabelWithText:self.articleTitle andMaximumSize:self.maximumLabelSize];
    height += kLabelPadding;
    
    height += [UILabel heightForArticleTextLabelWithText:self.articleText andMaximumSize:self.maximumLabelSize];
    
    return height;
}

- (CGSize)maximumLabelSize {
    
    CGSize size = CGSizeMake(CGRectGetWidth(self.view.frame) - 2*kSidePadding, MAXFLOAT);
    
    return size;
}

- (NSString*)articleTitle {
    return [self.articleJSON objectForKey:@"title"];
}

- (NSString*)articleText {
    return [[self.articleJSON objectForKey:@"content"] stringByConvertingHTMLToPlainText];
}

- (PMKPromise*)promiseWithJSONResponseForURL:(NSString*)urlString {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    PMKPromise *feedsPromise = [NSURLConnection GET:urlString];
    
    return feedsPromise;
}

- (void)updateLabels {
    
    self.titleLabel.text = self.articleTitle;
    self.textLabel.text = self.articleText;
    
    CGRect titleFrame = CGRectMake(kSidePadding,
                                   kScrollViewPaddingTop,
                                   CGRectGetWidth(self.view.frame) - 2*kSidePadding,
                                   [UILabel heightForArticleTitleLabelWithText:self.articleTitle andMaximumSize:self.maximumLabelSize]);
    self.titleLabel.frame = titleFrame;

    CGRect textFrame = CGRectMake(kSidePadding,
                                  kScrollViewPaddingTop + CGRectGetHeight(titleFrame) + kLabelPadding,
                                  CGRectGetWidth(self.view.frame) - 2*kSidePadding,
                                  [UILabel heightForArticleTextLabelWithText:self.articleText andMaximumSize:self.maximumLabelSize]);
    self.textLabel.frame = textFrame;
}

- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
