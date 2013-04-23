//
//  FoodieDetailViewController.h
//  fancy
//
//  Created by shaoxinjiang on 1/22/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class aEvent;
@interface FoodieDetailViewController : UIViewController

@property (nonatomic, strong) aEvent *event;

- (IBAction)doShare:(id)sender;
@end
