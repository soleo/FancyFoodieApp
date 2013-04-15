//
//  XJLongTextViewController.h
//  fancy
//
//  Created by Xinjiang Shao on 4/14/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

//#import "BWLongTextViewController.h"
#import "ThirdParty/FormKit/Vendor/BWLongTextViewController/BWLongTextViewController.h"
@interface XJLongTextViewController : BWLongTextViewController

@property(nonatomic,copy) dispatch_block_t cancelBlock;
@property(nonatomic,copy) dispatch_block_t doneBlock;

- (id)initWithText:(NSString *)text
     withDoneBlock:(dispatch_block_t)doneBlock
   withCancelBlock:(dispatch_block_t)cancelBlock;
- (IBAction)dismiss:(id)sender;
- (IBAction)done:(id)sender;
@end
