//
//  BTBadgeView.m
//
//  Version 1.1
//
//  Created by Borut Tomazin on 12/04/2013.
//  Copyright 2013 Borut Tomazin
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/borut-t/BTBadgeView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "BTBadgeView.h"

@interface BTBadgeView ()

@end

@implementation BTBadgeView

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) {
		[self initState];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super initWithCoder:decoder])) {
		[self initState];
    }
    return self;
}



#pragma mark Private methods
- (void)initState
{	
	self.opaque = NO;
	self.pad = 2;
	self.font = [UIFont boldSystemFontOfSize:16];
	self.shadow = YES;
	self.shadowOffset = CGSizeMake(0, 3);
	self.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
	self.shine = YES;
	self.alignment = UITextAlignmentCenter;
	self.fillColor = [UIColor redColor];
	self.strokeColor = [UIColor whiteColor];
	self.strokeWidth = 2.0;
	self.textColor = [UIColor whiteColor];
    self.hideWhenZero = NO;
	
	self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect 
{
	CGRect viewBounds = self.bounds;
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGSize numberSize = [_value sizeWithFont:self.font];
	CGPathRef badgePath = [self newBadgePathForTextSize:numberSize];
	CGRect badgeRect = CGPathGetBoundingBox(badgePath);
	
	badgeRect.origin.x = 0;
	badgeRect.origin.y = 0;
	badgeRect.size.width = ceil(badgeRect.size.width);
	badgeRect.size.height = ceil(badgeRect.size.height);
	
	CGContextSaveGState(context);
	CGContextSetLineWidth(context, self.strokeWidth);
	CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
	CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
	
	// Line stroke straddles the path, so we need to account for the outer portion
	badgeRect.size.width += ceilf(self.strokeWidth / 2);
	badgeRect.size.height += ceilf(self.strokeWidth / 2);
	
	CGPoint ctm;
	
	switch (self.alignment) {
		case NSTextAlignmentJustified:
		case NSTextAlignmentNatural:
		case UITextAlignmentCenter:
			ctm = CGPointMake(round((viewBounds.size.width - badgeRect.size.width)/2),
                              round((viewBounds.size.height - badgeRect.size.height)/2));
			break;
		case UITextAlignmentLeft:
			ctm = CGPointMake(0, round((viewBounds.size.height - badgeRect.size.height)/2));
			break;
		case UITextAlignmentRight:
			ctm = CGPointMake((viewBounds.size.width - badgeRect.size.width),
                              round((viewBounds.size.height - badgeRect.size.height)/2));
			break;
	}
	
	CGContextTranslateCTM(context, ctm.x, ctm.y);

    // add shadow
	if (self.shadow) {
		CGContextSaveGState(context);

		CGSize blurSize = self.shadowOffset;
		
		CGContextSetShadowWithColor(context, blurSize, 4, self.shadowColor.CGColor);
		
		CGContextBeginPath(context);
		CGContextAddPath(context, badgePath);
		CGContextClosePath(context);
		
		CGContextDrawPath(context, kCGPathFillStroke);
		CGContextRestoreGState(context);
	}
	
	CGContextBeginPath(context);
	CGContextAddPath(context, badgePath);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
    
	// add shine
	if (self.shine) {
		CGContextBeginPath(context);
		CGContextAddPath(context, badgePath);
		CGContextClosePath(context);
		CGContextClip(context);
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
		CGFloat shinyColorGradient[8] = {1, 1, 1, 0.8, 1, 1, 1, 0}; 
		CGFloat shinyLocationGradient[2] = {0, 1}; 
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, shinyColorGradient, shinyLocationGradient, 2);
		
		CGContextSaveGState(context);
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, 0, 0);
		
		CGFloat shineStartY = badgeRect.size.height*0.25;
		CGFloat shineStopY = shineStartY + badgeRect.size.height*0.4;
		
		CGContextAddLineToPoint(context, 0, shineStartY);
		CGContextAddCurveToPoint(context,
                                 0,
                                 shineStopY,
                                 badgeRect.size.width, shineStopY,
                                 badgeRect.size.width, shineStartY);
		CGContextAddLineToPoint(context, badgeRect.size.width, 0);
		CGContextClosePath(context);
		CGContextClip(context);
		CGContextDrawLinearGradient(context,
                                    gradient,
									CGPointMake(badgeRect.size.width / 2.0, 0), 
									CGPointMake(badgeRect.size.width / 2.0, shineStopY), 
									kCGGradientDrawsBeforeStartLocation); 
		CGContextRestoreGState(context);
		
		CGColorSpaceRelease(colorSpace); 
		CGGradientRelease(gradient); 
	}
    
	CGContextRestoreGState(context);
	CGPathRelease(badgePath);
	
	CGContextSaveGState(context);
	CGContextSetFillColorWithColor(context, self.textColor.CGColor);
    
    NSLog(@"point: %@",NSStringFromCGPoint(ctm));
//	CGPoint textPt = CGPointMake(ctm.x + (badgeRect.size.width - numberSize.width)/2 ,
//                                 ctm.y + (badgeRect.size.height - numberSize.height)/2);
    CGPoint textPt = CGPointMake(rect.size.width/2.f - numberSize.width/2.f,
                                 rect.size.height/2.f - numberSize.height/2.f);
	
	[_value drawAtPoint:textPt withFont:self.font];

	CGContextRestoreGState(context);
}


- (CGPathRef)newBadgePathForTextSize:(CGSize)inSize
{
	CGFloat arcRadius = ceil((inSize.height+self.pad)/2.0);
	
	CGFloat badgeWidthAdjustment = inSize.width - inSize.height/2.0;
	CGFloat badgeWidth = 2.0*arcRadius;
	
	if (badgeWidthAdjustment > 0.0) {
		badgeWidth += badgeWidthAdjustment;
	}
	
	CGMutablePathRef badgePath = CGPathCreateMutable();
	
	CGPathMoveToPoint(badgePath, NULL, arcRadius, 0);
	CGPathAddArc(badgePath, NULL, arcRadius, arcRadius, arcRadius, 3.0*M_PI_2, M_PI_2, YES);
	CGPathAddLineToPoint(badgePath, NULL, badgeWidth-arcRadius, 2.0*arcRadius);
	CGPathAddArc(badgePath, NULL, badgeWidth-arcRadius, arcRadius, arcRadius, M_PI_2, 3.0*M_PI_2, YES);
	CGPathAddLineToPoint(badgePath, NULL, arcRadius, 0);
	
	return badgePath;
}



#pragma mark Property methods
- (void)setValue:(NSString *)inValue
{
    _value = inValue;
    self.hidden = self.hideWhenZero && _value == 0;
	
	[self setNeedsDisplay];
}

- (CGSize)badgeSize
{
	CGSize numberSize = [_value sizeWithFont:self.font];
	CGPathRef badgePath = [self newBadgePathForTextSize:numberSize];
	CGRect badgeRect = CGPathGetBoundingBox(badgePath);
	
	badgeRect.origin.x = 0;
	badgeRect.origin.y = 0;
	badgeRect.size.width = ceil(badgeRect.size.width);
	badgeRect.size.height = ceil(badgeRect.size.height);
	
	CGPathRelease(badgePath);
	
	return badgeRect.size;
}

@end
