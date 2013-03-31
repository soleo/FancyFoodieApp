//
//  PickphotoViewController.h
//  fancy
//
//  Created by shaoxinjiang on 3/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickphotoViewController : UIViewController

- (void)setImage:(UIImage *)anImage chooseBlock:(dispatch_block_t)chooseBlock cancelBlock:(dispatch_block_t)cancelBlock;
@end