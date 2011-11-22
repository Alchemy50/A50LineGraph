//
//  DataRequestor.h
//  
//
//  Created by Josh Klobe on 7/8/10.
//

#import <Foundation/Foundation.h>
#import "ServerRequestObject.h"


@interface DataRequestor : NSObject {
	NSMutableData *receivedData;
	NSHTTPURLResponse *urlResponse;
	ServerRequestObject *primaryServerRequestObject;
	ServerRequestObject *secondaryServerRequestObject;
}

- (void) initWithServerRequestObject:(ServerRequestObject *)sro withSecondaryServerRequestObject:(ServerRequestObject *)sro2;

+(DataRequestor *)instance;

-(NSMutableURLRequest *)getTheRequest;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSHTTPURLResponse *urlResponse;
@property (nonatomic, retain) ServerRequestObject *primaryServerRequestObject;
@property (nonatomic, retain) ServerRequestObject *secondaryServerRequestObject;

@end
