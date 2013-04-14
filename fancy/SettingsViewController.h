//
//  SettingsViewController.h
//  fancy
//
//  Created by shaoxinjiang on 1/22/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Util/Utility.h"
@interface SettingsViewController : UITableViewController
@property (nonatomic) NSUInteger saveToAlbum;
@property (nonatomic) NSUInteger lang;
@property (nonatomic, weak) IBOutlet UISwitch *saveSwitch;
- (IBAction)switchToggled:(UISwitch *)sender;

@end
