//
//  LineGraphDataObject.m
//  A50LineGraph
//
//  Created by jay canty on 10/17/11.
//  Copyright 2011 A 50. All rights reserved.
//

#import "LineGraphDataObject.h"


@implementation LineGraphDataObject

@synthesize xMetric, yMetric;


-(id) initWithLine:(NSString *)line
{
	NSArray *ar = [line componentsSeparatedByString:@","];
	
	self.xMetric = [ar objectAtIndex:0];
	self.yMetric = [ar objectAtIndex:4];
	
	return self;
}


- (void)dealloc {
    [super dealloc];
	[xMetric release]; 
	[yMetric release]; 

}

@end
