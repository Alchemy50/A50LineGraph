//
//  GraphViewController.h
//  A50LineGraph
//
//  Created by jay canty on 10/13/11.
//  Copyright 2011 A 50. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataRecieverProtocol.h"
#import "GraphView.h"
#import "LineGraph.h"


@interface GraphViewController  : UIViewController <DataRecieverProtocol> {
		
	LineGraph *lineGraph;

}

@property (nonatomic, retain) GraphView *graphView;
@property (nonatomic, retain) LineGraph *lineGraph;

@end
