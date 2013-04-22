//
//  AASearchViewController.m
//  NaviTouch
//
//  Created by Ankur Arya on 06/04/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import "AASearchViewController.h"

@interface AASearchViewController ()

@end

@implementation AASearchViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)searchSliderValueChanged:(id)sender
{
    NSLog(@"%f KM ",slider.value);
    [self searchNearbyFriends];
}

-(void)searchNearbyFriends
{
    [searchMapView removeAnnotations:searchMapView.annotations];
    NSString *urlStr = [NSString stringWithFormat:@"http://suncookingus.com/webs/api.php?rquest=searchNearBy&uid=%@&distance=%f",@"1",slider.value];
    NSURL *searchFriendUrl = [NSURL URLWithString:urlStr];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        
        NSData *returnData = [NSData dataWithContentsOfURL:searchFriendUrl];        
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];
            NSLog(@"NEAR BY FRIEND  = %@",returnDict);
            
            
            NSString *newUserState = [returnDict objectForKey:@"status"];
            if ([newUserState isEqualToString:@"Success"]) {
                
               
                NSArray *nearbyFriendArray = [returnDict objectForKey:@"result"];
                for (int i = 0; i < nearbyFriendArray.count; i++) {
                   
                NSString *userLatLongStr = [[nearbyFriendArray objectAtIndex:i]objectForKey:@"gps"];
                if (![userLatLongStr isEqualToString:@""]) {
                    
                    
                    NSArray *userLatLongArray = [userLatLongStr componentsSeparatedByString:@","];
                    
                    CLLocationCoordinate2D userCoord;
                    userCoord.latitude = [[userLatLongArray objectAtIndex:0]doubleValue];
                    userCoord.longitude = [[userLatLongArray objectAtIndex:1]doubleValue];
                    userAnnotation = [[Annotation alloc]init];
                    userAnnotation.coordinate = userCoord;
                    [searchMapView addAnnotation:userAnnotation];
                }
            }
            
            }
        });
    });
    
    
    
    
   

    
}

@end
