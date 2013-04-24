//
//  PickphotoViewController.h
//  fancy
//
//  Created by shaoxinjiang on 3/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BButton;
@class CZPhotoPickerController;

@interface PickphotoViewController : UIViewController
@property(nonatomic,weak) IBOutlet UIImageView *imageView;
@property(nonatomic,weak) IBOutlet BButton *nextButton;
@property(nonatomic,strong) CZPhotoPickerController *pickPhotoController;
- (IBAction)takePicture:(id)sender;
@end