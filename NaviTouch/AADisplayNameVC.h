//
//  AADisplayNameVC.h
//  NaviTouch
//
//  Created by Ankur Arya on 13/03/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAContactsVC.h"

@interface AADisplayNameVC : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *displayName;
@property (nonatomic, retain) NSString *userIDStr;
@property (nonatomic, retain) NSArray *returnArray;
@property (nonatomic, retain) NSMutableData *returnData;
-(IBAction)submitName:(id)sender;
@end
