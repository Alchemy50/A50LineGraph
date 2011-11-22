//
//  GraphView.h
//  MorganResearch
//
//  Created by Josh Klobe on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphBackgroundView.h"

@interface GraphView : UIButton {

	//NSMutableArray *googleDataObjectArray;
	NSMutableArray *lineGraphDataObjectArray;
	
	
	GraphBackgroundView *graphBackgroundView;
	float xStep;
	float yStep;
	CGPoint lastPointOnGraph;
	CGPoint highPointOnGraph;
	CGPoint lowPointOnGraph;
	NSMutableArray *xAxisLabelsArray;
	BOOL *doProjection;
	
	int xAxes;
	int yAxes;	
	
	UIColor *xLabelColor;
	UIColor *yLabelColor;
	UIColor *gridColor;
	UIColor *lineColor;
	UIColor *graphTrackColor;
	UIColor *projectionStrokeColor;
	UIColor *projectionFillColor;
	UIColor *projectionHighLabel;
	UIColor *projectionLowLabel;
	UIColor *highCircleColor;
	UIColor *lowCircleColor;
	UIColor *lastCircleColor;
	
}
//@property (nonatomic, retain) NSMutableArray *googleDataObjectArray;
@property (nonatomic, retain) NSMutableArray *lineGraphDataObjectArray;
@property (nonatomic, retain) GraphBackgroundView *graphBackgroundView;
@property (nonatomic, assign) float xStep;
@property (nonatomic, assign) float yStep;
@property (nonatomic, assign) BOOL *doProjection;
@property (nonatomic, assign) CGPoint lastPointOnGraph;
@property (nonatomic, assign) CGPoint highPointOnGraph;
@property (nonatomic, assign) CGPoint lowPointOnGraph;
@property (nonatomic, retain) 	NSMutableArray *xAxisLabelsArray;

@property (nonatomic, assign) int xAxes;
@property (nonatomic, assign) int yAxes;

@property (nonatomic, retain) UIColor *xLabelColor;
@property (nonatomic, retain) UIColor *yLabelColor;
@property (nonatomic, retain) UIColor *gridColor;
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, retain) UIColor *graphTrackColor;
@property (nonatomic, retain) UIColor *projectionStrokeColor;
@property (nonatomic, retain) UIColor *projectionFillColor;
@property (nonatomic, retain) UIColor *projectionHighLabel;
@property (nonatomic, retain) UIColor *projectionLowLabel;

@property (nonatomic, retain) UIColor *highCircleColor;
@property (nonatomic, retain) UIColor *lowCircleColor;
@property (nonatomic, retain) UIColor *lastCircleColor;

@end
