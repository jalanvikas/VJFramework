//
//  NSString+VJFoundationExtension.m
//  VJFramework
//
//  Created by Vikas Jalan on 3/25/16.
//  Copyright 2016 http://www.vikasjalan.com All rights reserved.
//  Contact on jalanvikas@gmail.com or contact@vikasjalan.com
//
//  Get the latest version from here:
//  https://github.com/jalanvikas/VJFramework
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

#import "NSString+VJFoundationExtension.h"
#import "UIColor+VJKitExtension.h"

@implementation NSString (VJFoundationExtension)

- (NSString *)localizedString
{
    return NSLocalizedString(self, self);
}

- (CGSize)getSizeForWidth:(CGFloat)width withFont:(UIFont *)font numberOfLines:(NSInteger *)lines
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    
    CGSize textSize = [self sizeWithAttributes:attributes];
    CGRect textRectForWidth = [self boundingRectWithSize:CGSizeMake(width, 9999)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributes
                                                 context:nil];
    
    NSInteger noOfLines = ceil(textRectForWidth.size.height / textSize.height);
    *lines = noOfLines;
    
    return textRectForWidth.size;
}

@end

@implementation NSString (VJFAQView)

#define DEFAULT_ATTRIBUTE_STRING_COLOR                  @"000000"
#define DEFAULT_ATTRIBUTE_FONT_SIZE                     15.0f
#define DEFAULT_ATTRIBUTE_FONT_BOLD                     0

- (NSDictionary *)attributes
{
    CGFloat fontSize = DEFAULT_ATTRIBUTE_FONT_SIZE;
    BOOL bold = DEFAULT_ATTRIBUTE_FONT_BOLD;
    NSString *color = DEFAULT_ATTRIBUTE_STRING_COLOR;
    
    NSRange sizeRange = [self rangeOfString:@"size" options:NSCaseInsensitiveSearch];
    if (NSNotFound != sizeRange.location)
    {
        NSRange startQuoteRange = [self rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange((sizeRange.location + sizeRange.length), ([self length] - (sizeRange.location + sizeRange.length)))];
        if (NSNotFound != startQuoteRange.length)
        {
            NSRange endQuoteRange = [self rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange((startQuoteRange.location + startQuoteRange.length), ([self length] - (startQuoteRange.location + startQuoteRange.length)))];
            if (NSNotFound != endQuoteRange.length)
            {
                NSString *fontSizeString = [self substringWithRange:NSMakeRange((startQuoteRange.location + startQuoteRange.length), (endQuoteRange.location - (startQuoteRange.location + startQuoteRange.length)))];
                fontSize = [fontSizeString floatValue];
            }
        }
    }
    
    NSRange boldRange = [self rangeOfString:@"bold" options:NSCaseInsensitiveSearch];
    if (NSNotFound != boldRange.location)
    {
        NSRange startQuoteRange = [self rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange((boldRange.location + boldRange.length), ([self length] - (boldRange.location + boldRange.length)))];
        if (NSNotFound != startQuoteRange.length)
        {
            NSRange endQuoteRange = [self rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange((startQuoteRange.location + startQuoteRange.length), ([self length] - (startQuoteRange.location + startQuoteRange.length)))];
            if (NSNotFound != endQuoteRange.length)
            {
                NSString *boldString = [self substringWithRange:NSMakeRange((startQuoteRange.location + startQuoteRange.length), (endQuoteRange.location - (startQuoteRange.location + startQuoteRange.length)))];
                bold = [boldString boolValue];
            }
        }
    }
    
    NSRange colorRange = [self rangeOfString:@"color" options:NSCaseInsensitiveSearch];
    if (NSNotFound != colorRange.location)
    {
        NSRange startQuoteRange = [self rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange((colorRange.location + colorRange.length), ([self length] - (colorRange.location + colorRange.length)))];
        if (NSNotFound != startQuoteRange.length)
        {
            NSRange endQuoteRange = [self rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange((startQuoteRange.location + startQuoteRange.length), ([self length] - (startQuoteRange.location + startQuoteRange.length)))];
            if (NSNotFound != endQuoteRange.length)
            {
                NSString *colorString = [self substringWithRange:NSMakeRange((startQuoteRange.location + startQuoteRange.length), (endQuoteRange.location - (startQuoteRange.location + startQuoteRange.length)))];
                color = colorString;
            }
        }
    }
    
    NSMutableDictionary *stringAttribute = [NSMutableDictionary dictionary];
    [stringAttribute setObject:(bold?[UIFont boldSystemFontOfSize:fontSize]:[UIFont systemFontOfSize:fontSize]) forKey:NSFontAttributeName];
    [stringAttribute setObject:[UIColor colorFromHexString:color] forKey:NSForegroundColorAttributeName];
    
    return stringAttribute;
}

- (NSAttributedString *)attributedString
{
    NSMutableDictionary *defaultAttributes = [NSMutableDictionary dictionary];
    [defaultAttributes setObject:[UIFont systemFontOfSize:DEFAULT_ATTRIBUTE_FONT_SIZE] forKey:NSFontAttributeName];
    [defaultAttributes setObject:[UIColor colorFromHexString:DEFAULT_ATTRIBUTE_STRING_COLOR] forKey:NSForegroundColorAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    NSRange stringRange = NSMakeRange(0, [self length]);
    while (NSNotFound != stringRange.location)
    {
        NSRange attributeRange = [self rangeOfString:@"<attribute" options:NSCaseInsensitiveSearch range:stringRange];
        if (NSNotFound != attributeRange.location)
        {
            NSRange closeAttributeRange = [self rangeOfString:@">" options:NSCaseInsensitiveSearch range:stringRange];
            NSRange endAttributeRange = [self rangeOfString:@"</attribute>" options:NSCaseInsensitiveSearch range:stringRange];
            if ((NSNotFound != closeAttributeRange.location) && (NSNotFound != endAttributeRange.location))
            {
                if (attributeRange.location > stringRange.location)
                {
                    NSRange subStringRange = NSMakeRange(stringRange.location, (attributeRange.location - stringRange.location));
                    NSAttributedString *subString = [[NSAttributedString alloc] initWithString:[self substringWithRange:subStringRange] attributes:defaultAttributes];
                    [attributedString appendAttributedString:subString];
                }
                
                NSRange subStringAttributeRange = NSMakeRange(attributeRange.location, ((closeAttributeRange.location + closeAttributeRange.length) - attributeRange.location));
                NSRange attributedSubStringRange = NSMakeRange((closeAttributeRange.location + closeAttributeRange.length), (endAttributeRange.location - (closeAttributeRange.location + closeAttributeRange.length)));
                NSAttributedString *attributedSubString = [[NSAttributedString alloc] initWithString:[self substringWithRange:attributedSubStringRange] attributes:[[self substringWithRange:subStringAttributeRange] attributes]];
                [attributedString appendAttributedString:attributedSubString];
            }
            
            if (NSNotFound != endAttributeRange.location)
            {
                stringRange.location = (endAttributeRange.location + endAttributeRange.length);
                stringRange.length = ([self length] - stringRange.location);
                if (stringRange.location == [self length])
                {
                    stringRange.location = NSNotFound;
                }
            }
            else
            {
                stringRange.location = NSNotFound;
            }
        }
        else
        {
            NSAttributedString *subString = [[NSAttributedString alloc] initWithString:[self substringWithRange:stringRange] attributes:defaultAttributes];
            [attributedString appendAttributedString:subString];
            stringRange.location = NSNotFound;
        }
    }
    
    return attributedString;
}

- (BOOL)isAttributedString
{
    NSRange stringRange = NSMakeRange(0, [self length]);
    NSRange attributeRange = [self rangeOfString:@"<attribute" options:NSCaseInsensitiveSearch range:stringRange];
    NSRange endAttributeRange = [self rangeOfString:@"</attribute>" options:NSCaseInsensitiveSearch range:stringRange];
    if ((NSNotFound == attributeRange.location) && (NSNotFound == endAttributeRange.location))
        return NO;
    else
        return YES;
}

@end
