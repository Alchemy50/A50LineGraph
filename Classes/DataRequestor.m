//
//  DataRequestor.m
//  
//
//  Created by Josh Klobe on 7/8/10.
//  
//

#import "DataRequestor.h"
//#import "Logger.h"
//#import "Utils.h"
#import "DataRecieverProtocol.h"
#import "DataFailReceiverProtocol.h"


#define contentCacheKey @"contentCacheKey"
#define cacheInterval  (24*60*60*2)


@implementation DataRequestor


static DataRequestor *gInstance = NULL;


@synthesize receivedData, urlResponse, primaryServerRequestObject, secondaryServerRequestObject;


+ (DataRequestor *)instance
{
	if (gInstance == NULL)
		gInstance = [[DataRequestor alloc] init];
	
	return gInstance;
	
	
}
- (void) initWithServerRequestObject:(ServerRequestObject *)sro withSecondaryServerRequestObject:(ServerRequestObject *)sro2
{
	@try {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
		
		self.primaryServerRequestObject = sro;
		self.secondaryServerRequestObject = sro2;
		
		BOOL doRequest = YES;
		NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:contentCacheKey];
		if ([dict objectForKey:self.primaryServerRequestObject.urlString] != nil)
			if ([self.primaryServerRequestObject.returnDelegate conformsToProtocol:@protocol(DataRecieverProtocol)])
			{		
				NSDictionary *d = [dict objectForKey:self.primaryServerRequestObject.urlString];
				for (id key in d)
					if ([[NSDate date] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[key floatValue]]] < cacheInterval)			
					{
						doRequest = NO;
						[(id<DataRecieverProtocol>)self.primaryServerRequestObject.returnDelegate receiveData:[d objectForKey:key] withServerRequestObject:self.primaryServerRequestObject];						
						[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
					}
				
			}
		
		if (doRequest) {
			
			NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:[self getTheRequest] delegate:self];
			if (theConnection) {
				receivedData=[[NSMutableData data] retain];
			} else {
				// inform the user that the download could not be made
			}
			
		}
		
	}
	@catch (NSException * e) {
		//[Logger logError:self callingMethod:@"initWithURL" withException:e];
	}
	
	
}
-(NSMutableURLRequest *)getTheRequest
{
	
	NSMutableURLRequest *theRequest;
	
	@try {
		
		NSString *theUrlString = self.primaryServerRequestObject.urlString;
		
		if(theUrlString == nil){
			theUrlString = [[[NSString alloc] initWithString:@""] autorelease];
		}
		
		theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:theUrlString]
										   cachePolicy:NSURLRequestUseProtocolCachePolicy
									   timeoutInterval:120.0];		
		
		//[Logger logDebug:self callingMethod:@"getTheRequest" withLogString:[NSString stringWithFormat:@"requesting url: %@", theUrlString]];
		
		if ([self.primaryServerRequestObject.headerDictionary count] > 0)
		{
			for (id key in self.primaryServerRequestObject.headerDictionary)
				[theRequest addValue:[self.primaryServerRequestObject.headerDictionary objectForKey:key] forHTTPHeaderField:key];
			

		}
		
		if ([self.primaryServerRequestObject.postDataDictionary count] > 0)
		{
			
			NSString *postDataString = @"";
			
			int i = 0;
			for (id key in self.primaryServerRequestObject.postDataDictionary)
			{
				if (i != 0)
				{
					postDataString = 	[postDataString stringByAppendingString:@"&"];
				}
				postDataString = 	[postDataString stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, [self.primaryServerRequestObject.postDataDictionary objectForKey:key]]];
				i++;
			}
			
			
			//	[Logger logDebug:self callingMethod:@"getTheRequest" withLogString:[NSString stringWithFormat:@"postDataString: %@", postDataString]];
			
			NSData *myRequestData = [ NSData dataWithBytes: [ postDataString UTF8String ] length: [ postDataString length ] ];
			[theRequest setHTTPMethod:@"POST"];			
			[ theRequest setHTTPBody:myRequestData];
		}
		
		
	}
	@catch (NSException * e) {
		//[Logger logError:self callingMethod:@"getTheRequest" withException:e];
	}
	return theRequest;
	
}


-(void) connectionDidFinish:(NSHTTPURLResponse *)response
{	
	
	@try
	{
		if (primaryServerRequestObject.cacheableObject)
		{
			NSMutableDictionary *cacheDict = [NSMutableDictionary dictionaryWithCapacity:0];
			[cacheDict addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:contentCacheKey]];
			
			NSDictionary *timeDataDictionary = [NSDictionary dictionaryWithObject:[NSData dataWithData:receivedData] forKey:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]] ];
			[cacheDict setObject:timeDataDictionary forKey:primaryServerRequestObject.urlString];
			
			
			[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:cacheDict] forKey:contentCacheKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
		
	}
	@catch (NSException * e) {
		//[Logger logError:self callingMethod:@"connectionDidFinish" withException:e];
	}
	@finally
	{
		if ([self.primaryServerRequestObject.returnDelegate conformsToProtocol:@protocol(DataRecieverProtocol)])	
			[(id<DataRecieverProtocol>)self.primaryServerRequestObject.returnDelegate receiveData:receivedData withServerRequestObject:self.primaryServerRequestObject ];			
	}
	
	
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
	self.urlResponse = response;
	[receivedData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	@try
	{
		
		// release the connection, and the data object
		[connection release];
		// receivedData is declared as a method instance elsewhere
		[receivedData release];
		
		
		//[Logger logDebug:self callingMethod:@"didFailWithError" withLogString:[NSString stringWithFormat:@"Connection failed! Error - %@", error]];
		NSLog(@"serverRequestObject.urlString: %@", self.primaryServerRequestObject.urlString);
		NSLog(@"return delegate: %@", self.primaryServerRequestObject.returnDelegate);
		
		if ([self.primaryServerRequestObject.returnDelegate conformsToProtocol:@protocol(DataFailReceiverProtocol)])
			[(id<DataFailReceiverProtocol>)self.primaryServerRequestObject.returnDelegate requestDidFailWithData:receivedData withServerRequestObject:self.primaryServerRequestObject ];

		
		
		
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
		
	}
	@catch (NSException * e) {
		//[Logger logError:self callingMethod:@"connectiondidFailWithError" withException:e];
	}
	
	
}

//-(void) receiveData:(NSData *)data withServerRequestObject:(ServerRequestObject *)theServerRequestObject;


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{ 
	
	//[Logger logDebug:self callingMethod:@"connectionDidFinishLoading" withLogString:@"connectionDidFinishLoading"];
	
    // do something with the data
    // receivedData is declared as a method instance elsewhere
	[self connectionDidFinish:self.urlResponse];
    // release the connection, and the data object
    [connection release];
    [receivedData release];
}

-(void) dealloc
{
	
	[receivedData release];
	[urlResponse release];
	[super dealloc];
}
@end
