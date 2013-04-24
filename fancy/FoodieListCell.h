//
//  FoodieListCell.h
//  fancy
//
//  Created by shaoxinjiang on 1/20/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model/Events.h"
@class BButton;
@class QBPopupMenu;
@class BWLongTextViewController;
@interface FoodieListCell : UITableViewCell<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet BButton *menuButton;
@property (nonatomic, retain) QBPopupMenu *popupMenu;
@property (strong) Events *event;

@property (nonatomic, strong) UIImage* photo;
@property (nonatomic, strong) NSString* comment;
@property (nonatomic, strong) UIViewController* viewController;
@property (nonatomic, strong) BWLongTextViewController* vc;
@property (nonatomic, strong) UINavigationController* nc;

- (IBAction) showPopupMenu:(id)sender;
- (IBAction) share:(id)sender;
- (IBAction) updateComment:(id)sender;
- (IBAction) updateRate:(id)sender;
- (void) saveRate:(NSString *)rate;
- (void) setupMenuInCell;
- (void) sharingWithContent:(NSString *)text image:(UIImage *)foodiePhoto;
- (void) setupMenuInCellWithComment:(NSString *)comment andWithPhoto:(UIImage *)photo andWithEvent:(Events*)event presentViewController:(UIViewController *)viewController;

@end
