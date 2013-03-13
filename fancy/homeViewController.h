//
//  HomeViewController.h
//  fancy
//
//  Created by shaoxinjiang on 1/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Util/ALAssetsLibrary+CustomPhotoAlbum.h"
#import "ThirdParty/TITokenField/TITokenField.h"

@interface HomeViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
}
enum {
    PhotoTag = 100,
    CommentFieldTag
};
@property (strong, atomic) ALAssetsLibrary *photoLibrary;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewField;
@property (copy, atomic) NSNumber *longitude;
@property (copy, atomic) NSNumber *latitude;
@property (copy, atomic) NSString *locationName;

- (IBAction) save:(id)sender;
- (BOOL) saveEvent;
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate;
- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate;
- (IBAction) choosePhoto:(id)sender;
- (IBAction) sharing:(id)sender;
- (IBAction) getCurrentLocation:(id)sender;


@end
