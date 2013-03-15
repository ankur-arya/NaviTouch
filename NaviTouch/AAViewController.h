//
//  AAViewController.h
//  NaviTouch
//
//  Created by Ankur Arya on 11/03/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenUDID.h"
#import "AADisplayNameVC.h"
#import "AAContactsVC.h"

@interface AAViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *usernameText;
@property (nonatomic, retain) IBOutlet UITextField *passwordText;

-(IBAction)submitLoginDetails:(id)sender;

@end
