//
//  LineGraphDataObject.h
//  A50LineGraph
//
//  Created by jay canty on 10/17/11.
//  Copyright 2011 A 50. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LineGraphDataObject : NSObject {
	
	NSString *xMetric;
	NSString *yMetric;

}

-(id) initWithLine:(NSString *)line;

@property (nonatomic, retain) NSString *xMetric;
@property (nonatomic, retain) NSString *yMetric;

@end
