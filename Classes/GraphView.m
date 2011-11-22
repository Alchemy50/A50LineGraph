//
//  GraphView.m
//  MorganResearch
//
//  Created by Josh Klobe on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "LineGraphDataObject.h"





@implementation GraphView

@synthesize graphBackgroundView, xStep, yStep, lastPointOnGraph, lineGraphDataObjectArray;
@synthesize highPointOnGraph, lowPointOnGraph, xAxisLabelsArray, doProjection, xAxes, yAxes;
@synthesize xLabelColor, yLabelColor, gridColor, lineColor, graphTrackColor, projectionStrokeColor, projectionFillColor, projectionHighLabel, projectionLowLabel, highCircleColor, lowCircleColor, lastCircleColor;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		doProjection = NO;
		xAxes = 7;
		yAxes = 5;	
		
		xLabelColor = [UIColor darkGrayColor];
		yLabelColor = [UIColor darkGrayColor];
		gridColor = [UIColor lightGrayColor];
		lineColor = [[UIColor colorWithRed:80.0f/255.0f green:152.0f/255.0f blue:200.0f/255.0f alpha:1] retain];
		
		projectionStrokeColor = [UIColor lightGrayColor];
		projectionFillColor = [[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:0.2] retain];
		projectionHighLabel = [UIColor blueColor];	  
		projectionLowLabel = [UIColor redColor];
		
		lowCircleColor = [[UIColor colorWithRed:255.0f/255.0f green:0/255.0f blue:0/255.0f alpha:0.3] retain];
		highCircleColor = [[UIColor colorWithRed:0/255.0f green:255.0f/255.0f blue:0/255.0f alpha:0.3] retain];
		lastCircleColor = [[UIColor colorWithRed:0/255.0f green:0/255.0f blue:255.0f/255.0f alpha:0.3] retain];

								
		
		
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
	
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setMaximumFractionDigits:2];
	[numberFormatter setMinimumFractionDigits:2];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];

	for (int i = 0; i < [xAxisLabelsArray count]; i++)
	{
		[((UILabel *)[xAxisLabelsArray objectAtIndex:i]) removeFromSuperview];
		
	}
	xAxisLabelsArray = [[NSMutableArray alloc] initWithCapacity:0];
	@try
	{
		
		/// -------Draw chart x axes
		float maxWidth = self.frame.size.width;
		
		float width = 0;
		if (doProjection)
			width = self.frame.size.width * 500/678;	
		else 
			width = self.frame.size.width;

		float viewHeight = self.frame.size.height;
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSetLineWidth(context,.25);
		CGContextSetStrokeColorWithColor(context, gridColor.CGColor);

		float xAxesStepDistance = (viewHeight / xAxes);
		
		// top x axis		
		CGPoint pointA = CGPointMake(0, 1);
		CGPoint pointB = CGPointMake(width, 1);  // was max width
		CGContextMoveToPoint(context,pointA.x , pointA.y);
		CGContextAddLineToPoint(context, pointB.x, pointB.y);
		CGContextStrokePath(context);		
		
		// middle xAxes
		for (int i = 1; i < xAxes; i++)
		{
			pointA = CGPointMake(0, xAxesStepDistance * i);
			pointB = CGPointMake(width, pointA.y);
			CGContextMoveToPoint(context,pointA.x , pointA.y);
			CGContextAddLineToPoint(context, pointB.x, pointB.y);
		}
		
		// bottom xAxis
		pointA = CGPointMake(0, viewHeight - 1);
		pointB = CGPointMake(width, viewHeight - 1);  // was max width
		CGContextMoveToPoint(context,pointA.x , pointA.y);
		CGContextAddLineToPoint(context, pointB.x, pointB.y);
		CGContextStrokePath(context);	
		
		// Get max and min
		float total = 0.0;
		float high = 0.0;
		float low = 0.0;
		for (int i = 0; i < [lineGraphDataObjectArray count]; i++)
		{
			LineGraphDataObject *gdo = [lineGraphDataObjectArray objectAtIndex:i];
			if (i == 0)
			{
				low = [gdo.yMetric floatValue];
				high = [gdo.yMetric floatValue]; 
			}
			
			float val = [gdo.yMetric floatValue];
			total += val;
			
			if (val > high)
				high = val;
			if (val < low)
				low = val;
			
		}

		float lowHighSpreadDistance = high - low;
		
		xStep = width / [lineGraphDataObjectArray count];
		yStep = self.frame.size.height / lowHighSpreadDistance;
		
		float midpoint = total / [lineGraphDataObjectArray count];
		
		
		float normalizedHigh = 0.0;
		float normalizedLow = 0.0;
		NSMutableArray *positionOffsetArray = [NSMutableArray arrayWithCapacity:0];
		
		total  = 0;
		for (int i = 0; i < [lineGraphDataObjectArray count]; i++)
		{
			LineGraphDataObject *gdo = [lineGraphDataObjectArray objectAtIndex:i];
			
			float diff = [gdo.yMetric floatValue] - midpoint;
			if (i == 0)
			{
				normalizedLow = diff;
				normalizedHigh = diff;
			}
			if (diff < normalizedLow)
				normalizedLow = diff;
			if (diff > normalizedHigh)
				normalizedHigh = diff;
			
			[positionOffsetArray addObject:[NSNumber numberWithFloat:diff]];
		}

		/// -------Draw line graph	
		CGPoint fromPoint = CGPointMake(50,50);
		CGPoint toPoint = CGPointMake(0,midpoint);
		
		context = UIGraphicsGetCurrentContext();
		
		CGContextSetLineWidth(context,2);
		//	CGContextSetStrokeColorWithColor(context, xLabelColor.CGColor);
		CGContextSetStrokeColorWithColor(context, lineColor.CGColor);	
		for (int i = 0; i < [lineGraphDataObjectArray count]; i++)
		{
			
			
			float val = [[positionOffsetArray objectAtIndex:i] floatValue];
			//	NSLog(@"normalized high: %f", normalizedHigh);
			//	NSLog(@"normalized value: %f", val);
			//	NSLog(@"divided: %f", (val / normalizedHigh));
			float yPos = (viewHeight / 2) -  ((val / high) * (viewHeight));
			//	NSLog(@"yPos: %f", yPos);
			//	NSLog(@" ");
			
			
			
			fromPoint = toPoint;
			toPoint = CGPointMake(i * xStep, yPos);
			if (i == 0)
			{
				lowPointOnGraph = toPoint;
				highPointOnGraph = toPoint;
			}
			if (toPoint.y > highPointOnGraph.y)
				highPointOnGraph = toPoint;
			if (toPoint.y < lowPointOnGraph.y)
				lowPointOnGraph = toPoint;
			
			if (i == 0)
				fromPoint = toPoint;
			
			
			
			CGContextMoveToPoint(context,fromPoint.x , fromPoint.y);
			CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
			
			if (i == [lineGraphDataObjectArray count] -1)
				lastPointOnGraph = toPoint;
		}
		CGContextStrokePath(context);
		
		/// -------End Draw line graph		
		
		//--------- draws y axes
		
		// left line
		fromPoint = CGPointMake(1, 0);
		toPoint = CGPointMake(fromPoint.x,self.frame.size.height);
		context = UIGraphicsGetCurrentContext();
		
		CGContextSetLineWidth(context,.25);
		CGContextSetStrokeColorWithColor(context, gridColor.CGColor);
		
		CGContextMoveToPoint(context,fromPoint.x , fromPoint.y);
		CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
		
		CGContextStrokePath(context);		
		
		// middle lines
		for (int i = 1; i < yAxes; i++)
		{
			
			// line section
			CGPoint fromPoint = CGPointMake(i * (width / yAxes), 0);
			CGPoint toPoint = CGPointMake(fromPoint.x,self.frame.size.height);
			CGContextRef	context = UIGraphicsGetCurrentContext();

			CGContextMoveToPoint(context,fromPoint.x , fromPoint.y);
			CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
			
			
			CGContextStrokePath(context);
	
		}

		// left line
		fromPoint = CGPointMake(self.frame.size.width - 1, 0);
		toPoint = CGPointMake(fromPoint.x,self.frame.size.height);
		context = UIGraphicsGetCurrentContext();
		
		CGContextMoveToPoint(context,fromPoint.x , fromPoint.y);
		CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
		
		CGContextStrokePath(context);		
		

		// Y axes labels
		for (int i = 0; i <= yAxes; i++)
		{
			
			// label section - x(0) axis labels
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i * (width / yAxes)) - (self.frame.size.width / 13.56), self.frame.size.height + self.frame.size.height / 83, self.frame.size.width / 6.78, self.frame.size.width / 48)];
			if (!doProjection && (i == yAxes))
				label.frame = CGRectMake((i * (width / yAxes)) - (self.frame.size.width / 6.78), self.frame.size.height + self.frame.size.height / 83, self.frame.size.width / 6.78, self.frame.size.width / 48);
			
			
			label.textAlignment = UITextAlignmentCenter;
			if (!doProjection && (i == yAxes))
				label.textAlignment = UITextAlignmentRight;
			label.backgroundColor = [UIColor clearColor];
			label.textColor = yLabelColor;
			
			
			int d = (int)(([lineGraphDataObjectArray count] - 1) * i) / yAxes;
			
			label.text =  ((LineGraphDataObject *)[lineGraphDataObjectArray objectAtIndex:d]).xMetric;
			label.font = [UIFont systemFontOfSize:self.frame.size.width / 61];
			[self addSubview:label];			
			
		}		

	
		//---------------draw right section grid
		if (doProjection)
		{
			 context = UIGraphicsGetCurrentContext();
			 
			CGContextSetLineWidth(context,.25);
			CGContextSetStrokeColorWithColor(context, gridColor.CGColor);
			
			// top
			pointA = CGPointMake(width * 550/500, 1);
			pointB = CGPointMake(maxWidth, pointA.y);
			CGContextMoveToPoint(context,pointA.x , pointA.y);
			CGContextAddLineToPoint(context, pointB.x, pointB.y);
			CGContextStrokePath(context);			
			// middle 
			for (int i = 1; i < xAxes; i++)
			{
				 pointA = CGPointMake(width * 550/500, xAxesStepDistance *i);
				 pointB = CGPointMake(maxWidth, pointA.y);
				 CGContextMoveToPoint(context,pointA.x , pointA.y);
				 CGContextAddLineToPoint(context, pointB.x, pointB.y);
				 CGContextStrokePath(context);
			}
			// bottom
			pointA = CGPointMake(width * 550/500, self.frame.size.height - 0.5);
			pointB = CGPointMake(maxWidth, pointA.y);
			CGContextMoveToPoint(context,pointA.x , pointA.y);
			CGContextAddLineToPoint(context, pointB.x, pointB.y);
			CGContextStrokePath(context);			
			
		}
		
		
		// Draw a high/low/last circles 	
		// low
		context = UIGraphicsGetCurrentContext();
		 
		CGContextSetFillColorWithColor(context, lowCircleColor.CGColor);
		CGContextFillEllipseInRect(context, CGRectMake(highPointOnGraph.x-10, highPointOnGraph.y-10, 20, 20));

		// high
		CGContextSetFillColorWithColor(context, highCircleColor.CGColor);
		CGContextFillEllipseInRect(context, CGRectMake(lowPointOnGraph.x-10, lowPointOnGraph.y-10, 20, 20));

		// last
		context = UIGraphicsGetCurrentContext();

		CGContextSetFillColorWithColor(context, lastCircleColor.CGColor);
		CGContextSetRGBStrokeColor(context, 0, 0, 255, 0.5);
		CGContextFillEllipseInRect(context, CGRectMake(lastPointOnGraph.x-10, lastPointOnGraph.y-10, 20, 20));
		
		
		// labels x axis with line graph range 
		context = UIGraphicsGetCurrentContext();
		
		if ([lineGraphDataObjectArray count] > 0)
		{
			// Puts in the top number
			
			float graphYCoordinateDifference = highPointOnGraph.y - lowPointOnGraph.y;			
			float lowHighActualDifference = high - low;			
			float positionRatio = lowHighActualDifference  /  graphYCoordinateDifference;
			
			float topXAxisValue = lowPointOnGraph.y * positionRatio + high;
						
			
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-self.frame.origin.x, 0, self.frame.origin.x, self.frame.size.height / 18)];
			label.textAlignment = UITextAlignmentCenter;
			label.backgroundColor = [UIColor clearColor];
			label.textColor = xLabelColor;
			
			label.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:topXAxisValue]];
			label.font = [UIFont systemFontOfSize:(self.frame.size.width / 61)];
			[self addSubview:label];
			[xAxisLabelsArray addObject:label];
			
			
			// Puts in the rest of the numbers
			
			for (int i = 1; i < xAxes; i++)
			{
				
				float axisValue = topXAxisValue - ((xAxesStepDistance * i) * positionRatio);
				
				label = [[UILabel alloc] initWithFrame:CGRectMake(-self.frame.origin.x, xAxesStepDistance * i-xAxes, self.frame.origin.x, 14)];
				
				label.textAlignment = UITextAlignmentCenter;
				label.backgroundColor = [UIColor clearColor];
				label.textColor = xLabelColor;
				label.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:axisValue]];
				label.font = [UIFont systemFontOfSize:(self.frame.size.width / 61)];
				[self addSubview:label];
				[xAxisLabelsArray addObject:label];
				
			}
		

			// future projections (right section)
 
			if (doProjection)
			{
				// high line
				CGContextSetRGBFillColor(context, 255, 255, 255, 0.3);
				CGMutablePathRef path = CGPathCreateMutable();
				CGPathMoveToPoint(path, NULL, lastPointOnGraph.x, lastPointOnGraph.y);
				
				
				CGContextSetLineWidth(context,1);
				CGContextSetStrokeColorWithColor(context, projectionStrokeColor.CGColor);
				
				pointA = CGPointMake(lastPointOnGraph.x, lastPointOnGraph.y);
				pointB = CGPointMake(maxWidth, lastPointOnGraph.y - (viewHeight*.2));
				CGContextMoveToPoint(context,pointA.x , pointA.y);
				CGContextAddLineToPoint(context, pointB.x, pointB.y);
				CGContextStrokePath(context);
				
				float axisValue = topXAxisValue - (pointB.y * positionRatio);
				label = [[UILabel alloc] initWithFrame:CGRectMake(maxWidth-85, pointB.y-7, 75, 14)];
				label.textAlignment = UITextAlignmentRight;
				label.backgroundColor = [UIColor clearColor];
				label.textColor = [UIColor clearColor]; //[Utils getUpColor];
				
				label.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:axisValue]];
				label.font = [UIFont systemFontOfSize:11];
				[self addSubview:label];
				[xAxisLabelsArray addObject:label];
				
				axisValue = topXAxisValue - (pointB.y * positionRatio) - (viewHeight * .08);
				label = [[UILabel alloc] initWithFrame:CGRectMake(maxWidth-85, pointB.y-7 + (viewHeight * .08), 75, 14)];
				label.textAlignment = UITextAlignmentRight;
				label.backgroundColor = [UIColor clearColor];
				label.textColor = projectionHighLabel;
				
				label.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:axisValue]];
				label.font = [UIFont systemFontOfSize:11];
				[self addSubview:label];
				[xAxisLabelsArray addObject:label];
			
				CGPathAddLineToPoint(path, NULL, pointB.x, pointB.y);
								
				// low line
				pointA = CGPointMake(lastPointOnGraph.x, lastPointOnGraph.y);
				pointB = CGPointMake(maxWidth, lastPointOnGraph.y + (viewHeight*.2));
				CGContextMoveToPoint(context,pointA.x , pointA.y);
				CGContextAddLineToPoint(context, pointB.x, pointB.y);
				CGContextStrokePath(context);
				
				axisValue = topXAxisValue - (pointB.y * positionRatio);
				label = [[UILabel alloc] initWithFrame:CGRectMake(maxWidth-85, pointB.y-7, 75, 14)];
				label.textAlignment = UITextAlignmentRight;
				label.backgroundColor = [UIColor clearColor];
				label.textColor = projectionLowLabel;
				
				label.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:axisValue]];
				label.font = [UIFont systemFontOfSize:11];
				[self addSubview:label];
				[xAxisLabelsArray addObject:label];
				
				// shades the area between high and low lines
				
				CGPathAddLineToPoint(path, NULL, pointB.x, pointB.y);
				CGPathAddLineToPoint(path, NULL, lastPointOnGraph.x, lastPointOnGraph.y);
				
				//		CGContextClosePath(context);
				CGContextSetFillColorWithColor(context, projectionFillColor.CGColor);
				CGContextAddPath(context, path);
				CGContextFillPath(context);
			}
		}
	}
	@catch (NSException *e) {
		NSLog(@"%@.drawRect: %@", [self class], e);	
	}
	
	
}
-(void)updateLabel:(UITouch *)touch
{	
	int index = [[NSNumber numberWithFloat:([touch locationInView:self].x / xStep)] intValue];
	if ((index >= 0) && (index < [lineGraphDataObjectArray count]))
	{
		
		LineGraphDataObject *gdo = [lineGraphDataObjectArray objectAtIndex:index];
		
		[self bringSubviewToFront:graphBackgroundView];
		
		graphBackgroundView.yLabel.text = gdo.yMetric;
		graphBackgroundView.xLabel.text = gdo.xMetric;
	}
	
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self updateLabel:touch];
	
	graphBackgroundView.xCoord = [touch locationInView:self].x;
	[graphBackgroundView setNeedsDisplay];
	return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self updateLabel:touch];
	graphBackgroundView.xCoord = [touch locationInView:self].x;	
	[graphBackgroundView setNeedsDisplay];	
	return [super continueTrackingWithTouch:touch withEvent:event];
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self updateLabel:touch];	
	graphBackgroundView.yLabel.text = @"";
	graphBackgroundView.xLabel.text = @"";
	graphBackgroundView.xCoord = -10;	
	[graphBackgroundView setNeedsDisplay];
	[super endTrackingWithTouch:touch withEvent:event];	
}


- (void)dealloc {
    [super dealloc];
	[xLabelColor release]; 
	[yLabelColor release]; 
	[gridColor release];  
	[lineColor release]; 
	[graphTrackColor release];
	[projectionStrokeColor release];
	[projectionFillColor release];
	[projectionHighLabel release];
	[projectionLowLabel release];	
	[highCircleColor release];
	[lowCircleColor release];
	[lastCircleColor	release];
	
	[lineGraphDataObjectArray release];	
	[graphBackgroundView release];	
	[xAxisLabelsArray release];
}


@end
