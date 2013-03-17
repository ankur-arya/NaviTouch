//
//  AACustomCell.m
//  NaviTouch
//
//  Created by Ankur Arya on 16/03/13.
//  Copyright (c) 2013 Arya Corp. All rights reserved.
//

#import "AACustomCell.h"

@implementation AACustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
