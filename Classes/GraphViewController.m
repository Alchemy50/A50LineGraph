    //
//  GraphViewController.m
//  A50LineGraph
//
//  Created by jay canty on 10/13/11.
//  Copyright 2011 A 50. All rights reserved.
//

#import "GraphViewController.h"
#import "ServerRequestObject.h"
#import "DataRequestor.h"
#import "GraphBackgroundView.h"
#import "GraphView.h"
#import "GoogleDataObject.h"
#import "LineGraphDataObject.h"

@implementation GraphViewController


@synthesize graphView, lineGraph;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		self.view.backgroundColor = [UIColor clearColor];
		
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
	[super viewDidLoad];

	
	ServerRequestObject *sro = [[ServerRequestObject alloc] init];
//	sro.urlString = @"http://www.google.com/finance/historical?q=NASDAQ:AAPL&output=csv";
		sro.urlString = @"http://www.google.com/finance/historical?q=NASDAQ:CAT&output=csv";
	sro.returnDelegate = self;
	[[DataRequestor alloc] initWithServerRequestObject:sro withSecondaryServerRequestObject:nil];
	
	
	CGRect frame = CGRectMake(100 ,100, 700, 300);
	
	lineGraph = [[LineGraph alloc] initWithFrame:frame];
	
	lineGraph.graphView.doProjection = YES;
	lineGraph.graphView.yAxes = 7;
	
	lineGraph.graphBackgroundView.lineColor = [[UIColor colorWithRed:80.0f/255.0f green:152.0f/255.0f blue:200.0f/255.0f alpha:1] retain];
	lineGraph.graphBackgroundView.xLabelColor = [[UIColor colorWithRed:80.0f/255.0f green:152.0f/255.0f blue:200.0f/255.0f alpha:1] retain];
	lineGraph.graphBackgroundView.yLabelColor = [[UIColor colorWithRed:80.0f/255.0f green:152.0f/255.0f blue:200.0f/255.0f alpha:1] retain];	
	
	lineGraph.backgroundColor = [UIColor lightGrayColor];
	
	[self.view addSubview:lineGraph];

}


-(void)makeRequest:(NSString *)requestID
{
	
	NSLog(@"do make request of requestID: %@", requestID);	
	ServerRequestObject *sro = [[ServerRequestObject alloc] init];
	sro.urlString = [NSString stringWithFormat:@"http://www.google.com/finance/historical?q=NASDAQ:%@&output=csv", requestID];
	sro.returnDelegate = self;
	[[DataRequestor alloc] initWithServerRequestObject:sro withSecondaryServerRequestObject:nil];
		
	
}


-(void) receiveData:(NSData *)data withServerRequestObject:(ServerRequestObject *)theServerRequestObject
{
	
	@try
	{
		NSString *returnDataString =[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		//	NSLog(@"returnDataString: %@", returnDataString);
		
		NSArray *ar = [returnDataString componentsSeparatedByString:@"\n"];
		
		NSMutableArray *dataObjectArray = [[NSMutableArray alloc] initWithCapacity:0];
		
		for (int i = [ar count]-2; i > 0; i--)
		{			
			[dataObjectArray addObject:[[LineGraphDataObject alloc] initWithLine:[ar objectAtIndex:i]]];
			
		}
		
		[lineGraph updateGraph:dataObjectArray];

		
	}
	@catch (NSException *e) {
		NSLog(@"%@.receivedata.ex: %@", [self class], e);
		
	}
	//	[graphView setNeedsDisplay];
	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	if ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
		return YES;
	else 
		return NO;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[lineGraph release];
}


@end
