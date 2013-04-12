//
//  PickphotoViewController.m
//  fancy
//
//  Created by shaoxinjiang on 3/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "PickphotoViewController.h"
#import "ThirdParty/BButton/BButton.h"
#import "MoreinfoTableViewController.h"
#import "aEvent.h"
#import "ThirdParty/CZPhotoPickerController/CZPhotoPickerController.h"

@interface PickphotoViewController ()

@property(nonatomic,weak) IBOutlet UIImageView *imageView;
@property(nonatomic,weak) IBOutlet BButton *nextButton;
@property(nonatomic,strong) CZPhotoPickerController *pickPhotoController;

@end

@implementation PickphotoViewController


- (CZPhotoPickerController *)photoController
{
    __weak typeof(self) weakSelf = self;
    
    return [[CZPhotoPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        if (imagePickerController.allowsEditing) {
            weakSelf.imageView.image = imageInfoDict[UIImagePickerControllerEditedImage];
        }
        else {
            weakSelf.imageView.image = imageInfoDict[UIImagePickerControllerOriginalImage];
        }
#if defined(__IPHONE_6_0) &&  __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
        if (weakSelf.modalViewController) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
#else
        if (weakSelf.modalPresentationStyle){
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
#endif
        
        weakSelf.pickPhotoController = nil;
    }];
}

- (IBAction)takePicture:(id)sender
{
    self.pickPhotoController = [self photoController];
    self.pickPhotoController.allowsEditing = YES;
    [self.pickPhotoController showFromBarButtonItem:sender];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.view.backgroundColor = [UIColor blackColor];
    self.imageView.layer.cornerRadius = 5.0;
    
    [self.nextButton setType:BButtonTypePrimary];
}

#pragma mark - Segue method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"passPhotoSegue"]) {
        
        MoreinfoTableViewController *destViewController = segue.destinationViewController;
        
        aEvent *passEvent = [aEvent new];
        passEvent.photo = (NSData *)self.imageView.image;
        destViewController.event = passEvent;
    
    }
}

@end
