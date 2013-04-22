//
//  Annotation.m
//  MapView
//
//  Created by Ankur Arya on  03/10/12.
// 
//

#import "Annotation.h"

@implementation Annotation
@synthesize coordinate,title,subtitle,adImage,adImagePathStr,userName;


//- (void) loadImage:(NSArray *) urlString {
//    
//    
//    DLog(@"%@",[NSString stringWithFormat:@"%@/%@",[self getFilePath],[urlString objectAtIndex:1]]);
//    
//    NSData *imageData = nil;
//    
//    if ([urlString objectAtIndex:0]) {
//        
//        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[self getFilePath],[urlString objectAtIndex:1]]]) {
//            imageData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[self getFilePath],[urlString objectAtIndex:1]]];
//        }
//        else {
//            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[urlString objectAtIndex:0]]];
//            
//            if (imageData) {
//                [imageData writeToFile:[NSString stringWithFormat:@"%@/%@",[self getFilePath],[urlString objectAtIndex:1]] atomically:YES];
//            }
//        }
//        
//        UIImage *tempImage = [UIImage imageWithData:imageData];
//        if (tempImage) {
//            [[self adImageView] performSelectorOnMainThread:@selector(setImage:) withObject:tempImage waitUntilDone:NO];
//        }
//    }
//}
//
//- (NSString *) getFilePath {
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"/IMAGES/"];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL isDir = YES;
//    BOOL isDirExists = [fileManager fileExistsAtPath:myPathDocs isDirectory:&isDir];
//    if (!isDirExists) [fileManager createDirectoryAtPath:myPathDocs withIntermediateDirectories:YES attributes:nil error:nil];
//    
//    return myPathDocs;
//}

@end
