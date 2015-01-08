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
    titleLabel.font = [UIFont feedFont];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 0.5;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.numberOfLines = 1;
    titleLabel.text = text;
    
    return titleLabel;
}

+ (UILabel*)cellTitleLabelWithFrame:(CGRect)frame andText:(NSString*)text {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.font = [UIFont titleFont];
    titleLabel.textColor = [UIColor smlTintColor];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.text = text;
    
    return titleLabel;
}

+ (UILabel*)cellDescriptionLabelWithFrame:(CGRect)frame andText:(NSString*)text {
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:frame];
    descriptionLabel.font = [UIFont descriptionFont];
    descriptionLabel.textColor = [UIColor darkGrayColor];
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.text = text;
    
    return descriptionLabel;
}

+ (UILabel*)cellDateLabelWithFrame:(CGRect)frame andText:(NSString*)text {
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:frame];
    dateLabel.font = [UIFont dateFont];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    dateLabel.numberOfLines = 0;
    dateLabel.text = text;
    
    return dateLabel;
}

+ (CGFloat)heightForTitleLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize {
    
    return [text boundingRectWithSize:maximumSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : [UIFont titleFont]}
                              context:nil].size.height;
}

+ (CGFloat)heightForDescriptionLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize {
    
    return [text boundingRectWithSize:maximumSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : [UIFont descriptionFont]}
                              context:nil].size.height;
}

+ (CGFloat)heightForDateLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize {
    
    return [text boundingRectWithSize:maximumSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : [UIFont dateFont]}
                              context:nil].size.height;
}

+ (CGFloat)heightForArticleTitleLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize {
    
    return [text boundingRectWithSize:maximumSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : [UIFont articleTitleFont]}
                              context:nil].size.height;
}

+ (CGFloat)heightForArticleTextLabelWithText:(NSString*)text andMaximumSize:(CGSize)maximumSize {
    
    return [text boundingRectWithSize:maximumSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : [UIFont standardTextFont]}
                              context:nil].size.height;
}

@end
