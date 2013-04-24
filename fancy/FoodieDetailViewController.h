//
//  FoodieDetailViewController.h
//  fancy
//
//  Created by shaoxinjiang on 1/22/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class aEvent;
@class MGStyledBox;
@interface FoodieDetailViewController : UIViewController

@property (nonatomic, strong) aEvent *event;

- (IBAction)doShare:(id)sender;
- (void)addLineForBox:(MGStyledBox *)box withInfo:(NSString *)info withIcon:(NSString *)icon;
- (void) sharingWithContent:(NSString *)text image:(UIImage *)foodiePhoto;
@end
