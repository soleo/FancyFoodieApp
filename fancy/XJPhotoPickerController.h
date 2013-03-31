//
//  XJPhotoPickerController.h
//  fancy
//
//  Created by shaoxinjiang on 3/24/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//
// Modified from https://github.com/carezone/CZPhotoPickerController/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^XJPhotoPickerCompletionBlock)(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict);

@interface XJPhotoPickerController : NSObject

/**
 Defaults to NO. Is passed to the UIImagePickerController
 */
@property(nonatomic,assign) BOOL allowsEditing;

/**
 Allow overriding of the UIPopoverController class used to host the
 UIImagePickerController. Defaults to UIPopoverController.
 */
@property(nonatomic,copy) Class popoverControllerClass;

/**
 @param completionBlock Called when a photo has been picked or cancelled (`imageInfoDict` will be nil if canceled). The `UIImagePickerController` has not been dismissed at the time of this being called.
 */
- (id)initWithPresentingViewController:(UIViewController *)aViewController withCompletionBlock:(XJPhotoPickerCompletionBlock)completionBlock;

- (void)showFromBarButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)showFromRect:(CGRect)rect;
- (void)cancel;
@end