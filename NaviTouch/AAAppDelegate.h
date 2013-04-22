//
//  AAAppDelegate.h
//  NaviTouch
//
//  Created by Ankur Arya on 11/03/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAViewController;

@interface AAAppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navController;

    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AAViewController *viewController;

@end
