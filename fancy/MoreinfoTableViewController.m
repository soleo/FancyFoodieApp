//
//  MoreinfoTableViewController.m
//  fancy
//
//  Created by shaoxinjiang on 3/30/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "MoreinfoTableViewController.h"
#import "ThirdParty/FormKit/FormKit.h"
#import "ThirdParty/PrettyKit/PrettyKit.h"
#import "ThirdParty/SVProgressHUD/SVProgressHUD.h"
#import "aEvent.h"
#import "NearbyVenuesController.h"
#import "FSConverter.h"
#import "Util/UIImage+Resize.h"
#import "Model/Events.h"

@interface MoreinfoTableViewController ()
- (void) sharingWithContent:(NSString *)text image:(UIImage *)foodiePhoto;
- (void) customizeNavBar;
- (void) getCurrentLocation;
- (NSManagedObjectContext *)managedObjectContext;
@end

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

@implementation MoreinfoTableViewController

@synthesize formModel;
@synthesize event = _event;

static float progress = 0.0f;
- (void)increaseProgress {
    progress+=0.1f;
    [SVProgressHUD showProgress:progress status:@"Loading"];
    
    if(progress < 1.0f)
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3];
    else
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.4f];
}
- (void)dismiss {
	[SVProgressHUD dismiss];
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

#pragma mark Activity Action methods
- (void) sharingWithContent:(NSString *)text image:(UIImage *)foodiePhoto
{
    NSArray *activityItems =
    @[
      text,
      foodiePhoto
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
   
    BOOL isRunningOniPhone =
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    if( isRunningOniPhone == YES){
        [self presentViewController:activityViewController
                           animated:YES
                         completion:nil];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (IBAction)saveEvent:(id)sender{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *newEvent =
    [NSEntityDescription insertNewObjectForEntityForName:@"Events"
                                  inManagedObjectContext:context];
    [newEvent setValue:self.event.comment forKey:@"comment"];
    
    NSData *imageData = UIImagePNGRepresentation((UIImage *)self.event.photo);
    NSManagedObject *photoBlob = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoBlob" inManagedObjectContext:newEvent.managedObjectContext];
    [photoBlob setValue:imageData forKey:@"bytes"];
    [newEvent setValue:photoBlob forKey:@"photoBlob"];
    
    //[newEvent setValue:imageData forKey:@"photoBlob"];
    [newEvent setValue:self.event.publishDate forKey:@"creationDate"];
    [newEvent setValue:self.event.latitude forKey:@"latitude"];
    [newEvent setValue:self.event.longitude forKey:@"longitude"];
    [newEvent setValue:self.event.place forKey:@"locationName"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)initFormWithVenues:(NSArray *)venues
{
    self.formModel = [FKFormModel formTableModelForTableView:self.tableView
                                        navigationController:self.navigationController];
    
    
    self.event.publishDate = [NSDate date];
    
    [FKFormMapping mappingForClass:[aEvent class] block:^(FKFormMapping *formMapping) {
        [formMapping sectionWithTitle:@"Your Foodie" identifier:@"customCells"];
        
        [formMapping mapCustomCell:[UITableViewCell class]
                        identifier:@"custom"
                         rowHeight:300
              willDisplayCellBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
                  //cell.textLabel.text = @"";
                  UIImage *newImage = (UIImage *)self.event.photo;
                  self.event.thumbnail = (NSData *)[newImage thumbnailImage:80
                                                          transparentBorder:3
                                                               cornerRadius:10
                                                       interpolationQuality:kCGInterpolationNone];
                  
                  
                  cell.imageView.image = [newImage thumbnailImage:300
                                                transparentBorder:3
                                                     cornerRadius:10
                                             interpolationQuality:kCGInterpolationNone];
                  
              }     didSelectBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
                  NSLog(@"You pressed me");
                  
              }];
        
        [formMapping sectionWithTitle:@"About it" footer:@"Save and Start Eating. Don't forget to make comments afterward. " identifier:@"info"];
        [formMapping mapAttribute:@"tags"
                            title:@"Tags"
                  placeholderText:@"Chinese, Bun, Pork"
                             type:FKFormAttributeMappingTypeText];
        
        //        [formMapping mapAttribute:@"releaseDate" title:@"ReleaseDate" type:FKFormAttributeMappingTypeDate dateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        [formMapping mappingForAttribute:@"publishDate"
                                   title:@"When"
                                    type:FKFormAttributeMappingTypeDate
                        attributeMapping:^(FKFormAttributeMapping *mapping) {
                            
                            mapping.dateFormat = @"dd MMM YYYY";
                        }];
        
        //[formMapping mapAttribute:@"place" title:@"Where" type:FKFormAttributeMappingTypeBoolean];
        [formMapping mapAttribute:@"place"
                            title:@"Where"
                     showInPicker:NO
                selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                    *selectedValueIndex = 0;
                    
                    progress = 0.0f;
                    [SVProgressHUD showProgress:0 status:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
                    [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3];
                    NSLog(@"venues = %@", venues);
                    
                    //NSLog(@"current = %@", self.currentLocation);
                    self.event.longitude   = [NSNumber numberWithDouble:self.currentLocation.coordinate.longitude];
                    self.event.latitude    = [NSNumber numberWithDouble:self.currentLocation.coordinate.latitude];
                    return venues;
                    //return self.nearbyVenues;//[NSArray arrayWithObjects:@"Place 1", @"Place 2", @"Place 3",nil];
                    
                } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                    //NSLog(@"Object = %@", object);
                    return value;
                    
                } labelValueBlock:^id(id value, id object) {
                    return value;
                    
                }];
        
        [formMapping mapAttribute:@"otherplace"
                            title:@"Address"
                  placeholderText:@"If you didn't see your option above, input here"
                             type:FKFormAttributeMappingTypeText];
        // [formMapping mapAttribute:@"numberOfActor" title:@"Number of actor" type:FKFormAttributeMappingTypeInteger];
        [formMapping mapAttribute:@"comment" title:@"Comment" type:FKFormAttributeMappingTypeBigText];
        
        //        Doesn't work very good now
        //        [formMapping mapSliderAttribute:@"rate" title:@"Rate" minValue:0 maxValue:10 valueBlock:^NSString *(id value) {
        //            return [NSString stringWithFormat:@"%.1f", [value floatValue]];
        //        }];
        
        [formMapping mapAttribute:@"rate"
                            title:@"Rate"
                     showInPicker:NO
                selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                    *selectedValueIndex = 0;
                    return [NSArray arrayWithObjects:@"Excellent", @"Just so so", @"Really bad",nil];
                    
                } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                    return value;
                    
                } labelValueBlock:^id(id value, id object) {
                    return value;
                    
                }];
        

        
        [formMapping sectionWithTitle:@"Actions" identifier:@"saveButton"];
        
        
        [formMapping buttonSave:@"Save" handler:^{
            NSLog(@"save pressed");
            NSLog(@"%@", self.event);
            [self.formModel save];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        [formMapping button:@"Share with friends"
                 identifier:@"share"
                    handler:^(id object) {
                        NSLog(@"save pressed");
                        NSLog(@"%@", object);
                        [self sharingWithContent:self.event.comment
                                           image:(UIImage *)self.event.photo];
                        
                    }
               accesoryType:UITableViewCellAccessoryNone];
        
        [formMapping validationForAttribute:@"tags" validBlock:^BOOL(NSString *value, id object) {
            return value.length < 10;
            
        } errorMessageBlock:^NSString *(id value, id object) {
            return @"Text is too long.";
        }];
        
        [formMapping validationForAttribute:@"publishDate" validBlock:^BOOL(id value, id object) {
            return YES;
        }];
        
        [self.formModel registerMapping:formMapping];
    }];
    
    [self.formModel setDidChangeValueWithBlock:^(id object, id value, NSString *keyPath) {
        NSLog(@"did change model value");
    }];
    
    [self.formModel loadFieldsWithObject:_event];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getCurrentLocation];
    [self initFormWithVenues:self.nearbyVenues];
    [self getVenuesForLocation:self.currentLocation];
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.formModel = nil;
    self.event = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
#pragma mark Location related functions
- (void)getCurrentLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}
-(void)getVenuesForLocation:(CLLocation*)location
{
    
    [Foursquare2 searchVenuesNearByLatitude:@(location.coordinate.latitude)
								  longitude:@(location.coordinate.longitude)
								 accuracyLL:nil
								   altitude:nil
								accuracyAlt:nil
									  query:nil
									  limit:@(30)
									 intent:nil
                                     radius:@(500)
								   callback:^(BOOL success, id result){
                                       NSLog(@"Success = %@, result = %@", success, result);
									   if (success) {
										   NSDictionary *dic = result;
										   NSArray* venues = [dic valueForKeyPath:@"response.venues"];
                                           FSConverter *converter = [[FSConverter alloc]init];
                                           self.nearbyVenues =  [converter convertToObjects:venues];
                                           //[self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
                                           //[self proccessAnnotations];
                                           if (self.nearbyVenues == nil && location != nil){
                                               [self getVenuesForLocation:location];
                                           }
                                           [self initFormWithVenues:self.nearbyVenues];
                                           
									   }else{
                                           //[self getVenuesForLocation:location];
                                           //[self initFormWithVenues:self.nearbyVenues];
                                       }
                                       
								   }];
    
    
    
}

#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError:%@", error);
    [SVProgressHUD showErrorWithStatus:@"I cannot get your current location"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"locationManager: didUpdateLocations: ");
    
    if (locations != nil && [locations count] > 0) {
        // get location
        CLLocation *currentLocation = [locations lastObject];
        
        self.currentLocation = currentLocation;
        NSLog(@"%@", self.currentLocation);
        // stop when we have one location found
        [locationManager stopUpdatingLocation];
    }
    
    
}
@end
