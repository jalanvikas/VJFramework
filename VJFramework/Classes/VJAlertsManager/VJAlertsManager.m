//
//  VJAlertsManager.m
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

#import "VJAlertsManager.h"
#import "VJAlertViewController.h"

#define ALERT_TITLE_KEY                 @"alertTitle"
#define ALERT_MESSAGE_KEY               @"alertMessage"
#define ALERT_CANCEL_BUTTON_KEY         @"alertCancelButton"
#define ALERT_OTHER_BUTTONS_KEY         @"alertOtherButtons"
#define ALERT_COMPLETION_BLOCK_KEY      @"alertCompletionBlock"

@interface VJAlertsManager ()

@property (nonatomic, strong) NSMutableArray *queuedAlerts;
@property (nonatomic, assign) BOOL isAlertShown;

@property (nonatomic, strong) VJAlertViewController *alertViewController;

#pragma mark - Private Methods

- (void)showAlertWithInfo:(NSDictionary *)alertInfo;

- (void)removeFirstQueuedAlertInfo;

@end

@implementation VJAlertsManager

- (id)init
{
    self = [super init];
    if (self)
    {
        self.queuedAlerts = [NSMutableArray array];
        self.isAlertShown = NO;
    }
    
    return self;
}

#pragma mark - Singleton Method

+ (VJAlertsManager *)sharedInstance
{
    static VJAlertsManager *_manager = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _manager = [[VJAlertsManager alloc] init];
    });
    
    return _manager;
}

#pragma mark - Custom Method

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles completion:(void (^)(BOOL isCancelButton, NSInteger buttonIndex))completion
{
    NSMutableDictionary *alertInfo = [NSMutableDictionary dictionary];
    if (nil != title)
        [alertInfo setObject:title forKey:ALERT_TITLE_KEY];
    if (nil != message)
        [alertInfo setObject:message forKey:ALERT_MESSAGE_KEY];
    if (nil != cancelButtonTitle)
        [alertInfo setObject:cancelButtonTitle forKey:ALERT_CANCEL_BUTTON_KEY];
    if (nil != otherButtonTitles)
        [alertInfo setObject:otherButtonTitles forKey:ALERT_OTHER_BUTTONS_KEY];
    if (nil != completion)
        [alertInfo setObject:completion forKey:ALERT_COMPLETION_BLOCK_KEY];
        
    if (self.isAlertShown)
    {
        [self.queuedAlerts addObject:alertInfo];
    }
    else
    {
        [self showAlertWithInfo:alertInfo];
    }
}

#pragma mark - Private Methods

- (void)showAlertWithInfo:(NSDictionary *)alertInfo
{
    self.isAlertShown = YES;
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    self.alertViewController = [[VJAlertViewController alloc] initWithTitle:[alertInfo objectForKey:ALERT_TITLE_KEY] message:[alertInfo objectForKey:ALERT_MESSAGE_KEY] cancelButtonTitle:[alertInfo objectForKey:ALERT_CANCEL_BUTTON_KEY] otherButtonTitles:[alertInfo objectForKey:ALERT_OTHER_BUTTONS_KEY] completion:^(BOOL isCancelButton, NSInteger buttonIndex){
        
        void (^completionHandler)(BOOL isCancelButton, NSInteger buttonIndex) = [alertInfo objectForKey:ALERT_COMPLETION_BLOCK_KEY];
        completionHandler(isCancelButton, buttonIndex);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.alertViewController.view.alpha = 0.0;
        }completion:^(BOOL finished){
            [self.alertViewController.view removeFromSuperview];
            self.alertViewController = nil;
            self.isAlertShown = NO;
            if (0 < [self.queuedAlerts count])
            {
                NSDictionary *queuedAlertInfo = [self.queuedAlerts objectAtIndex:0];
                [self performSelectorOnMainThread:@selector(removeFirstQueuedAlertInfo) withObject:nil waitUntilDone:YES];
                if (![[NSThread currentThread] isMainThread])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showAlertWithInfo:queuedAlertInfo];
                    });
                }
                else
                {
                    [self showAlertWithInfo:queuedAlertInfo];
                }
            }
        }];
    }];
    
    self.alertViewController.view.alpha = 0.0;
    self.alertViewController.view.frame = keyWindow.frame;
    [keyWindow addSubview:self.alertViewController.view];
    [UIView animateWithDuration:0.3 animations:^{
        self.alertViewController.view.alpha = 1.0;
    }];
}

- (void)removeFirstQueuedAlertInfo
{
    [self.queuedAlerts removeObjectAtIndex:0];
}

@end
