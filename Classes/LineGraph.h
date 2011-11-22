//
//  LineGraph.h
//  A50LineGraph
//
//  Created by jay canty on 10/13/11.
//  Copyright 2011 A 50. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphView.h"
#import "GraphBackgroundView.h"
#import "GoogleDataObject.h"


@interface LineGraph : UIView {

	GraphView *graphView;
	GraphBackgroundView *graphBackgroundView;
	
}

-(void) updateGraph:(NSMutableArray*)gdo;

@property (nonatomic, retain) GraphView *graphView;
@property (nonatomic, retain) GraphBackgroundView *graphBackgroundView;

@end
