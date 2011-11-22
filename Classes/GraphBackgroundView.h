//
//  GraphBackgroundView.h
//  MorganResearch
//
//  Created by Josh Klobe on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GraphBackgroundView : UIView {

	float xCoord;
	UILabel *yLabel;
	UILabel *xLabel;
	
	UIColor *xLabelColor;
	UIColor *yLabelColor;
	UIColor *lineColor;
}
@property (nonatomic, assign) float xCoord;
@property (nonatomic, retain) UILabel *yLabel;
@property (nonatomic, retain) UILabel *xLabel;

@property (nonatomic, retain) UIColor *xLabelColor;
@property (nonatomic, retain) UIColor *yLabelColor;
@property (nonatomic, retain) UIColor *lineColor;

@end
