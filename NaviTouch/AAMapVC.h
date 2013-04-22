//
//  AAMapVC.h
//  NaviTouch
//
//  Created by Ankur Arya on 17/03/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Annotation.h"
#import <MapKit/MapKit.h>

@interface AAMapVC : UIViewController
{
    Annotation *userAnnotation;
    IBOutlet MKMapView *userInfoMapView;
}
@property (nonatomic, retain) NSString *uidStr;
@property (nonatomic, retain) NSMutableData *userLatLongData;
@property (nonatomic, retain) NSDictionary *userLatLongDict;

@end
