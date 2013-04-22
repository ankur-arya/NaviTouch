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
    _registeredUsers = [[NSMutableArray alloc]init];
    _notRegisteredContacts = [[NSMutableArray alloc]init];
    myRegisteredFriendsArray = [self loadCustomObjectWithKey:@"registeredUsersArray"];
    NSLog(@"myRegisteredFriendsArray  ===> %@",myRegisteredFriendsArray);
    // Do any additional setup after loading the view from its nib.
    _contactsToBeAdded = [[NSMutableArray alloc]init];
    [self getAllContactsFromAddressBook];
}

-(void)getAllContactsFromAddressBook{
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
        NSString *mobileNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, 0);
        NSString *iPhoneNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, 1);
        NSString *homeNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, 2);
        
        NSString *pureIphoneNumber = [[iPhoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSString *pureMobileNumber = [[mobileNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSString *pureHomeNumbers = [[homeNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
        if(!firstName) firstName=@"";
        if(!lastName) lastName=@"";
        if(!organization) organization=@"";
        if(!pureHomeNumbers) pureHomeNumbers=@"";
        if(!pureIphoneNumber) pureIphoneNumber=@"";
        if(!pureMobileNumber) pureMobileNumber=@"";
        
        NSMutableDictionary *curContact=[NSMutableDictionary dictionaryWithObjectsAndKeys:(NSString*)firstName,pureMobileNumber,firstName,pureIphoneNumber,firstName,pureHomeNumbers, nil];
       // NSString *contactStr = [NSString stringWithFormat:@"%@ = %@",firstName, pureMobileNumber];
        [curContact removeObjectForKey:@""];
        [_contactsToBeAdded addObject:curContact];
        
 
    }
    NSLog(@"_contactsToBeAdded  ==>> %@",_contactsToBeAdded);
    [self extractRegisterFriendsFromAddressBook];
}

-(void)extractRegisterFriendsFromAddressBook
{
    for (int i = 0; i < myRegisteredFriendsArray.count; i++) {
        NSString *phoneNumberKeyStr = [[myRegisteredFriendsArray objectAtIndex:i]objectForKey:@"phone"];
        NSString *moodStr = [[myRegisteredFriendsArray objectAtIndex:i]objectForKey:@"mood"];
        NSString *uidStr = [[myRegisteredFriendsArray objectAtIndex:i]objectForKey:@"uid"];
        NSString *activeTime = [[myRegisteredFriendsArray objectAtIndex:i]objectForKey:@"activetime"];
        for (int j = 0; j<_contactsToBeAdded.count; j++) {
            NSString *registeredNameForKey = [[_contactsToBeAdded objectAtIndex:j]objectForKey:phoneNumberKeyStr];
            
            
                       if (registeredNameForKey) {
                           NSLog(@"registeredNameForKey  ---- > %@ = %@",phoneNumberKeyStr,registeredNameForKey);
                           NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumberKeyStr,@"phone",registeredNameForKey,@"name",moodStr,@"mood",uidStr,@"uid",activeTime,@"activetime", nil];
                           [_registeredUsers addObject:tempDict];
                           [[_contactsToBeAdded objectAtIndex:i]removeObjectForKey:phoneNumberKeyStr];
                           
                break;
            }
            
        }
    }
        NSLog(@"Registered CONTACTS = %@",_registeredUsers);
    
    
    
    _notRegisteredContacts = _contactsToBeAdded;
    
    NSLog(@"Not Registered CONTACTS = %@",[[_notRegisteredContacts objectAtIndex:0]allKeys]);
}

-(id)loadCustomObjectWithKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey: key];
    id temp = (id)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return temp;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == inCircleUserTable) {
       return [self.registeredUsers count];
    }
    else
    {
        return _notRegisteredContacts.count;
    }
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
                if (tableView ==inCircleUserTable) {
                    cell.nameLbl.text =[[_registeredUsers objectAtIndex:indexPath.row]objectForKey:@"name"];
                    cell.userImageView.image = [UIImage imageNamed:@"sample-user"];
                    cell.userStatusImageView.hidden = YES;
                    if (indexPath.row == 1) {
                        cell.userStatusImageView.hidden = NO;
                        cell.userStatusImageView.image = [UIImage imageNamed:@"online"];
                        cell.lastSeenTimeLbl.hidden =YES;
                    }
                }
               
                
               // NSLog(@"%@",[[_contactsToBeAdded objectAtIndex:indexPath.row]objectForKey:@"firstName"]);
            }
            
        }
    }
    
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AAMapVC *mapView = [[AAMapVC alloc]init];
    mapView.uidStr = [[_registeredUsers objectAtIndex:indexPath.row]objectForKey:@"uid"];
    [self.navigationController pushViewController:mapView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
