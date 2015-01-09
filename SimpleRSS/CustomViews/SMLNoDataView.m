//
//  SMLNoDataView.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 08/01/15.
//  Copyright (c) 2015 Simple. All rights reserved.
//

#import "SMLNoDataView.h"

@interface SMLNoDataView ()

@property (nonatomic) UIView *containerView;
@property (nonatomic, copy) ActionBlock actionBlock;

@end

@implementation SMLNoDataView

- (instancetype)initWithFrame:(CGRect)frame message:(NSString*)message {
    
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [self addContainerView];
    [self addNoDataLabelWithText:message];
    [self addIconDivider];
    
    return self;
}


#pragma mark - public 

- (void)addActionButtonWithText:(NSString*)buttonText actionBlock:(ActionBlock)actionBlock {
    
    UIFont *font = [UIFont smlStandardTextFont];
    CGFloat width = CGRectGetWidth(self.containerView.frame);
    CGFloat height = [UILabel heightForLabelWithText:buttonText font:font andMaximumSize:CGSizeMake(width, MAXFLOAT)];
    CGRect frame = CGRectMake(0, 0, width, height);
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.frame = frame;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:buttonText
                                                                           attributes:@{ NSForegroundColorAttributeName : [UIColor smlTintColor],
                                                                                         NSFontAttributeName : font }];
    [actionButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(performActionBlock) forControlEvents:UIControlEventTouchUpInside];
    [self addSubviewToContainerView:actionButton];
    
    self.actionBlock = actionBlock;
}


#pragma mark - helpers

- (void)addContainerView {
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.frame) - 40, 0)];
    self.containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.containerView];
}

- (void)addSubviewToContainerView:(UIView*)subview {
    
    CGRect containerFrame = self.containerView.frame;
    CGRect subviewFrame = subview.frame;
    subviewFrame.origin.y = CGRectGetHeight(containerFrame);
    subview.frame = subviewFrame;
    containerFrame.size.height += CGRectGetHeight(subviewFrame) + 20;
    containerFrame.origin.y = CGRectGetHeight(self.frame)/2 - CGRectGetHeight(self.containerView.frame)/2;
    self.containerView.frame = containerFrame;
    [self.containerView addSubview:subview];
}

- (void)addNoDataLabelWithText:(NSString*)text {
    
    UIFont *font = [UIFont smlStandardTextFont];
    CGFloat width = CGRectGetWidth(self.containerView.frame);
    CGFloat height = [UILabel heightForLabelWithText:text font:font andMaximumSize:CGSizeMake(width, MAXFLOAT)];
    CGRect frame = CGRectMake(0, 0, width, height);
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:frame];
    noDataLabel.text = text;
    noDataLabel.textColor = [UIColor grayColor];
    noDataLabel.font = font;
    noDataLabel.numberOfLines = 0;
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubviewToContainerView:noDataLabel];
}

- (void)addIconDivider {
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IconDivider"]];
    CGFloat width = CGRectGetWidth(iconImageView.frame);
    CGFloat height = CGRectGetHeight(iconImageView.frame);
    iconImageView.frame = CGRectMake(CGRectGetWidth(self.containerView.frame)/2 - CGRectGetWidth(iconImageView.frame)/2, 0, width, height);
    [self addSubviewToContainerView:iconImageView];
}

- (void)performActionBlock {
    
    if (self.actionBlock != nil) {
        self.actionBlock();
    }
}

@end
