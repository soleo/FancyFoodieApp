//
//  SearchViewController.h
//  fancy
//
//  Created by shaoxinjiang on 1/22/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Model/Events.h"
@interface SearchViewController : UIViewController <MKMapViewDelegate, UISearchDisplayDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong) NSMutableArray *events;
@end
