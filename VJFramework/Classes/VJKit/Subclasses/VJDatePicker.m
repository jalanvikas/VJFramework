//
//  VJDatePicker.m
//  VJFramework
//
//  Created by Vikas Jalan on 4/12/16.
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

#import "VJDatePicker.h"

@interface VJDatePicker ()

@property (nonatomic, strong) UIDatePicker *datePicker;

#pragma mark - Private Methods

- (void)initialize;

@end


@implementation VJDatePicker

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
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

#pragma mark - Private Methods

- (void)initialize
{
    
}

#pragma mark - Setter/Getter Methods

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    [self.datePicker setDatePickerMode:datePickerMode];
}

- (UIDatePickerMode)datePickerMode
{
    return self.datePicker.datePickerMode;
}

- (void)setLocale:(NSLocale *)locale
{
    [self.datePicker setLocale:locale];
}

- (NSLocale *)locale
{
    return self.datePicker.locale;
}

- (void)setCalendar:(NSCalendar *)calendar
{
    [self.datePicker setCalendar:calendar];
}

- (NSCalendar *)calendar
{
    return self.datePicker.calendar;
}

- (void)setTimeZone:(NSTimeZone *)timeZone
{
    [self.datePicker setTimeZone:timeZone];
}

- (NSTimeZone *)timeZone
{
    return self.datePicker.timeZone;
}

- (void)setDate:(NSDate *)date
{
    [self.datePicker setDate:date];
}

- (NSDate *)date
{
    return self.datePicker.date;
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
    [self.datePicker setMinimumDate:minimumDate];
}

- (NSDate *)minimumDate
{
    return self.datePicker.minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    [self.datePicker setMaximumDate:maximumDate];
}

- (NSDate *)maximumDate
{
    return self.datePicker.maximumDate;
}

- (void)setCountDownDuration:(NSTimeInterval)countDownDuration
{
    [self.datePicker setCountDownDuration:countDownDuration];
}

- (NSTimeInterval)countDownDuration
{
    return self.datePicker.countDownDuration;
}

- (void)setMinuteInterval:(NSInteger)minuteInterval
{
    [self.datePicker setMinuteInterval:minuteInterval];
}

- (NSInteger)minuteInterval
{
    return self.datePicker.minuteInterval;
}

- (void)setDate:(nonnull NSDate *)date animated:(BOOL)animated
{
    [self.datePicker setDate:date animated:animated];
}

@end
