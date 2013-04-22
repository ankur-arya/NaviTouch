//
//  AASearchViewController.h
//  NaviTouch
//
//  Created by Ankur Arya on 06/04/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MNEValueTrackingSlider.h"
#import "Annotation.h"

@interface AASearchViewController : UIViewController
{
    IBOutlet MNEValueTrackingSlider *slider;
    IBOutlet MKMapView *searchMapView;
    
    Annotation *userAnnotation;
}

-(IBAction)searchSliderValueChanged:(id)sender;

@end
