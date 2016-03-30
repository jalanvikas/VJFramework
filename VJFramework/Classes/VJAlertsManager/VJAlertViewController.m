//
//  VJAlertViewController.m
//  VJFramework
//
//  Created by Vikas Jalan on 28/03/16.
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

#import "VJAlertViewController.h"
#import "VJFramework+Private.h"
#import "NSString+VJFoundationExtension.h"

#define CANCEL_BUTTON_TAG       4321
#define OTHER_BUTTON_START_TAG  6500

#define START_Y_OFFSET              10
#define OFFSET_BETWEEN_CONTROLS     10

#define ALERT_BUTTON_HEIGHT         40.0
#define OFFSET_FOR_ALERT_VIEW       30.0

#define ALERT_VIEW_BACKGROUND_COLOR                         [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6]
#define ALERT_CONTENT_HOLDER_VIEW_COLOR                     [UIColor whiteColor]
#define ALERT_TITLE_LABEL_COLOR                             [UIColor blackColor]
#define ALERT_MESSAGE_LABEL_COLOR                           [UIColor blackColor]
#define ALERT_BUTTONS_COLOR                                 [UIColor blueColor]
#define ALERT_BUTTON_SEPARATOR_VIEW_COLOR                   [UIColor lightGrayColor]

#define ALERT_TITLE_LABEL_FONT                          [UIFont systemFontOfSize:18]
#define ALERT_MESSAGE_LABEL_FONT                        [UIFont systemFontOfSize:15]
#define ALERT_NORMAL_BUTTON_FONT                        [UIFont systemFontOfSize:15]
#define ALERT_CANCEL_BUTTON_FONT                        [UIFont boldSystemFontOfSize:15]


@interface VJAlertViewController ()

@property (nonatomic, weak) IBOutlet UIView *contentHolderView;
@property (nonatomic, weak) IBOutlet UILabel *alertTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *alertMessageLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *buttonsHolderScrollView;

@property (nonatomic, strong) NSString *alertTitle;
@property (nonatomic, strong) NSString *alertMessage;
@property (nonatomic, strong) NSString *cancelButton;
@property (nonatomic, strong) NSArray *otherButtons;

@property (copy) void (^alertViewCompletionHandler)(BOOL isCancelButton, NSInteger buttonIndex);

#pragma mark - Private Methods

- (NSInteger)totalNumberOfButtons;

- (CGFloat)getMaxHeightForAlertView;

- (void)initialize;

- (UIButton *)getButtonWithTitle:(NSString *)buttonTitle isCancelButton:(BOOL)cancelButton;

- (void)setupUI;

- (void)organizeTitleFromYAxis:(CGFloat)yAxis;

- (void)organizeMessageFromYAxis:(CGFloat)yAxis maxHeight:(CGFloat)maxHeight;

- (void)organizeButtonsFromYAxis:(CGFloat)yAxis maxHeight:(CGFloat)maxHeight;

#pragma mark - Action Methods

- (void)buttonClicked:(id)sender;

@end

@implementation VJAlertViewController

#pragma mark - Designated Initializer Methods

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles completion:(void (^)(BOOL isCancelButton, NSInteger buttonIndex))completion
{
    self = [super initWithNibName:NSStringFromClass([VJAlertViewController class]) bundle:[NSBundle bundleWithIdentifier:VJFRAMEWORK_IDENTIFIER]];
    if (self)
    {
        self.alertTitle = title;
        self.alertMessage = message;
        self.cancelButton = cancelButtonTitle;
        self.otherButtons = otherButtonTitles;
        
        self.alertViewCompletionHandler = completion;
    }
    
    return self;
}

#pragma mark - View Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialize];
    [self setupUI];
    
    CGAffineTransform trans = CGAffineTransformMakeScale(1.1, 1.1);
    self.contentHolderView.transform = trans;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.15 animations:^{
        CGAffineTransform trans = CGAffineTransformMakeScale(1.05, 1.05);
        self.contentHolderView.transform = trans;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1 animations:^{
            CGAffineTransform trans = CGAffineTransformMakeScale(1.0, 1.0);
            self.contentHolderView.transform = trans;
        } completion:^(BOOL finished){
            
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (NSInteger)totalNumberOfButtons
{
    NSInteger buttonsCount = 0;
    
    if (nil != self.otherButtons)
        buttonsCount = [self.otherButtons count];
    
    if ((nil != self.cancelButton) && (0 < [self.cancelButton length]))
        buttonsCount += 1;
    
    return buttonsCount;
}

- (CGFloat)getMaxHeightForAlertView
{
    CGFloat maxHeight = [[UIScreen mainScreen] bounds].size.height;
    if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom])
    {
        maxHeight = MIN([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
        maxHeight -= (OFFSET_FOR_ALERT_VIEW * 2);
    }
    else
    {
        maxHeight -= OFFSET_FOR_ALERT_VIEW;
    }
    
    return maxHeight;
}

- (void)initialize
{
    [self.view setBackgroundColor:ALERT_VIEW_BACKGROUND_COLOR];
    
    [self.contentHolderView setBackgroundColor:ALERT_CONTENT_HOLDER_VIEW_COLOR];
    [self.contentHolderView.layer setCornerRadius:10.0];
    [self.contentHolderView setClipsToBounds:YES];
    
    [self.alertTitleLabel setFont:ALERT_TITLE_LABEL_FONT];
    [self.alertTitleLabel setTextColor:ALERT_TITLE_LABEL_COLOR];
    
    [self.alertMessageLabel setFont:ALERT_MESSAGE_LABEL_FONT];
    [self.alertMessageLabel setTextColor:ALERT_MESSAGE_LABEL_COLOR];
}

- (UIButton *)getButtonWithTitle:(NSString *)buttonTitle isCancelButton:(BOOL)cancelButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0.0, 0.0, self.buttonsHolderScrollView.frame.size.width, ALERT_BUTTON_HEIGHT)];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:ALERT_BUTTONS_COLOR forState:UIControlStateNormal];
    if (cancelButton)
    {
        [button.titleLabel setFont:ALERT_CANCEL_BUTTON_FONT];
        [button setTag:CANCEL_BUTTON_TAG];
    }
    else
    {
        [button.titleLabel setFont:ALERT_NORMAL_BUTTON_FONT];
    }
    
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)setupUI
{
    CGFloat yAxis = START_Y_OFFSET;
    
    [self organizeTitleFromYAxis:yAxis];
    yAxis += (([self.alertTitleLabel isHidden])?0.0:(self.alertTitleLabel.frame.size.height + OFFSET_BETWEEN_CONTROLS));
    
    CGFloat messageMaxHeight = ([self getMaxHeightForAlertView] - yAxis) * 0.5;
    [self organizeMessageFromYAxis:yAxis maxHeight:messageMaxHeight];
    yAxis += (([self.alertMessageLabel isHidden])?0.0:(self.alertMessageLabel.frame.size.height + OFFSET_BETWEEN_CONTROLS));
    
    CGFloat buttonsMaxHeight = ([self getMaxHeightForAlertView] - yAxis);
    [self organizeButtonsFromYAxis:yAxis maxHeight:buttonsMaxHeight];
    yAxis += ((0 == [self totalNumberOfButtons])?0.0:self.buttonsHolderScrollView.frame.size.height);
    
    CGRect contentHolderFrame = self.contentHolderView.frame;
    contentHolderFrame.size.height = yAxis;
    self.contentHolderView.frame = contentHolderFrame;
    
    self.contentHolderView.center = self.view.center;
}

- (void)organizeTitleFromYAxis:(CGFloat)yAxis
{
    if ((nil != self.alertTitle) && (0 < [self.alertTitle length]))
    {
        self.alertTitleLabel.text = self.alertTitle;
        self.alertTitleLabel.hidden = NO;
        NSInteger numberOfLinesForTitle = 1;
        CGSize titleSize = [self.alertTitle getSizeForWidth:self.alertTitleLabel.frame.size.width
                                                   withFont:self.alertTitleLabel.font
                                              numberOfLines:&numberOfLinesForTitle];
        CGRect titleRect = self.alertTitleLabel.frame;
        titleRect.origin.y = yAxis;
        titleRect.size.height = titleSize.height;
        [self.alertTitleLabel setFrame:titleRect];
    }
    else
    {
        self.alertTitleLabel.hidden = YES;
    }
}

- (void)organizeMessageFromYAxis:(CGFloat)yAxis maxHeight:(CGFloat)maxHeight
{
    if ((nil != self.alertMessage) && (0 < [self.alertMessage length]))
    {
        self.alertMessageLabel.text = self.alertMessage;
        self.alertMessageLabel.hidden = NO;
        NSInteger numberOfLinesForMessage = 1;
        CGSize messageSize = [self.alertMessage getSizeForWidth:self.alertMessageLabel.frame.size.width
                                                       withFont:self.alertMessageLabel.font
                                                  numberOfLines:&numberOfLinesForMessage];

        [self.alertMessageLabel setNumberOfLines:numberOfLinesForMessage];
        
        CGRect messageRect = self.alertMessageLabel.frame;
        messageRect.origin.y = yAxis;
        messageRect.size.height = MIN(messageSize.height, maxHeight);
        [self.alertMessageLabel setFrame:messageRect];
    }
    else
    {
        self.alertMessageLabel.hidden = YES;
    }
}

- (void)organizeButtonsFromYAxis:(CGFloat)yAxis maxHeight:(CGFloat)maxHeight
{
    if (0 < [self totalNumberOfButtons])
    {
        [self.buttonsHolderScrollView setHidden:NO];
        CGFloat buttonYAxis = 0.0;
        for (int index = 0; index < [self.otherButtons count]; index++)
        {
            UIButton *button = [self getButtonWithTitle:[self.otherButtons objectAtIndex:index] isCancelButton:NO];
            CGRect buttonFrame = button.frame;
            buttonFrame.origin.y = buttonYAxis;
            button.frame = buttonFrame;
            
            [button setTag:(OTHER_BUTTON_START_TAG + index)];
            [self.buttonsHolderScrollView addSubview:button];
            buttonYAxis += buttonFrame.size.height;
            
            BOOL shouldAddButtonSeparator = NO;
            if (((nil != self.cancelButton) && (0 < [self.cancelButton length])) ||
                (index < ([self.otherButtons count] - 1)))
                shouldAddButtonSeparator = YES;
            
            if (shouldAddButtonSeparator)
            {
                UIView *buttonSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, buttonYAxis, buttonFrame.size.width, 1.0)];
                [buttonSeparatorView setBackgroundColor:ALERT_BUTTON_SEPARATOR_VIEW_COLOR];
                [self.buttonsHolderScrollView addSubview:buttonSeparatorView];
                buttonYAxis += buttonSeparatorView.frame.size.height;
            }
        }
        
        if ((nil != self.cancelButton) && (0 < [self.cancelButton length]))
        {
            UIButton *button = [self getButtonWithTitle:self.cancelButton isCancelButton:YES];
            CGRect buttonFrame = button.frame;
            buttonFrame.origin.y = buttonYAxis;
            button.frame = buttonFrame;
            
            [self.buttonsHolderScrollView addSubview:button];
            buttonYAxis += buttonFrame.size.height;
        }
        
        CGRect buttonsHolderScrollViewFrame = self.buttonsHolderScrollView.frame;
        buttonsHolderScrollViewFrame.origin.y = yAxis;
        buttonsHolderScrollViewFrame.size.height = MIN(buttonYAxis, maxHeight);
        self.buttonsHolderScrollView.frame = buttonsHolderScrollViewFrame;
        
        [self.buttonsHolderScrollView setContentSize:CGSizeMake(buttonsHolderScrollViewFrame.size.width, buttonYAxis)];
    }
    else
    {
        [self.buttonsHolderScrollView setHidden:YES];
    }
}

#pragma mark - Action Methods

- (void)buttonClicked:(id)sender
{
    if (NULL != self.alertViewCompletionHandler)
    {
        if (CANCEL_BUTTON_TAG == [(UIButton *)sender tag])
        {
            self.alertViewCompletionHandler(YES, -1);
        }
        else
        {
            self.alertViewCompletionHandler(NO, ([(UIButton *)sender tag] - OTHER_BUTTON_START_TAG));
        }
    }
}

@end
