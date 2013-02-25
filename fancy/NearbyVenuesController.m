//
//  NearbyVenuesController.m
//  fancy
//
//  Created by shaoxinjiang on 2/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "NearbyVenuesController.h"


@implementation NearbyVenuesController

static NearbyVenuesController *sharedInstance = nil;

+ (NearbyVenuesController *)sharedInstance
{
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ [ NearbyVenuesController alloc] init];
    });
    
    return sharedInstance;
}


+ (NSArray *)getNearbyVenues:(CLLocation *)location
{
     NearbyVenuesController *c = [NearbyVenuesController sharedInstance];
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
                                           NSArray *venues = [[dic valueForKey:@"response"] valueForKey:@"venues"];
                                           //self.nearbyVenues = venues;
                                           
                                           c.nearbyVenues = venues;
                                           NSLog(@"Venues: %@", venues);
                                           
                                       }
    }];
    return c.nearbyVenues;
   
}
@end
