//
//  AAContactsVC.m
//  NaviTouch
//
//  Created by Ankur Arya on 14/03/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import "AAContactsVC.h"

@interface AAContactsVC ()

@end

@implementation AAContactsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _contactsToBeAdded = [[NSMutableArray alloc]init];
    ABAddressBookRef addressBook = ABAddressBookCreate( );
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    
    for ( int i = 0; i < nPeople; i++ )
    {
        ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, i );
        
        NSString *firstName=(__bridge NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        NSString *lastName=(__bridge NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty);
        NSString *organization=(__bridge NSString *)ABRecordCopyValue(ref, kABPersonOrganizationProperty);
        
        ABMultiValueRef multi = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        NSString *phoneNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, 0);
        NSString *phoneTemp = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        NSString *phoneTemp2 = [phoneTemp stringByReplacingOccurrencesOfString:@") " withString:@""];
        NSString *phone = [phoneTemp2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if(!firstName) firstName=@"";
        if(!lastName) lastName=@"";
        if(!organization) organization=@"";
        if(!phoneNumber) phoneNumber=@"";
        
        
        NSDictionary *curContact=[NSDictionary dictionaryWithObjectsAndKeys:(NSString*)firstName,@"firstName",lastName,@"lastName",organization,@"organization", phone,@"phone", nil];
        [_contactsToBeAdded addObject:curContact];
        
       
    }
     //NSLog(@"_contactsToBeAdded  ==> %@",_contactsToBeAdded);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contactsToBeAdded.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AACustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"AACustomCell" owner:nil options:nil];
        
        for (UIView *view in views) {
            
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (AACustomCell*)view;
                 cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;               
                cell.nameLbl.text =[[_contactsToBeAdded objectAtIndex:indexPath.row]objectForKey:@"firstName"];
                cell.userImageView.image = [UIImage imageNamed:@"sample-user"];
                cell.userStatusImageView.hidden = YES;
                if (indexPath.row == 1) {
                    cell.userStatusImageView.hidden = NO;
                    cell.userStatusImageView.image = [UIImage imageNamed:@"online"];
                    cell.lastSeenTimeLbl.hidden =YES;
                }
                
               // NSLog(@"%@",[[_contactsToBeAdded objectAtIndex:indexPath.row]objectForKey:@"firstName"]);
            }
            
        }
    }
    
    
    return cell;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
