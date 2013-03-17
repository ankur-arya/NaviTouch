//
//  AACustomCell.h
//  NaviTouch
//
//  Created by Ankur Arya on 16/03/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AACustomCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *nameLbl;
@property (nonatomic, retain) IBOutlet UILabel *lastSeenTimeLbl;
@property (nonatomic, retain) IBOutlet UILabel *lastUpdatedStatusLbl;
@property (nonatomic, retain) IBOutlet UIImageView *userImageView;
@property (nonatomic, retain) IBOutlet UIImageView *userStatusImageView;

@end
