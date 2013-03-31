//
//  MoreinfoTableViewController.h
//  fancy
//
//  Created by shaoxinjiang on 3/30/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ThirdParty/Foursquare2/Foursquare2.h"
@class FKFormModel;
@class aEvent;

@interface MoreinfoTableViewController : UITableViewController<CLLocationManagerDelegate>
{
     CLLocationManager *locationManager;
}
@property (nonatomic, strong) FKFormModel *formModel;
@property (nonatomic, strong) aEvent *event;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, copy) NSArray *nearbyVenues;
-(void)getVenuesForLocation:(CLLocation*)location;
@end
