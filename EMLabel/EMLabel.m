/*
 
 EMLabel.m
 
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

#import "EMLabel.h"
#import <CoreText/CoreText.h>


static CFAttributedStringRef CFAttributedStringCreateCopyWithAdjustedFontSize(CFAttributedStringRef attributedString, CGSize constrainingSize)
{
    CFMutableAttributedStringRef fittedAttributedString = CFAttributedStringCreateMutableCopy(NULL, 0, attributedString);
    
    CTFontRef font = CFAttributedStringGetAttribute(fittedAttributedString, 0, kCTFontAttributeName, NULL);
    CGFloat fontSize = CTFontGetSize(font);
    CFRelease(font);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(fittedAttributedString);
    CGSize suggestedFrameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, CFAttributedStringGetLength(fittedAttributedString)), NULL, CGSizeZero, NULL);
    CFRelease(framesetter);
    
    CGSize calculatedFrameSize = suggestedFrameSize;
    
    if (suggestedFrameSize.width > constrainingSize.width && fontSize > 0.0)
    {
    
        // Use binary search to find optimal scale factor
        
        float maxScaleFactor = 1.0f;
        float minScaleFactor = 0;
        
        float accuracy = 0.01f;
        
        while ((maxScaleFactor - minScaleFactor) > accuracy)
        {
            float scaleFactorTest = (maxScaleFactor + minScaleFactor) / 2;
            
            font = CTFontCreateCopyWithAttributes(font, fontSize * scaleFactorTest, NULL, NULL);
            CFAttributedStringSetAttribute(fittedAttributedString, CFRangeMake(0, CFAttributedStringGetLength(fittedAttributedString)), kCTFontAttributeName, font);
            CFRelease(font);
            
            framesetter = CTFramesetterCreateWithAttributedString(fittedAttributedString);
            calculatedFrameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, CFAttributedStringGetLength(fittedAttributedString)), NULL, CGSizeZero, NULL);
            CFRelease(framesetter);
            
            if (calculatedFrameSize.width > constrainingSize.width)
            {
                maxScaleFactor = scaleFactorTest;
            }
            else
            {
                minScaleFactor = scaleFactorTest;
            }
        }
        
        font = CTFontCreateCopyWithAttributes(font, fontSize * minScaleFactor, NULL, NULL);
        CFAttributedStringSetAttribute(fittedAttributedString, CFRangeMake(0, CFAttributedStringGetLength(fittedAttributedString)), kCTFontAttributeName, font);
        CFRelease(font);
    }
    
    return fittedAttributedString;
}

static CGRect RectWithVerticalAlignment(CGSize frameSize, CGRect enclosingFrame, EMLabelVerticalAlignment verticalAlignment)
{
    float verticalAlignedY = 0.0;
    switch (verticalAlignment) {
        case EMLabelVerticalAlignmentTop:
            verticalAlignedY = -(enclosingFrame.origin.y + frameSize.height);
            break;
        case EMLabelVerticalAlignmentBottom:
            verticalAlignedY = -(enclosingFrame.origin.y + enclosingFrame.size.height);
            break;
        case EMLabelVerticalAlignmentMiddle:
        default:
            verticalAlignedY = -(enclosingFrame.origin.y + (enclosingFrame.size.height / 2) + (frameSize.height / 2));
            break;
    }
    
    CGRect adjustedFrame = CGRectMake(enclosingFrame.origin.x, verticalAlignedY, frameSize.width, frameSize.height);
    
    return adjustedFrame;
}

static CTFrameRef CFAttributedStringCreateFrame(CFAttributedStringRef attributedString, EMLabelVerticalAlignment verticalAlignment, CGRect frame, bool adjustSize)
{
    CFAttributedStringRef fittedAttributedString = CFAttributedStringCreateCopy(NULL, attributedString);
    
    if (adjustSize)
    {
        fittedAttributedString = CFAttributedStringCreateCopyWithAdjustedFontSize(attributedString, frame.size);
    }
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(fittedAttributedString);
    CFRelease(fittedAttributedString);
    
    CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, frame.size, NULL);
    frameSize = CGSizeMake(frame.size.width, frameSize.height);
    CGRect adjustedFrame = RectWithVerticalAlignment(frameSize, frame, verticalAlignment);
    
    // Create text frame for path
    CGPathRef path = CGPathCreateWithRect(adjustedFrame, NULL);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    CFRelease(framesetter);
    
    return textFrame;
}

static inline CTTextAlignment CTTextAlignmentFromNSTextAlignment(NSTextAlignment alignment) {
	switch (alignment) {
		case NSTextAlignmentLeft:
            return kCTLeftTextAlignment;
		case NSTextAlignmentCenter:
            return kCTCenterTextAlignment;
		case NSTextAlignmentRight:
            return kCTRightTextAlignment;
		default:
            return kCTNaturalTextAlignment;
	}
}


@implementation EMLabel

- (id)init
{
    self = [super init];
    if (self) {
        self.adjustsFontSizeToFitWidth = NO;
        self.textColor = [UIColor blackColor];
        self.textAlignment = NSTextAlignmentLeft;
        self.verticalAlignment = EMLabelVerticalAlignmentMiddle;
        self.font = [UIFont systemFontOfSize:17.0];
    }
    return self;
}

- (id)initWithFrame: (CGRect)frame
{
    self = [self init];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)drawInContext: (CGContextRef)context
{
    CGContextSaveGState(context);
    
    if (self.backgroundColor)
    {
        CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);
        CGContextFillRect(context, self.frame);
    }
    
    if (self.text.length > 0)
    {
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        
        CTTextAlignment alignment = CTTextAlignmentFromNSTextAlignment(self.textAlignment);
        CTParagraphStyleSetting settings[] = { kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment} ;
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
        
        // Turn label values into attributed string
        CFStringRef keys[] = { kCTFontAttributeName, kCTForegroundColorAttributeName, kCTParagraphStyleAttributeName };
        CFTypeRef values[] = { (__bridge CTFontRef)(self.font), CGColorCreateCopy([self.textColor CGColor]), paragraphStyle };
        
        CFDictionaryRef attributes =
        CFDictionaryCreate(NULL, (const void**)&keys,
                           (const void**)&values, sizeof(keys) / sizeof(keys[0]),
                           &kCFTypeDictionaryKeyCallBacks,
                           &kCFTypeDictionaryValueCallBacks);
        CFRelease(paragraphStyle);
        
        CFAttributedStringRef attributedString = CFAttributedStringCreate(NULL, (__bridge CFStringRef)self.text, attributes);
        CFRelease(attributes);
        
        // Create and draw frame
        CTFrameRef textFrame = CFAttributedStringCreateFrame(attributedString, self.verticalAlignment, self.frame, self.adjustsFontSizeToFitWidth);
        CFRelease(attributedString);
        
        CTFrameDraw(textFrame, context);
        CFRelease(textFrame);
    }
    
    CGContextRestoreGState(context);
}

@end
