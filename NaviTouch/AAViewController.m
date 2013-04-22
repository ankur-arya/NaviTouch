//
//  AAViewController.m
//  NaviTouch
//
//  Created by Ankur Arya on 11/03/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import "AAViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "DMLocationManager.h"
@interface AAViewController ()

@end

@implementation AAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    _currentLocation = [[CLLocation alloc]init];
    
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)sendLocationToServer:(NSString *)userCity
{
    userCity = [userCity stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *locationStr = [NSString stringWithFormat:@"http://suncookingus.com/webs/api.php?rquest=updateLocation&uid=%@&location=%f,%f&area=%@",_uidStr,_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude,userCity];
    NSData *returnData = [NSData dataWithContentsOfURL:[NSURL URLWithString:locationStr]];
    NSString *returnStr = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];
    NSLog(@"LOCATION TO SEND = %@",returnStr);
}

-(void)getUserCity
{
    NSLog(@"MY LAt == %f My Long = %f",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude);
    NSString *cityStr = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude];
    NSData *returnData = [NSData dataWithContentsOfURL:[NSURL URLWithString:cityStr]];
    NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];
    NSString *userCity = [[[returnDict objectForKey:@"results"]objectAtIndex:0]objectForKey:@"formatted_address"];
    
    [self sendLocationToServer:userCity];
    
    
}

-(void)askForPermission
{
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            //[self _addContactToAddressBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self syncAllContactsToServer];
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app.
    }
}


-(IBAction)submitLoginDetails:(id)sender
{
    //HTTP POST
    NSString* openUDID = [OpenUDID value];
    
    NSString *username = self.usernameText.text;
    NSString *password = self.passwordText.text;
    
    NSString *urlString = @"http://suncookingus.com/webs/api.php?rquest=login";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // Text parameter1
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"phone\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:username] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    // Text parameter2
    // NSString *param3 = @"Parameter 3 text";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:password] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // Text parameter3
    // NSString *param3 = @"Parameter 3 text";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uuid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:openUDID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:nil];
    
    // NSLog(@"RETURN DATA = %@",returnDict);
    
    _uidStr = [[returnDict objectForKey:@"result"]objectForKey:@"id"];
    NSInteger newUserState = [[[returnDict objectForKey:@"result"]objectForKey:@"new_user"]integerValue];
    NSString *loginStatus = [returnDict objectForKey:@"status"];
    if ([loginStatus isEqualToString:@"Success"]) {
        [self askForPermission];    }
    if (newUserState == 1) {
        AADisplayNameVC *displayNameVC = [[AADisplayNameVC alloc]init];
        displayNameVC.userIDStr = _uidStr;//[[returnDict objectForKey:@"result"]objectForKey:@"id"];
        [self.navigationController pushViewController:displayNameVC animated:YES];
    }
    else
    {
        AASearchViewController *contactsVC = [[AASearchViewController alloc]init];
        [self.navigationController pushViewController:contactsVC animated:YES];
    }
    
    [self getUserCurrentLocation];
}


-(void)getUserCurrentLocation
{
    [[DMLocationManager shared] obtainCurrentLocationAndReverse:NO
                                                   withAccuracy:kCLLocationAccuracyHundredMeters
                                                       useCache:NO
                                                   completition:^(CLLocation *location, CLPlacemark *placemark, NSError *error) {
                                                       if (error != nil)
                                                           NSLog(@"Current location error: %@",error);
                                                       else
                                                           NSLog(@"Current location result: %@",(location != nil ? location : error));
                                                       
                                                       _currentLocation = location;
                                                       [self getUserCity];
                                                       
                                                   }];
}

-(void)syncAllContactsToServer
{   allcontactsArray = [[NSMutableArray alloc]init];
    
    [self getAllContactsFromAddressBook];
    NSString * phoneNumbersStr = [[allcontactsArray valueForKey:@"description"] componentsJoinedByString:@","];
    NSLog(@"Final Array of Contacts = %@",phoneNumbersStr);
    
    
    //**************** POST Request *******************//
    
    NSString *urlString = @"http://suncookingus.com/webs/api.php?rquest=syncContacts";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // String of Phone Numbers
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"contacts\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:phoneNumbersStr] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // UID String
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:_uidStr] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];
    
    NSLog(@"Return Str = %@",returnDict);
    NSArray *registeredUsersArray = [[returnDict objectForKey:@"result"]objectForKey:@"my_list"];
    [self saveObject:registeredUsersArray key:@"registeredUsersArray"];
    
}

-(void)getAllContactsFromAddressBook{
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
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
        [allcontactsArray addObject:pureHomeNumbers];
        [allcontactsArray addObject:pureIphoneNumber];
        [allcontactsArray addObject:pureMobileNumber];

    }
    [allcontactsArray removeObject:@""];
}

-(void)saveObject:(id)obj key:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    
    
    [defaults setObject:myEncodedObject forKey:key];
    
}
@end
