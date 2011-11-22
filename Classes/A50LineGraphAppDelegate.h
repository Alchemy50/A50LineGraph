//
//  A50LineGraphAppDelegate.h
//  A50LineGraph
//
//  Created by jay canty on 10/13/11.
//  Copyright 2011 A 50. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphViewController.h"

@interface A50LineGraphAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	GraphViewController *graphViewController;
	
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GraphViewController *graphViewController;

@end

