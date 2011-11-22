//
//  DataReciever.h
//
//  Created by Josh Klobe on 7/8/10.
//

#import <UIKit/UIKit.h>
#import "ServerRequestObject.h"

@protocol DataRecieverProtocol

-(void) receiveData:(NSData *)data withServerRequestObject:(ServerRequestObject *) theServerRequestObject;

@end
