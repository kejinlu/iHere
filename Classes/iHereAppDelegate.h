//
//  iHereAppDelegate.h
//  iHere
//
//  Created by Luke on 7/16/11.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iHereViewController;

@interface iHereAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iHereViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iHereViewController *viewController;

@end

