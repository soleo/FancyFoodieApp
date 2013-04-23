//
//  NearbyVenuesController.m
//  fancy
//
//  Created by shaoxinjiang on 2/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "NearbyVenuesController.h"
#import "ThirdParty/SVProgressHUD/SVProgressHUD.h"
#import "ThirdParty/BaseKit/Code/Core/BaseKitCore.h"
@interface NearbyVenuesController ()

+ (id) manager;

@end


@implementation NearbyVenuesController

+ (id)sharedManager
{
    BK_ADD_SHARED_INSTANCE_USING_BLOCK(^{
        return [self manager];
    });
}

+ (id)manager
{
    return [[self alloc] init];
}


- (NSArray *)getNearbyVenues:(CLLocation *)location
{
    self.currentLocation = location;
    [Foursquare2 searchVenuesNearByLatitude:@(location.coordinate.latitude)
                                  longitude:@(location.coordinate.longitude)
                                 accuracyLL:nil
                                   altitude:nil
                                accuracyAlt:nil
                                      query:nil
                                      limit:nil
                                     intent:nil
                                     radius:@(500)
                                   callback:^(BOOL success, id result) {
                                       
                                       if(success){
                                           
                                           NSDictionary *dic = result;
										   NSArray* venues = [dic valueForKeyPath:@"response.venues"];
                                           FSConverter *converter = [[FSConverter alloc]init];
                                           self.nearbyVenues =  [converter convertToObjects:venues];
                                           //NSLog(@"Venues: %@", self.nearbyVenues);
                                           
                                       }
    }];
    
    return self.nearbyVenues;
   
}

@end
