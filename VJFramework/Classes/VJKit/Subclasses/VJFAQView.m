//
//  VJFAQView.m
//  VJFramework
//
//  Created by Vikas Jalan on 4/09/16.
//  Copyright 2016 http://www.vikasjalan.com All rights reserved.
//  Contact on jalanvikas@gmail.com or contact@vikasjalan.com
//
//  Get the latest version from here:
//  https://github.com/jalanvikas/VJFramework
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are
//  met:
//
//  * Redistributions of source code must retain the above copyright notice,
//  this list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
//  * The name of Vikas Jalan may not be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY VIKAS JALAN "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
//  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
//  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
//  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import "VJFAQView.h"
#import "UIColor+VJKitExtension.h"
#import "NSString+VJFoundationExtension.h"


#define FAQ_ITEM_HEADING_KEY        @"heading"
#define FAQ_ITEM_VALUE_KEY          @"value"
#define FAQ_ITEM_TITLE_KEY          @"title"
#define FAQ_ITEM_IMAGE_KEY          @"image"

#define OFFSET                                          15.0
#define OFFSET_BETWEEN_ITEMS                            5.0
#define LIST_TABLE_VIEW_CELL_IDENTIFIER                 @"listTableViewCellIdentifier"

#define LIST_TABLE_VIEW_CELL_HEIGHT                     35.0f
#define LIST_TABLE_VIEW_CELL_SEPARATOR_HEIGHT           0.5f


@class VJFAQListView;

@protocol VJFAQListViewDelegate

- (void)selectedItemAtIndex:(NSUInteger)index ofView:(VJFAQListView *)view;

@end


@interface VJFAQListView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *headingLabel;
@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) NSDictionary *faqInfo;
@property (nonatomic, assign) id<VJFAQListViewDelegate> faqTableViewDelegate;

#pragma mark - Private Methods

- (void)initialize;

- (id)initWithFaqInfo:(NSDictionary *)faqInfo;

@end


@implementation VJFAQListView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect headingLabelFrame = CGRectMake(OFFSET, OFFSET_BETWEEN_ITEMS, (self.frame.size.width - (OFFSET * 2)), 20.0);
    [self.headingLabel setFrame:headingLabelFrame];
    
    CGRect listTableViewFrame = CGRectMake(0.0, (self.headingLabel.frame.origin.y + self.headingLabel.frame.size.height + OFFSET_BETWEEN_ITEMS), self.frame.size.width, (self.frame.size.height - (self.headingLabel.frame.origin.y + self.headingLabel.frame.size.height + (OFFSET + OFFSET_BETWEEN_ITEMS))));
    [self.listTableView setFrame:listTableViewFrame];
}

#pragma mark - Private Methods

- (void)initialize
{
    self.headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(OFFSET, OFFSET_BETWEEN_ITEMS, (self.frame.size.width - (OFFSET * 2)), 20.0)];
    self.headingLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.headingLabel];
    
    CGRect listTableViewFrame = CGRectMake(0.0, (self.headingLabel.frame.origin.y + self.headingLabel.frame.size.height + OFFSET_BETWEEN_ITEMS), self.frame.size.width, (self.frame.size.height - (self.headingLabel.frame.origin.y + self.headingLabel.frame.size.height + (OFFSET + OFFSET_BETWEEN_ITEMS))));
    self.listTableView = [[UITableView alloc] initWithFrame:listTableViewFrame];
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:self.listTableView];
}

- (id)initWithFaqInfo:(NSDictionary *)faqInfo
{
    self = [super init];
    if (self)
    {
        [self initialize];
        self.faqInfo = faqInfo;
        
        self.headingLabel.attributedText = [[self.faqInfo objectForKey:FAQ_ITEM_HEADING_KEY] attributedString];
        
        self.listTableView.delegate = self;
        self.listTableView.dataSource = self;
        [self.listTableView reloadData];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (([[self.faqInfo objectForKey:FAQ_ITEM_VALUE_KEY] isKindOfClass:[NSArray class]])?[[self.faqInfo objectForKey:FAQ_ITEM_VALUE_KEY] count]:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LIST_TABLE_VIEW_CELL_IDENTIFIER];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LIST_TABLE_VIEW_CELL_IDENTIFIER];
        cell.backgroundColor = [UIColor clearColor];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, (LIST_TABLE_VIEW_CELL_HEIGHT - 1), self.listTableView.bounds.size.width, LIST_TABLE_VIEW_CELL_SEPARATOR_HEIGHT)];
        [separatorView setBackgroundColor:[UIColor lightGrayColor]];
        [cell addSubview:separatorView];
    }
    
    NSDictionary *cellInfo = [[self.faqInfo objectForKey:FAQ_ITEM_VALUE_KEY] objectAtIndex:indexPath.row];
    if ([[cellInfo objectForKey:FAQ_ITEM_TITLE_KEY] isKindOfClass:[NSString class]])
    {
        cell.textLabel.attributedText = [[cellInfo objectForKey:FAQ_ITEM_TITLE_KEY] attributedString];
    }
    if ([[cellInfo objectForKey:FAQ_ITEM_IMAGE_KEY] isKindOfClass:[NSString class]])
    {
        cell.imageView.image = [UIImage imageNamed:[cellInfo objectForKey:FAQ_ITEM_IMAGE_KEY]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LIST_TABLE_VIEW_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.faqTableViewDelegate)
    {
        [self.faqTableViewDelegate selectedItemAtIndex:indexPath.row ofView:self];
    }
}

@end



@interface VJFAQDetailView : UIView

@property (nonatomic, strong) UILabel *headingLabel;
@property (nonatomic, strong) UITextView *descriptionTextView;

@property (nonatomic, strong) NSDictionary *faqInfo;

#pragma mark - Private Methods

- (void)initialize;

- (id)initWithFaqInfo:(NSDictionary *)faqInfo;

@end


@implementation VJFAQDetailView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect headingLabelFrame = CGRectMake(OFFSET, OFFSET_BETWEEN_ITEMS, (self.frame.size.width - (OFFSET * 2)), 20.0);
    [self.headingLabel setFrame:headingLabelFrame];
    
    CGRect descriptionTextViewFrame = CGRectMake((OFFSET - 5.0), (self.headingLabel.frame.origin.y + self.headingLabel.frame.size.height + OFFSET_BETWEEN_ITEMS), (self.frame.size.width - (OFFSET * 2)), (self.frame.size.height - (self.headingLabel.frame.origin.y + self.headingLabel.frame.size.height + (OFFSET + OFFSET_BETWEEN_ITEMS))));
    [self.descriptionTextView setFrame:descriptionTextViewFrame];
}

#pragma mark - Private Methods

- (void)initialize
{
    CGRect headingLabelFrame = CGRectMake(OFFSET, OFFSET_BETWEEN_ITEMS, (self.frame.size.width - (OFFSET * 2)), 20.0);
    self.headingLabel = [[UILabel alloc] initWithFrame:headingLabelFrame];
    self.headingLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.headingLabel];
    
    CGRect descriptionTextViewFrame = CGRectMake((OFFSET - 5.0), (self.headingLabel.frame.origin.y + self.headingLabel.frame.size.height + OFFSET_BETWEEN_ITEMS), (self.frame.size.width - (OFFSET * 2)), (self.frame.size.height - (self.headingLabel.frame.origin.y + self.headingLabel.frame.size.height + (OFFSET + OFFSET_BETWEEN_ITEMS))));
    self.descriptionTextView = [[UITextView alloc] initWithFrame:descriptionTextViewFrame];
    self.descriptionTextView.backgroundColor = [UIColor clearColor];
    self.descriptionTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.descriptionTextView];
}

- (id)initWithFaqInfo:(NSDictionary *)faqInfo
{
    self = [super init];
    if (self)
    {
        [self initialize];
        self.faqInfo = faqInfo;
        if ([self.faqInfo objectForKey:FAQ_ITEM_HEADING_KEY])
        {
            [self.headingLabel setAttributedText:[[self.faqInfo objectForKey:FAQ_ITEM_HEADING_KEY] attributedString]];
        }
        if ([self.faqInfo objectForKey:FAQ_ITEM_VALUE_KEY])
        {
            [self.descriptionTextView setAttributedText:[[self.faqInfo objectForKey:FAQ_ITEM_VALUE_KEY] attributedString]];
        }
    }
    
    return self;
}

@end



@interface VJFAQView () <VJFAQListViewDelegate>

@property (nonatomic, strong) id faqInfo;
@property (nonatomic, strong) NSMutableArray *faqViews;

@property (nonatomic, assign) id displayedView;

#pragma mark - Private Methods

- (void)initialize;

@end

@implementation VJFAQView

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initialize];
}

#pragma mark - Private Methods

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.faqViews = [NSMutableArray array];
}

#pragma mark - Custom Methods

- (BOOL)canGoBack
{
    return (([self.faqViews count] > 1)?YES:NO);
}

- (void)goBack
{
    if ([self canGoBack])
    {
        CGRect displayedViewFrame = [(UIView *)self.displayedView frame];
        
        CGRect displayingViewFrame = [(UIView *)self.displayedView frame];
        displayingViewFrame.origin.x = -displayedViewFrame.size.width;
        
        UIView *displayingView = [self.faqViews objectAtIndex:([self.faqViews count] - 2)];
        displayingView.frame = displayingViewFrame;
        
        [self addSubview:displayingView];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect displayingViewFrame = [(UIView *)self.displayedView frame];
            displayingViewFrame.origin.x = 0.0;
            displayingView.frame = displayingViewFrame;
            
            CGRect displayedViewFrame = [(UIView *)self.displayedView frame];
            displayedViewFrame.origin.x = displayedViewFrame.size.width;
            [(UIView *)self.displayedView setFrame:displayedViewFrame];
        }completion:^(BOOL finished){
            [self.displayedView removeFromSuperview];
            self.displayedView = displayingView;
            [self.faqViews removeLastObject];
        }];
    }
}

- (void)initializeWithFAQInfo:(id)faqInfo
{
    self.faqInfo = faqInfo;
    
    if ([[self.faqInfo objectForKey:FAQ_ITEM_VALUE_KEY] isKindOfClass:[NSArray class]])
    {
        VJFAQListView *faqListView = [[VJFAQListView alloc] initWithFaqInfo:self.faqInfo];
        [faqListView setBackgroundColor:self.backgroundColor];
        faqListView.faqTableViewDelegate = self;
        [faqListView setFrame:self.bounds];
        [self.faqViews addObject:faqListView];
        
        [self addSubview:faqListView];
        self.displayedView = faqListView;
    }
    else if ([[self.faqInfo objectForKey:FAQ_ITEM_VALUE_KEY] isKindOfClass:[NSDictionary class]])
    {
        VJFAQDetailView *faqDetailView = [[VJFAQDetailView alloc] initWithFaqInfo:[(NSDictionary *)self.faqInfo objectForKey:FAQ_ITEM_VALUE_KEY]];
        [faqDetailView setBackgroundColor:self.backgroundColor];
        [faqDetailView setFrame:self.bounds];
        [self.faqViews addObject:faqDetailView];
        
        [self addSubview:faqDetailView];
        self.displayedView = faqDetailView;
    }
}

#pragma mark - VJFAQListViewDelegate Methods

- (void)selectedItemAtIndex:(NSUInteger)index ofView:(VJFAQListView *)view
{
    NSDictionary *itemInfo = [[view.faqInfo objectForKey:FAQ_ITEM_VALUE_KEY] objectAtIndex:index];
    if ([itemInfo objectForKey:FAQ_ITEM_VALUE_KEY])
    {
        if ([[itemInfo objectForKey:FAQ_ITEM_VALUE_KEY] isKindOfClass:[NSArray class]])
        {
            VJFAQListView *faqListView = [[VJFAQListView alloc] initWithFaqInfo:itemInfo];
            [faqListView setBackgroundColor:self.backgroundColor];
            faqListView.faqTableViewDelegate = self;
            [self.faqViews addObject:faqListView];
            
            CGRect faqListViewFrame = self.bounds;
            faqListViewFrame.origin.x = faqListViewFrame.size.width;
            [faqListView setFrame:faqListViewFrame];
            
            [self addSubview:faqListView];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect displayingViewFrame = [(UIView *)self.displayedView frame];
                faqListView.frame = displayingViewFrame;
                
                CGRect displayedViewFrame = [(UIView *)self.displayedView frame];
                displayedViewFrame.origin.x = -displayedViewFrame.size.width;
                [(UIView *)self.displayedView setFrame:displayedViewFrame];
            }completion:^(BOOL finished){
                [self.displayedView removeFromSuperview];
                self.displayedView = faqListView;
            }];
        }
        else if ([[itemInfo objectForKey:FAQ_ITEM_VALUE_KEY] isKindOfClass:[NSDictionary class]])
        {
            VJFAQDetailView *faqDetailView = [[VJFAQDetailView alloc] initWithFaqInfo:[itemInfo objectForKey:FAQ_ITEM_VALUE_KEY]];
            [faqDetailView setBackgroundColor:self.backgroundColor];
            [self.faqViews addObject:faqDetailView];
            
            CGRect faqDetailViewFrame = self.bounds;
            faqDetailViewFrame.origin.x = faqDetailViewFrame.size.width;
            [faqDetailView setFrame:faqDetailViewFrame];
            
            [self addSubview:faqDetailView];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect displayingViewFrame = [(UIView *)self.displayedView frame];
                faqDetailView.frame = displayingViewFrame;
                
                CGRect displayedViewFrame = [(UIView *)self.displayedView frame];
                displayedViewFrame.origin.x = -displayedViewFrame.size.width;
                [(UIView *)self.displayedView setFrame:displayedViewFrame];
            }completion:^(BOOL finished){
                [self.displayedView removeFromSuperview];
                self.displayedView = faqDetailView;
            }];
        }
    }
}

@end
