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
#import "FSConverter.h"


@interface NearbyVenuesController : NSObject

@property (strong,nonatomic) NSDictionary* selected;
@property (strong,nonatomic) NSArray* nearbyVenues;
@property (strong,nonatomic) CLLocation *currentLocation;


+ (id) sharedManager;

- (NSArray *)getNearbyVenues:(CLLocation *)location;

@end
