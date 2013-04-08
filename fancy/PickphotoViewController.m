//
//  PickphotoViewController.m
//  fancy
//
//  Created by shaoxinjiang on 3/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "PickphotoViewController.h"
#import "XJPhotoPickerController.h"
#import "ThirdParty/BButton/BButton.h"
#import "MoreinfoTableViewController.h"
#import "aEvent.h"

@interface PickphotoViewController ()
@property(nonatomic,copy) dispatch_block_t cancelBlock;
@property(nonatomic,copy) dispatch_block_t chooseBlock;
@property(nonatomic,weak) IBOutlet UIImageView *imageView;
@property(nonatomic,weak) IBOutlet BButton *nextButton;
@property(nonatomic,strong) XJPhotoPickerController *pickPhotoController;
@end

@implementation PickphotoViewController

#pragma mark - Methods

- (XJPhotoPickerController *)photoController
{
    __weak typeof(self) weakSelf = self;
    
    return [[XJPhotoPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        if (imagePickerController.allowsEditing) {
            weakSelf.imageView.image = imageInfoDict[UIImagePickerControllerEditedImage];
        }
        else {
            weakSelf.imageView.image = imageInfoDict[UIImagePickerControllerOriginalImage];
        }
        
        if (weakSelf.modalViewController) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
        
        weakSelf.pickPhotoController = nil;
    }];
}

- (IBAction)takePicture:(id)sender
{
    self.pickPhotoController = [self photoController];
    self.pickPhotoController.allowsEditing = YES;
    [self.pickPhotoController showFromBarButtonItem:sender];
}

- (void)setImage:(UIImage *)anImage chooseBlock:(dispatch_block_t)chooseBlock cancelBlock:(dispatch_block_t)cancelBlock
{
    NSParameterAssert(chooseBlock);
    NSParameterAssert(cancelBlock);
    
    //self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.cancelBlock = cancelBlock;
        self.chooseBlock = chooseBlock;
        self.imageView.image = anImage;
        self.title = NSLocalizedString(@"Choose Photo", nil);
    }
    
    //return self;
}
- (IBAction)didCancel:(id)sender
{
    self.cancelBlock();
}
- (IBAction)didChoose:(id)sender
{
    self.chooseBlock();
}


//- (IBAction)goBack:(id)sender
//{
//    //[self dismissViewControllerAnimated:YES completion:nil];
//    [self.pickPhotoController cancel];
//}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.clipsToBounds = YES;
    //self.nextButton.currentTitle
    [self.nextButton setType:BButtonTypePrimary];
    //self.imageView.layer.borderWidth = 1.0;
    //self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    
    //self.imageView.layer.cornerRadius = 5.0;
}
#pragma mark - Segue method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"passPhotoSegue"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MoreinfoTableViewController *destViewController = segue.destinationViewController;
        //NSManagedObject *event = [self.events objectAtIndex:indexPath.row];
        aEvent *passEvent = [aEvent new];
//        passEvent.locationName = [event valueForKey:@"locationName"];
        passEvent.photo = (NSData *)self.imageView.image;
//        passEvent.creationDate = [event valueForKey:@"creationDate"];
//        passEvent.comment = [event valueForKey:@"comment"];
        destViewController.event = passEvent;
        //        destViewController.event.locationName = [event valueForKey:@"locationName"];
        //        destViewController.event.photo = [event valueForKey:@"photo"];
        //        destViewController.event.creationDate = [event valueForKey:@"creationDate"];
        //        destViewController.event.comment = [event valueForKey:@"comment"];
        //        NSLog(@"prepareForSegue: %@",  destViewController.event);
    }
}

@end
