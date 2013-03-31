//
//  NearbyVenuesController.m
//  fancy
//
//  Created by shaoxinjiang on 2/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "NearbyVenuesController.h"
#import "ThirdParty/SVProgressHUD/SVProgressHUD.h"

@implementation NearbyVenuesController

- (NSArray *)getNearbyVenues:(CLLocation *)location 
{
    //NearbyVenuesController *c = [[NearbyVenuesController alloc] init];
    //NSArray *venues = nil;
    [Foursquare2 searchVenuesNearByLatitude:@(location.coordinate.latitude)
                                  longitude:@(location.coordinate.longitude)
                                 accuracyLL:nil
                                   altitude:nil
                                accuracyAlt:nil
                                      query:nil
                                      limit:@(15)
                                     intent:nil
                                     radius:@(500)
                                   callback:^(BOOL success, id result) {
                                       if(success){
                                           NSDictionary *dic = result;
                                           //NSArray *venues = [[dic valueForKey:@"response"] valueForKey:@"venues"];
                                           //self.nearbyVenues = venues;
                                           NSArray* venues = [dic valueForKeyPath:@"response.venues"];
                                           //FSConverter *converter = [[FSConverter alloc]init];
                                           //self.nearbyVenues = [converter convertToObjects:venues];
                                           self.nearbyVenues = venues;
                                           NSLog(@"Venues: %@", self.nearbyVenues);
                                           
                                       }
    }];
    
    return self.nearbyVenues;
   
}


#pragma mark Location related functions
- (void)startSearchingCurrentLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError:%@", error);
    [SVProgressHUD showErrorWithStatus:@"I cannot get your current location"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"didUpdateToLocation: ");
    
    if (locations != nil && [locations count] > 0) {
        // get location
        CLLocation *currentLocation = [locations lastObject];
        //self.latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
        //self.longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
        //NSLog(@"gotLocation: %.8f %.8f", [self.longitude doubleValue], [self.latitude doubleValue]);
        self.currentLocation = currentLocation;
        // stop when we have one location found
        [locationManager stopUpdatingLocation];
        
        // get nearby venues by using foursquare api
       // NSArray *nearlist = [[NearbyVenuesController sharedInstance] getNearbyVenues:currentLocation];
       // NSLog(@"Near by venues: %@", nearlist);
        
        // resolve the address
        //NSLog(@"Resolve Address");
//        [geocoder reverseGeocodeLocation:currentLocation
//                       completionHandler:^(NSArray *placemarks, NSError *error){
//                           NSLog(@"Found Placemarks:%@ error:%@", placemarks, error);
//                           if( error == nil && [placemarks count] > 0){
//                               placemark = [placemarks lastObject];
//                               //self.locationLabel.text = [NSString stringWithFormat:@"%@ %@, %@ %@, %@, %@",
//                               //                           placemark.subThoroughfare, placemark.thoroughfare,
//                               //                           placemark.postalCode, placemark.locality,
//                               //                           placemark.administrativeArea,
//                               //                           placemark.country];
//                               //self.locationName = self.locationLabel.text;
//                               
//                           } else {
//                               NSLog(@"%@", error.debugDescription);
//                           }
//                           
//                           
//                       }];
    }
    
    
}

- (NSArray *)getDefaultVenues
{
    NSArray *venues = nil;
    [self startSearchingCurrentLocation];
    NSLog(@"%@", self.currentLocation);
    venues = [self getNearbyVenues:self.currentLocation];
    NSLog(@"%@", venues);
    return venues;
}
@end
