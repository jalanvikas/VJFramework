//
//  VJButton.m
//  VJFramework
//
//  Created by Vikas Jalan on 3/24/16.
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
//

#import "VJButton.h"

#define UNDERLINE_HEIGHT                2
#define UNDERLINE_COLOR                 [UIColor whiteColor]
#define SELECTED_UNDERLINE_COLOR        [UIColor blackColor]

#define TEXT_IMAGE_OFFSET               5.0f

@interface VJButton ()

@property (nonatomic, assign) BOOL showUnderline;
@property (nonatomic, strong) UIView *underlineView;
@property (nonatomic, strong) UIColor *underlineColor;
@property (nonatomic, strong) UIColor *selectedUnderlineColor;
@property (nonatomic, assign) CGFloat underlineHeight;

@property (nonatomic, assign) BOOL alignVertically;
@property (nonatomic, assign) BOOL textImageOffset;
@property (nonatomic, assign) BOOL imageOnTop;

#pragma mark - Private Methods

- (void)setupButton;

- (void)prepareUnderlineView;

- (void)alignContentVertically;

@end


@implementation VJButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupButton];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupButton];
    }
    return self;
}

+ (id)buttonWithType:(UIButtonType)buttonType
{
    VJButton *button = [super buttonWithType:buttonType];
    if (button)
    {
        [button setupButton];
    }
    return button;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (self.showUnderline)
    {
        [self.underlineView setBackgroundColor:(([self isSelected])?self.selectedUnderlineColor:self.underlineColor)];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.alignVertically)
    {
        [self alignContentVertically];
    }
}

#pragma mark - Private Methods

- (void)setupButton
{
    self.showUnderline = NO;
    self.underlineHeight = UNDERLINE_HEIGHT;
    self.underlineColor = UNDERLINE_COLOR;
    self.selectedUnderlineColor = SELECTED_UNDERLINE_COLOR;
    
    self.alignVertically = NO;
    self.textImageOffset = TEXT_IMAGE_OFFSET;
    self.imageOnTop = YES;
}

- (void)prepareUnderlineView
{
    if (nil == self.underlineView)
    {
        CGRect underlineViewFrame = CGRectMake(0.0, self.bounds.size.height - self.underlineHeight, self.bounds.size.width, self.underlineHeight);
        
        self.underlineView = [[UIView alloc] initWithFrame:underlineViewFrame];
        [self.underlineView setBackgroundColor:(([self isSelected])?self.selectedUnderlineColor:self.underlineColor)];
        self.underlineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        
        [self addSubview:self.underlineView];
    }
}

- (void)alignContentVertically
{
    CGRect buttonFrame = self.frame;
    CGRect imageFrame = self.imageView.frame;
    CGRect titleFrame = self.titleLabel.frame;
    
    CGFloat offsetBetweenTextAndImage = MIN(self.textImageOffset, (buttonFrame.size.height * 0.1));
    CGFloat contentHeight = (buttonFrame.size.height * 0.8) + offsetBetweenTextAndImage;
    CGFloat contentOffset = buttonFrame.size.height - contentHeight;
    
    imageFrame.size.height = (buttonFrame.size.height * 0.4);
    imageFrame.size.width = imageFrame.size.height;
    imageFrame.origin.x = ((buttonFrame.size.width - imageFrame.size.width) * 0.5);
    
    titleFrame.origin.x = 0;
    titleFrame.size.width = buttonFrame.size.width;
    titleFrame.size.height = (buttonFrame.size.height * 0.4);
    
    imageFrame.origin.y = (contentOffset * 0.5) + ((self.imageOnTop)?0.0f:(titleFrame.size.height + offsetBetweenTextAndImage));
    titleFrame.origin.y = (contentOffset * 0.5) + ((self.imageOnTop)?(imageFrame.size.height + offsetBetweenTextAndImage):0.0f);
    
    self.imageView.frame = imageFrame;
    self.titleLabel.frame = titleFrame;
}

#pragma mark - Underline Related Methods

- (void)showUnderlineWithColor:(UIColor *)color selectedColor:(UIColor *)selectedColor height:(CGFloat)height
{
    self.showUnderline = YES;
    self.underlineHeight = height;
    self.underlineColor = color;
    self.selectedUnderlineColor = selectedColor;
    
    [self prepareUnderlineView];
}

- (void)hideUnderline
{
    self.showUnderline = NO;
    [self.underlineView setHidden:YES];
}

#pragma mark - Content Alignment Related

- (void)alignTextAndImageVertically:(BOOL)vertical
{
    self.alignVertically = vertical;
    if (self.alignVertically)
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    [self layoutSubviews];
}

- (void)verticalOffsetBetweenTextAndImage:(CGFloat)offset
{
    self.textImageOffset = offset;
}

- (void)alignImageOnTop:(BOOL)imageOnTop
{
    self.imageOnTop = imageOnTop;
}

@end
