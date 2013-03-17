//
//  AAViewController.m
//  NaviTouch
//
//  Created by Ankur Arya on 11/03/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import "AAViewController.h"

@interface AAViewController ()

@end

@implementation AAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self syncAllContactsToServer];
    }
    if (newUserState == 1) {
        AADisplayNameVC *displayNameVC = [[AADisplayNameVC alloc]init];
        displayNameVC.userIDStr = _uidStr;//[[returnDict objectForKey:@"result"]objectForKey:@"id"];
        [self.navigationController pushViewController:displayNameVC animated:YES];
    }
    else
    {
        AAContactsVC *contactsVC = [[AAContactsVC alloc]init];
        [self.navigationController pushViewController:contactsVC animated:YES];
    }

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
    NSString *returnStr = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];
    NSLog(@"Return Str = %@",returnStr);
    

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

    [allcontactsArray addObject:pureHomeNumbers];
    [allcontactsArray addObject:pureIphoneNumber];
    [allcontactsArray addObject:pureMobileNumber];
    
    
}
    [allcontactsArray removeObject:@""];
}
@end
