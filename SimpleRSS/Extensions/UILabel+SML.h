//
//  UILabel+SML.h
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SML)

+ (UILabel*)cellFeedLabelWithFrame:(CGRect)frame andText:(NSString*)text;
+ (UILabel*)cellTitleLabelWithFrame:(CGRect)frame andText:(NSString*)text;
+ (UILabel*)cellDescriptionLabelWithFrame:(CGRect)frame andText:(NSString*)text;
+ (UILabel*)cellDateLabelWithFrame:(CGRect)frame andText:(NSString*)text;

+ (CGFloat)heightForLabelWithText:(NSString*)text font:(UIFont*)font andMaximumSize:(CGSize)maximumSize;
+ (CGFloat)heightForTitleLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize;
+ (CGFloat)heightForDescriptionLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize;
+ (CGFloat)heightForDateLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize;
+ (CGFloat)heightForArticleTitleLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize;
+ (CGFloat)heightForArticleTextLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize;

@end
