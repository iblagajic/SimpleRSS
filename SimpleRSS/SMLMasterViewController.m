//
//  SMLMasterViewController.m
//  SimpleRSS
//
//  Created by Ivan Blagajić on 16/05/14.
//  Copyright (c) 2014 Simple. All rights reserved.
//

#import "SMLMasterViewController.h"
#import "Ono.h"
#import "SMLRSSItem.h"
#import "UIViewController+ScrollingNavbar.h"

#define kCellPadding 10.0

@interface SMLMasterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) ONOXMLDocument *parser;
@property (nonatomic) NSMutableArray *items;
@property (nonatomic) NSMutableString *title;
@property (nonatomic) NSMutableString *link;
@property (nonatomic) NSString *element;

@end

@implementation SMLMasterViewController


#pragma mark - UIVIewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self followScrollView:self.tableView];
	
    self.items = [[NSMutableArray alloc] init];
    [self parse];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self showNavBarAnimated:NO];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    SMLRSSItem *item = [self.items objectAtIndex:indexPath.row];
    return [self heightForCellWithRSSItem:item];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SMLRSSItem *item = [self.items objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:item.link];
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark - parser

- (void)parse {
    
    NSURL *url = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *err;
    self.parser = [ONOXMLDocument XMLDocumentWithData:data
                                                error:&err];
    ONOXMLElement *channel = [self.parser.rootElement firstChildWithTag:@"channel"];
    self.title = [[[channel firstChildWithTag:@"title"] stringValue] mutableCopy];
    
    NSArray *items = [channel childrenWithTag:@"item"];
    for (ONOXMLElement *element in items) {
        SMLRSSItem *item = [SMLRSSItem itemWithXMLElement:element];
        [self.items addObject:item];
        NSLog(@"%@ - %@", item.title, item.pubDate);
    }
    
    [self.tableView reloadData];
}


#pragma mark - SMLMasterViewController

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    
    for (UIView *subview in cell.contentView.subviews)
         [subview removeFromSuperview];
    
    SMLRSSItem *item = [self.items objectAtIndex:indexPath.row];
    
    CGFloat height = kCellPadding;

    CGRect titleFrame = CGRectMake(kCellPadding,
                                   height,
                                   CGRectGetWidth(self.tableView.frame) - 2*kCellPadding,
                                   [UILabel heightForTitleLabelWithText:item.title andMaximumSize:self.maximumLabelSize]);
    UILabel *titleLabel = [UILabel cellTitleLabelWithFrame:titleFrame andText:item.title];
    height += CGRectGetHeight(titleFrame) + kCellPadding;
    [cell.contentView addSubview:titleLabel];
    
    CGRect descriptionFrame = CGRectMake(kCellPadding,
                                         height,
                                         CGRectGetWidth(self.tableView.frame) - 2*kCellPadding,
                                         [UILabel heightForDescriptionLabelWithText:item.description andMaximumSize:self.maximumLabelSize]);
    UILabel *descriptionLabel = [UILabel cellDescriptionLabelWithFrame:descriptionFrame andText:item.description];
    height += CGRectGetHeight(descriptionFrame) + kCellPadding;
    [cell.contentView addSubview:descriptionLabel];
    
    NSString *dateString = [item.pubDate mediumStyleDateString];
    CGRect dateFrame = CGRectMake(kCellPadding,
                                  height,
                                  CGRectGetWidth(self.tableView.frame) - 2*kCellPadding,
                                  [UILabel heightForDateLabelWithText:dateString andMaximumSize:self.maximumLabelSize]);
    UILabel *dateLabel = [UILabel cellDateLabelWithFrame:dateFrame andText:dateString];
    [cell.contentView addSubview:dateLabel];
    
    height += CGRectGetHeight(dateFrame) + kCellPadding;
//    NSLog(@"Cell height: %f", height);
}


#pragma mark - helpers

- (CGFloat)heightForCellWithRSSItem:(SMLRSSItem*)item {
    
    CGFloat height = 2*kCellPadding;

    height += [UILabel heightForTitleLabelWithText:item.title andMaximumSize:self.maximumLabelSize];
    height += kCellPadding;
    
    height += [UILabel heightForDescriptionLabelWithText:item.description andMaximumSize:self.maximumLabelSize];
    height += kCellPadding;
    
    height += [UILabel heightForDateLabelWithText:[item.pubDate mediumStyleDateString] andMaximumSize:self.maximumLabelSize];
    
//    NSLog(@"Predicted height: %f", height);

    return height;
}

- (CGSize)maximumLabelSize {
    
    CGSize size = self.tableView.frame.size;
    size.width -= 2*kCellPadding;
    size.height = MAXFLOAT;
    
    return size;
}

@end
