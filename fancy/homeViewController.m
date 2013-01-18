//
//  HomeViewController.m
//  fancy
//
//  Created by shaoxinjiang on 1/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "HomeViewController.h"
#import "Events.h"
#import <MobileCoreServices/UTCoreTypes.h>
@interface HomeViewController ()

@end

@implementation HomeViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageViewField = (UIImageView *)[self.view viewWithTag:100];
    self.commentTextField = (UITextView *)[self.view viewWithTag:101];
    //self.commentTextField.delegate = self;
    self.commentTextField.text = @"Comments on current dish";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)save:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];

    // Create a new managed object
    NSManagedObject *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Events" inManagedObjectContext:context];
    [newEvent setValue:self.commentTextField.text forKey:@"comment"];
   

    NSLog(@"Saving %@", self.commentTextField.text);
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)choosePhoto:(id)sender{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"From" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    // Test Photo Choose Menu
    [actionSheet addButtonWithTitle:@"Camera"];
    [actionSheet addButtonWithTitle:@"Photo Library"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    
    [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons-1];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
    //[UIImagePickerController availableMediaTypesForSourceType:
    // UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController: cameraUI animated: YES completion: nil];
    return YES;
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes =
    [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    //[UIImagePickerController availableMediaTypesForSourceType:
    // UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = delegate;
    [controller presentViewController: mediaUI animated: YES completion: nil];
   // [controller presentModalViewController: mediaUI animated: YES];
    return YES;
}
#pragma mark UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
    if(buttonIndex == (NSInteger)0){
            
            // configure the new view controller explicitly here
            [self startCameraControllerFromViewController:self
                                            usingDelegate:self];
            
    }else if(buttonIndex == (NSInteger)1){
            
            [self startMediaBrowserFromViewController:self
                                        usingDelegate:self];
            
    }

}
#pragma mark UITextViewDelegate methods

- (BOOL)textViewShouldReturn:(UITextView *)textView
{
    NSLog(@"Should Return");
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textViewShouldBeginEditing:");
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing:");
    textView.backgroundColor = [UIColor greenColor];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textViewShouldEndEditing:");
    textView.backgroundColor = [UIColor whiteColor];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing:");
}
@end

// Camera Delegate
@implementation HomeViewController (CameraDelegateMethods)
// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    // The method below are not used in iOS 5 or later
    //[[picker parentViewController] dismissModalViewControllerAnimated: YES];
    //[picker release];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        // Save the new image (original or edited) to the Camera Roll
        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
        [self.imageViewField setImage:imageToSave];
        //[(UIImageView *)[self.view viewWithTag:100] setImage:imageToSave];
    }
    
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        NSString *moviePath = [[info objectForKey:
                                UIImagePickerControllerMediaURL] path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (
                                                 moviePath, nil, nil, nil);
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    // The method below are not used in iOS 5 or later
    //[[picker parentViewController] dismissModalViewControllerAnimated: YES];
    //[picker release];
}
@end

