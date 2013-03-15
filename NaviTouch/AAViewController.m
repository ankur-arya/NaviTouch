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
    
    NSLog(@"RETURN DATA = %@",returnDict);
    NSInteger newUserState = [[[returnDict objectForKey:@"result"]objectForKey:@"new_user"]integerValue];
    if (newUserState == 1) {
        AADisplayNameVC *displayNameVC = [[AADisplayNameVC alloc]init];
        displayNameVC.userIDStr = [[returnDict objectForKey:@"result"]objectForKey:@"id"];
        [self.navigationController pushViewController:displayNameVC animated:YES];
    }
    else
    {
        AAContactsVC *contactsVC = [[AAContactsVC alloc]init];
        [self.navigationController pushViewController:contactsVC animated:YES];
    }

}

@end
