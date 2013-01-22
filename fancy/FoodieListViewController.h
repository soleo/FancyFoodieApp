//
//  FoodieListViewController.h
//  fancy
//
//  Created by shaoxinjiang on 1/20/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodieListViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong) NSMutableArray *events;

@end
