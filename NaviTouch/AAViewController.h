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

@interface AAViewController : UIViewController
{
    NSMutableArray *allcontactsArray;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameText;
@property (nonatomic, retain) IBOutlet UITextField *passwordText;
@property (nonatomic, retain) NSString *uidStr;
-(IBAction)submitLoginDetails:(id)sender;

@end
