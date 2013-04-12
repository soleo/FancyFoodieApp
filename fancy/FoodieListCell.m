//
//  FoodieListCell.m
//  fancy
//
//  Created by shaoxinjiang on 1/20/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "FoodieListCell.h"
#import "ThirdParty/BButton/BButton.h"
#import "ThirdParty/QBPopupMenu/QBPopupMenu.h"

@interface FoodieListCell ()

@end
@implementation FoodieListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMenuInCell];
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

- (void)setupMenuInCell
{
    // popupMenu
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] init];
    
    QBPopupMenuItem *shareItem = [QBPopupMenuItem itemWithTitle:@"Share" target:self action:@selector(share:)];
    
    QBPopupMenuItem *commentItem = [QBPopupMenuItem itemWithTitle:@"Comment" target:self action:@selector(updateComment:)];
    //commentItem.enabled = NO;
   
    popupMenu.items = [NSArray arrayWithObjects:shareItem, commentItem, nil];
    
    self.popupMenu = popupMenu;
    NSLog(@"Set up Menu In cell");
    [self.menuButton addTarget:self action:@selector(showPopupMenu:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)showPopupMenu:(id)sender
{
    BButton *button = (BButton *)sender;
    NSLog(@"show Popup Menu");
    [self.popupMenu showInView:self atPoint:CGPointMake(button.center.x, button.frame.origin.y)];
}

- (IBAction)share:(id)sender
{
    NSLog(@"Share Action");
}

- (IBAction)updateComment:(id)sender
{
    NSLog(@"Update Comment Action");
}
@end
