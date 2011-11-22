//
//  LineGraph.m
//  A50LineGraph
//
//  Created by jay canty on 10/13/11.
//  Copyright 2011 A 50. All rights reserved.
//

#import "LineGraph.h"


@implementation LineGraph

@synthesize graphView, graphBackgroundView;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		CGRect frame = CGRectMake(self.frame.size.width * 40/718, 0, self.frame.size.width * 678/718, self.frame.size.height * 250/270);
		
		//CGRect frame = CGRectMake(40 ,0, 678, 250);
		
		graphBackgroundView = [[GraphBackgroundView alloc] initWithFrame:frame];
		graphBackgroundView.backgroundColor = [UIColor blackColor];
		
		[self addSubview:graphBackgroundView];
		
		graphView = [GraphView buttonWithType:UIButtonTypeCustom];
		graphView.graphBackgroundView = graphBackgroundView;
		graphView.frame = frame;
		//	graphView.googleDataObjectArray = dataObjectsArray;
		graphView.backgroundColor = [UIColor clearColor];  // if you want to change the graph bg color change graph background view bg color
		graphView.alpha = 0;
		[self addSubview:graphView];		
		
    }
    return self;
}

-(void) updateGraph:(NSMutableArray*)ar {
	
	graphView.lineGraphDataObjectArray = ar;
	[graphView setNeedsDisplay];
	[graphView setNeedsLayout];
	graphView.alpha = 1;
	
}



- (void)dealloc {
    [super dealloc];
	[graphBackgroundView release];	
	[graphView release];
}

@end
