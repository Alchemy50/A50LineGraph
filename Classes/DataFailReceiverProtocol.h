//
//  DataFailReceiverProtocol.h
//  WalmartHoliday
//
//  Created by Josh Klobe on 10/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DataFailReceiverProtocol


-(void)requestDidFailWithData:(NSData *)data withServerRequestObject:(ServerRequestObject *)theServerRequestObject;

@end
