/*
 
 EMLabel.h
 
 Copyright (c) 2014 Erik Malyak
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, EMLabelVerticalAlignment) {
    EMLabelVerticalAlignmentTop,
    EMLabelVerticalAlignmentMiddle,
    EMLabelVerticalAlignmentBottom
};

@interface EMLabel : NSObject

@property(nonatomic, strong) NSString *text; // Default is nil

@property(nonatomic, strong) UIFont *font; // Default is nil with system font and size of 17.0
@property(nonatomic, strong) UIColor *textColor; // Default is nil with black color
@property(nonatomic, strong) UIColor *backgroundColor; // Default is nil with no background color (clear)

@property(nonatomic) NSTextAlignment textAlignment; // Default is NSTextAlignmentLeft
@property(nonatomic) EMLabelVerticalAlignment verticalAlignment; // Default is EMLabelVerticalAlignmentMiddle

@property(nonatomic) BOOL adjustsFontSizeToFitWidth; // Default is NO

@property(nonatomic) CGRect frame; // Default is nil

- (id)initWithFrame: (CGRect)frame;
- (void)drawInContext: (CGContextRef)context;

@end
