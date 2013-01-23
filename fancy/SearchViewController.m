//
//  SearchViewController.m
//  fancy
//
//  Created by shaoxinjiang on 1/22/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "SearchViewController.h"
#import "Model/Events.h"
@interface SearchViewController ()

@end

@implementation SearchViewController
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mapView.delegate = self;
    
    //load data latitude and longitude
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Events" ];
    self.events = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (NSManagedObject *event in self.events) {
        NSLog(@"Found event : %@ %@", [event valueForKey:@"longitude"], [event valueForKey:@"latitude"]);
        
    }
//    for (id item in self.events) {
//        NSLog(@"Found Item : %@", item);
//    }
    //NSLog(@"events array %@", self.events);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Map Related Delegates

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    [self.mapView addAnnotation:point];
    
    for (NSManagedObject *event in self.events) {
        NSLog(@"Found event : %@ %@", [event valueForKey:@"longitude"], [event valueForKey:@"latitude"]);
        MKPointAnnotation *eventpoint = [[MKPointAnnotation alloc] init];
        eventpoint.coordinate = CLLocationCoordinate2DMake([[event valueForKey:@"latitude"] doubleValue],[[event valueForKey:@"longitude"] doubleValue]);
        eventpoint.title = @"fancy";
        eventpoint.subtitle = [event valueForKey:@"comment"];
        [self.mapView addAnnotation:eventpoint];
        eventpoint = nil;
    }
    
        
    
}

@end
