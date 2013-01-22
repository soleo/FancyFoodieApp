//
//  FoodieListCell.m
//  fancy
//
//  Created by shaoxinjiang on 1/20/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "FoodieListCell.h"

@implementation FoodieListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.photoView = (UIImageView *)[self viewWithTag:100];
//        self.dateLabel = (UILabel *)[self viewWithTag:101];
//        self.locationLabel = (UILabel *)[self viewWithTag:102];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
