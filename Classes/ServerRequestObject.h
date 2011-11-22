//
//  ServerRequestObject.h
//
//  Created by Josh Klobe on 7/29/10.
//

#import <Foundation/Foundation.h>


@interface ServerRequestObject : NSObject {

	NSString *urlString;
	NSMutableDictionary *postDataDictionary;
	NSMutableDictionary *headerDictionary;
	BOOL cacheableObject;
	id returnNotificationKey;
	id returnDelegate;
}

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSMutableDictionary *postDataDictionary;
@property (nonatomic, retain) NSMutableDictionary *headerDictionary;
@property (nonatomic, assign) BOOL cacheableObject;
@property (nonatomic, retain) id returnNotificationKey;
@property (nonatomic, retain) id returnDelegate;
@end
