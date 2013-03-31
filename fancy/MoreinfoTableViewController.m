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

@interface MoreinfoTableViewController ()

@end

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

@implementation MoreinfoTableViewController

@synthesize formModel;
@synthesize event = _event;

- (void) customizeNavBar {
    PrettyNavigationBar *navBar = (PrettyNavigationBar *)self.navigationController.navigationBar;
    //navBar.backgroundColor = [UIColor colorWithRed:0.00f green:0.33f blue:0.80f alpha:1.00f];
    navBar.topLineColor = [UIColor colorWithHex:0xFF1000];
    navBar.gradientStartColor = [UIColor colorWithHex:0xDD0000];
    navBar.gradientEndColor = [UIColor colorWithHex:0xAA0000];
    navBar.bottomLineColor = [UIColor colorWithHex:0x990000];
    navBar.tintColor = navBar.gradientEndColor;
    navBar.roundedCornerRadius = 8;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getCurrentLocation];
    [self getVenuesForLocation:self.currentLocation];
    //self.tableView.rowHeight = 60;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    //self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:nil action:nil] autorelease];
    
    //[self.tableView dropShadows];
    //[self customizeNavBar];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.formModel = [FKFormModel formTableModelForTableView:self.tableView
                                        navigationController:self.navigationController];
    aEvent *event = [aEvent initWithPhoto:nil];
    //event.rate = 3;
    //event.title = @"Test Me";
    event.publishDate = [NSDate date];
    //event.rate = @"Good";
    
    self.event = event;
    [FKFormMapping mappingForClass:[aEvent class] block:^(FKFormMapping *formMapping) {
        [formMapping sectionWithTitle:@"About your foodie" footer:@"Save and Start Eating. Don't forget to make comments afterward. " identifier:@"info"];
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
                    NSLog(@"current = %@", self.currentLocation);
                    
                                       
                    [self getVenuesForLocation:self.currentLocation];
                    NSLog(@"venues = %@", self.nearbyVenues);
                                       
                    
                    
                    return self.nearbyVenues;//[NSArray arrayWithObjects:@"Place 1", @"Place 2", @"Place 3",nil];
                    
                } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
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
        
        [formMapping sectionWithTitle:@"Custom cells" identifier:@"customCells"];
        
        [formMapping mapCustomCell:[UITableViewCell class]
                        identifier:@"custom"
                         rowHeight:70
              willDisplayCellBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
                  cell.textLabel.text = @"I am a custom cell !";
                  
              }     didSelectBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
                  NSLog(@"You pressed me");
                  
              }];
        
        [formMapping mapCustomCell:[UITableViewCell class]
                        identifier:@"custom2"
              willDisplayCellBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
                  cell.textLabel.text = @"I am a custom cell too !";
                  
              }     didSelectBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
                  NSLog(@"You pressed me");
                  
              }];
        
        [formMapping sectionWithTitle:@"Buttons" identifier:@"saveButton"];
        
        [formMapping buttonSave:@"Save" handler:^{
            NSLog(@"save pressed");
            NSLog(@"%@", self.event);
            [self.formModel save];
        }];
        
        [formMapping validationForAttribute:@"tags" validBlock:^BOOL(NSString *value, id object) {
            return value.length < 10;
            
        } errorMessageBlock:^NSString *(id value, id object) {
            return @"Text is too long.";
        }];
        
        [formMapping validationForAttribute:@"publishDate" validBlock:^BOOL(id value, id object) {
            return NO;
        }];
        
        [self.formModel registerMapping:formMapping];
    }];
    
    [self.formModel setDidChangeValueWithBlock:^(id object, id value, NSString *keyPath) {
        NSLog(@"did change model value");
    }];
    
    [self.formModel loadFieldsWithObject:event];
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.formModel = nil;
    self.event = nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
#pragma mark Location related functions
- (void)getCurrentLocation{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}
-(void)getVenuesForLocation:(CLLocation*)location{
    
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
        //self.latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
        //self.longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
       // NSLog(@"gotLocation: %.8f %.8f", [self.longitude doubleValue], [self.latitude doubleValue]);
        self.currentLocation = currentLocation;
        NSLog(@"%@", self.currentLocation);
        // stop when we have one location found
        [locationManager stopUpdatingLocation];
        
        // get nearby venues by using foursquare api
        //      NSArray *nearlist = [[NearbyVenuesController sharedInstance] getNearbyVenues:currentLocation];
        //      NSLog(@"Near by venues: %@", nearlist);
        
        // resolve the address
//        NSLog(@"Resolve Address");
//        [geocoder reverseGeocodeLocation:currentLocation
//                       completionHandler:^(NSArray *placemarks, NSError *error){
//                           NSLog(@"Found Placemarks:%@ error:%@", placemarks, error);
//                           if( error == nil && [placemarks count] > 0){
//                               placemark = [placemarks lastObject];
//                               self.locationLabel.text = [NSString stringWithFormat:@"%@ %@, %@ %@, %@, %@",
//                                                          placemark.subThoroughfare, placemark.thoroughfare,
//                                                          placemark.postalCode, placemark.locality,
//                                                          placemark.administrativeArea,
//                                                          placemark.country];
//                               self.locationName = self.locationLabel.text;
//                               
//                           } else {
//                               NSLog(@"%@", error.debugDescription);
//                           }
//                           
//                           
//                       }];
    }
    
    
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}
//
///*
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//*/
//
///*
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}
//*/
//
///*
//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//}
//*/
//
///*
//// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}
//*/
//
//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

@end
