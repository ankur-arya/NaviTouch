//
//  AADisplayNameVC.m
//  NaviTouch
//
//  Created by Ankur Arya on 13/03/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import "AADisplayNameVC.h"

@interface AADisplayNameVC ()

@end

@implementation AADisplayNameVC

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
}

-(IBAction)submitName:(id)sender
{
    
    NSString *submitNameUrlStr = [NSString stringWithFormat:@"http://suncookingus.com/webs/api.php?rquest=updateName&uid=%@&name=%@",_userIDStr, _displayName.text];
    
    NSURLRequest *displayNameRqst = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:submitNameUrlStr]];
    [NSURLConnection connectionWithRequest:displayNameRqst delegate:self];
}

#pragma mark URL Connection


-(void) connection: (NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    _returnData = [[NSMutableData alloc]init];
    
    
}

-(void) connection: (NSURLConnection *) connection didReceiveData:(NSData *)data
{
    [_returnData appendData:data];
    
}

-(void) connectionDidFinishLoading: (NSURLConnection *) connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    _returnArray  = [NSJSONSerialization JSONObjectWithData:_returnData options:kNilOptions error:nil];

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
