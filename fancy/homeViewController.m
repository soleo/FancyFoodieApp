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
@synthesize photoLibrary;
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
    // Location setup
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    // Photo Lib
    self.photoLibrary = [[ALAssetsLibrary alloc] init];
    // UI Setup
    self.imageViewField = (UIImageView *)[self.view viewWithTag:100];
    self.commentTextField = (UITextView *)[self.view viewWithTag:101];
    self.commentTextField.delegate = self;
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
- (BOOL)saveEvent{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *newEvent =
    [NSEntityDescription insertNewObjectForEntityForName:@"Events"
                                  inManagedObjectContext:context];
    [newEvent setValue:self.commentTextField.text forKey:@"comment"];
    if (self.imageViewField.image == nil) {
        return NO;
    }
    NSData *imageData = UIImagePNGRepresentation(self.imageViewField.image);
    
    [newEvent setValue:imageData forKey:@"photo"];
    [newEvent setValue:[NSDate date] forKey:@"creationDate"];
    [newEvent setValue:self.latitude forKey:@"latitude"];
    [newEvent setValue:self.longitude forKey:@"longitude"];
    [newEvent setValue:self.locationName forKey:@"locationName"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    return YES;
}
- (IBAction)save:(id)sender {
    if (![self saveEvent]) {
        //[info show];
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Failed to save"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
    }
    
    
    NSLog(@" added a new event");
    
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
#pragma mark Activity Action methods
- (IBAction)sharing:(id)sender
{
    NSArray *activityItems =
    @[
        self.commentTextField.text,
        self.imageViewField.image
    ];
    NSArray *applicationActivities =
    @[
        [[UIActivity alloc] init]
    ];
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:applicationActivities];
    
    activityViewController.excludedActivityTypes =
    @[
        UIActivityTypeCopyToPasteboard,
        UIActivityTypeSaveToCameraRoll,
        UIActivityTypeAssignToContact,
        UIActivityTypePrint
    ];
    [self saveEvent];
    BOOL isRunningOniPhone =
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    if( isRunningOniPhone == YES){
        [self presentViewController:activityViewController
                             animated:YES
                           completion:nil];
    }
}
#pragma mark UITextViewDelegate methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textField
{
    NSLog(@"textViewShouldBeginEditing:");
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(done:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer: tapGestureRecognizer];   //hideKeyBoard when lost focus on textfield
//    [tapGestureRecognizer release];
    return YES;
}

-(void)done:(id)sender
{
    NSLog(@"done:");
    //[self.commentTextField resignFirstResponder];
    // I used UISrcollView inside of main view, That's why the following code is not working. @TODO: get the UIScrollView first and then get the subviews array
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextView class]]) {
            [view resignFirstResponder];
        }
    }
}



- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing:");
    textView.backgroundColor = [UIColor whiteColor];
    [textView setTextColor:[UIColor blackColor]];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textViewShouldEndEditing:");
    textView.backgroundColor = [UIColor blackColor];
    [textView setTextColor:[UIColor whiteColor]];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing:");
}

#pragma mark Location related functions
- (IBAction)getCurrentLocation:(id)sender{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError:%@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Failed to get the location"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"didUpdateToLocation: ");
    
    if (locations != nil && [locations count] > 0) {
        // get location
        CLLocation *currentLocation = [locations lastObject];
        self.latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
        self.longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
        NSLog(@"gotLocation: %.8f %.8f", [self.longitude doubleValue], [self.latitude doubleValue]);
        
        // stop when we have one location found
        [locationManager stopUpdatingLocation];
        
        // resolve the address
        NSLog(@"Resolve Address");
        [geocoder reverseGeocodeLocation:currentLocation
                       completionHandler:^(NSArray *placemarks, NSError *error){
                           NSLog(@"Found Placemarks:%@ error:%@", placemarks, error);
                           if( error == nil && [placemarks count] > 0){
                               placemark = [placemarks lastObject];
                               self.locationLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                                    placemark.subThoroughfare, placemark.thoroughfare,
                                                    placemark.postalCode, placemark.locality,
                                                    placemark.administrativeArea,
                                                    placemark.country];
                               self.locationName = [self.locationName stringByAppendingString:@"bar"];;
                           } else {
                               NSLog(@"%@", error.debugDescription);
                           }
                           
            
        }];
    }
    
    
}
//@end

// Camera Delegate
//@implementation HomeViewController (CameraDelegateMethods)
// For responding to the user tapping Cancel.
#pragma mark CameraDelegateMethods Methods
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
        //UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
        
        [self.imageViewField setImage:imageToSave];
        //[self.photoLibrary.s]
        [self.photoLibrary saveImage:imageToSave toAlbum:@"Fancy Food Photos" withCompletionBlock:^(NSError *error) {
            NSString *message;
            
            message = [error description];
            NSLog(@"Error: %@", message);
        }];
        
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

