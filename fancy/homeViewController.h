//
//  HomeViewController.h
//  fancy
//
//  Created by shaoxinjiang on 1/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
    
enum {
    PhotoTag = 100,
    CommentFieldTag,
    EmailFieldTag,
    DOBFieldTag,
    SSNFieldTag
};

@property (weak, nonatomic) IBOutlet UITextView *commentTextField;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewField;

//- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate;
- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate;
- (IBAction)choosePhoto:(id)sender;

@end
