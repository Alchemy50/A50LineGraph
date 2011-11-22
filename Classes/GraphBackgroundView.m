//
//  GraphBackgroundView.m
//  MorganResearch
//
//  Created by Josh Klobe on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GraphBackgroundView.h"


@implementation GraphBackgroundView

@synthesize xCoord, yLabel, xLabel;

@synthesize 	xLabelColor, yLabelColor, lineColor;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		
		xLabelColor = [UIColor whiteColor];
		yLabelColor = [UIColor whiteColor];
		lineColor = [UIColor whiteColor];
		
		
        // Initialization code
		yLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,50,100,20)];
		yLabel.backgroundColor = [UIColor clearColor];
		yLabel.textColor = yLabelColor;
		[self addSubview:yLabel];
		
		xLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,70,100,20)];
		xLabel.backgroundColor = [UIColor clearColor];
		xLabel.textColor = xLabelColor;
		[self addSubview:xLabel];	
	
		 
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
	[yLabel release];
	[xLabel release];
	[xLabelColor release]; 
	[yLabelColor release]; 
	[lineColor release];
}

- (void)drawRect:(CGRect)rect
{
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context,1);
	CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
	
	CGPoint fromPoint = CGPointMake(xCoord,self.frame.size.height);
	CGPoint toPoint = CGPointMake(xCoord, 0);
	
	if (xCoord > 0.0)
	{
		CGContextMoveToPoint(context,fromPoint.x , fromPoint.y);
		CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
			

		CGContextStrokePath(context);
	}
	
	xLabel.textColor = xLabelColor;
	yLabel.textColor = yLabelColor;
	
	
}


@end
