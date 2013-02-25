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

@interface NearbyVenuesController : NSObject

@property (strong,nonatomic)NSDictionary* selected;
@property (strong,nonatomic)NSArray* nearbyVenues;

+ (id) sharedInstance;

+ (NSArray *)getNearbyVenues:(CLLocation *)location;

@end
