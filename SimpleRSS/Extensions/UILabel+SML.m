//
//  UILabel+SML.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 17/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "UILabel+SML.h"

@implementation UILabel (SML)

+ (UILabel*)cellFeedLabelWithFrame:(CGRect)frame andText:(NSString*)text {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.font = [UIFont sml_micro];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 0.5;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.numberOfLines = 1;
    titleLabel.text = text;
    
    return titleLabel;
}

+ (UILabel*)cellTitleLabelWithFrame:(CGRect)frame andText:(NSString*)text {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.font = [UIFont sml_h1];
    titleLabel.textColor = [UIColor smlTintColor];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.text = text;
    
    return titleLabel;
}

+ (UILabel*)cellDescriptionLabelWithFrame:(CGRect)frame andText:(NSString*)text {
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:frame];
    descriptionLabel.font = [UIFont sml_body];
    descriptionLabel.textColor = [UIColor darkGrayColor];
    descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.text = text;
    
    return descriptionLabel;
}

+ (UILabel*)cellDateLabelWithFrame:(CGRect)frame andText:(NSString*)text {
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
    dateLabel.font = [UIFont sml_dateFont];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    dateLabel.numberOfLines = 0;
    dateLabel.text = text;
    
    return dateLabel;
}

+ (CGFloat)heightForLabelWithText:(NSString*)text font:(UIFont*)font andMaximumSize:(CGSize)maximumSize {
    
    return [text boundingRectWithSize:maximumSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : font}
                              context:nil].size.height;
}

+ (CGFloat)heightForTitleLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize {
    
    return [self heightForLabelWithText:text font:[UIFont sml_h1] andMaximumSize:maximumSize];
}

+ (CGFloat)heightForDescriptionLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize {
    
    return [self heightForLabelWithText:text font:[UIFont sml_body] andMaximumSize:maximumSize];
}

+ (CGFloat)heightForDateLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize {
    
    return [self heightForLabelWithText:text font:[UIFont sml_dateFont] andMaximumSize:maximumSize];
}

+ (CGFloat)heightForArticleTitleLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize {
    
    return [self heightForLabelWithText:text font:[UIFont sml_h1] andMaximumSize:maximumSize];
}

+ (CGFloat)heightForArticleTextLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize {
    
    return [self heightForLabelWithText:text font:[UIFont sml_body] andMaximumSize:maximumSize];
}

@end
