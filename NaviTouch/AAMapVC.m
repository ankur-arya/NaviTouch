//
//  AAMapVC.m
//  NaviTouch
//
//  Created by Ankur Arya on 17/03/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import "AAMapVC.h"

@interface AAMapVC ()

@end

@implementation AAMapVC

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
    [self getUserLatLongFromServer];
    // Do any additional setup after loading the view from its nib.
}

-(void)getUserLatLongFromServer
{
    NSString *getLatLongStr =[ NSString stringWithFormat:@"http://suncookingus.com/webs/api.php?rquest=getUserLocation&uid=%@",_uidStr];
    NSURL *latLongUrl = [NSURL URLWithString:getLatLongStr];
    NSURLRequest *latLongRequest = [NSURLRequest requestWithURL:latLongUrl];
    
    [NSURLConnection connectionWithRequest:latLongRequest delegate:self];
    
}

#pragma mark URL Connection


-(void) connection: (NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    _userLatLongData = [[NSMutableData alloc]init];
    
    
}

-(void) connection: (NSURLConnection *) connection didReceiveData:(NSData *)data
{
    [_userLatLongData appendData:data];
    
}

-(void) connectionDidFinishLoading: (NSURLConnection *) connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    _userLatLongDict  = [NSJSONSerialization JSONObjectWithData:_userLatLongData options:kNilOptions error:nil];
   
    NSString *newUserState = [_userLatLongDict objectForKey:@"status"];
    if ([newUserState isEqualToString:@"Success"]) {
        
        NSString *userLatLongStr = [[_userLatLongDict objectForKey:@"result"]objectForKey:@"gps"];
        
        if (![userLatLongStr isEqualToString:@""]) {
            
        
        NSArray *userLatLongArray = [userLatLongStr componentsSeparatedByString:@","];
        
        CLLocationCoordinate2D userCoord;
        userCoord.latitude = [[userLatLongArray objectAtIndex:0]doubleValue];
        userCoord.longitude = [[userLatLongArray objectAtIndex:1]doubleValue];
            userAnnotation = [[Annotation alloc]init];
            userAnnotation.coordinate = userCoord;
            [userInfoMapView addAnnotation:userAnnotation];
        }
    }
    else
    {
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
