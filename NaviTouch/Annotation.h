//
//  Annotation.h
//  MapView
//
//  Created by Ankur Arya  on 03/10/12.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface Annotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) UIImage *adImage;
@property (nonatomic, retain) NSString *adImagePathStr;
@property (nonatomic, retain) NSString *userName;
//- (void) loadImage:(NSArray *) urlString;

@end
