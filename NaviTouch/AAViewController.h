//
//  AAViewController.h
//  NaviTouch
//
//  Created by Ankur Arya on 11/03/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "OpenUDID.h"
#import "AADisplayNameVC.h"
#import "AAContactsVC.h"
#import "AATabController.h"
#import "AASearchViewController.h"

@interface AAViewController : UIViewController
{
    NSMutableArray *allcontactsArray;
    AATabController *tabBar;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameText;
@property (nonatomic, retain) IBOutlet UITextField *passwordText;
@property (nonatomic, retain) NSString *uidStr;
@property (nonatomic, retain) CLLocation *currentLocation;
-(IBAction)submitLoginDetails:(id)sender;

@end
