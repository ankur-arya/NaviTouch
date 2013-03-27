//
//  AAContactsVC.h
//  NaviTouch
//
//  Created by Ankur Arya on 14/03/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AACustomCell.h"
#import "AAMapVC.h"

@interface AAContactsVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *phoneContactTable;
    IBOutlet UITableView *inCircleUserTable;
    NSArray *myRegisteredFriendsArray;
}

@property (nonatomic, retain) NSMutableArray *contactsToBeAdded;
@property (nonatomic, retain) NSMutableArray *notRegisteredContacts;
@property (nonatomic, retain) NSMutableArray *registeredUsers;
@end
