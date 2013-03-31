//
//  NearbyVenuesController.h
//  fancy
//
//  Created by shaoxinjiang on 2/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ThirdParty/Foursquare2/Foursquare2.h"
#import <CoreLocation/CoreLocation.h>

@interface NearbyVenuesController : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@property (strong,nonatomic) NSDictionary* selected;
@property (strong,nonatomic) NSArray* nearbyVenues;
@property (strong,nonatomic) CLLocation *currentLocation;

- (void) startSearchingCurrentLocation;
- (NSArray *)getNearbyVenues:(CLLocation *)location;
- (NSArray *)getDefaultVenues;
@end
