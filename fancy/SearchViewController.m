//
//  SearchViewController.m
//  fancy
//
//  Created by shaoxinjiang on 1/22/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "SearchViewController.h"
#import "Model/Events.h"
#import "XJLocation.h"
#import <AddressBookUI/AddressBookUI.h>
@interface SearchViewController ()
{
    NSArray *searchResults;
    CLGeocoder *geocoder;
}
@property (nonatomic, strong) NSMutableArray *suggestedLocations;
@end

@implementation SearchViewController
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{

    if ([searchText length] > 3) {
        [geocoder geocodeAddressString:searchText
                     completionHandler:^(NSArray* placemarks, NSError* error){
                         NSLog(@"Get Locations");
                         self.suggestedLocations = [NSMutableArray array];
                         for (CLPlacemark* aPlacemark in placemarks)
                         {
                             // Process the placemark
                             NSString *formatedAddress = [[NSString alloc] initWithFormat:@"%@", ABCreateStringWithAddressDictionary(aPlacemark.addressDictionary, NO)];
                             NSLog(@"Address = %@", formatedAddress);
                             XJLocation *newLocation = [[XJLocation alloc] init];
                             
                             if (formatedAddress != nil) {
                                 newLocation.formatedAddress = formatedAddress;
                                 newLocation.location = aPlacemark.location;
                                 [self.suggestedLocations addObject:newLocation];
                             }
                         }
                         //NSLog(@"Addresses = %@", [self.suggestedLocations componentsJoinedByString:@", "]);
                     }];
    }
    
    NSLog(@"searchText = %@", searchText);
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        NSLog(@"Suggestion Cnt = %i", [self.suggestedLocations count]);
        return [self.suggestedLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"locationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    XJLocation *xjlocation = [self.suggestedLocations objectAtIndex:indexPath.row];
    cell.textLabel.text = xjlocation.formatedAddress;//[self.suggestedLocations objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView == self.searchController.searchResultsTableView) {
        
        XJLocation *xjlocation = [self.suggestedLocations objectAtIndex:indexPath.row];
        NSLog(@"seletected = %@", xjlocation.formatedAddress);
        NSLog(@"loc = %@", xjlocation.location);
        
        
        [self setMapCenterWithLocation:xjlocation.location];
        // update your model based on the current selection
        
        [tableView removeFromSuperview];
        //[self.searchController setActive:YES animated:NO];
        [self.searchController setActive:NO animated:NO];
        [self.searchBar resignFirstResponder];
        [self.searchBar setText:nil];
    }
}


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

-(void)viewWillAppear:(BOOL)animated
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Events"];
    self.events = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup search bar
    geocoder = [[CLGeocoder alloc] init];
    //self.suggestedLocations = [[NSMutableArray alloc] init];
    
    self.searchController = [[UISearchDisplayController alloc]
                        initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
	
    // setup Map View.
    self.mapView.delegate = self;
    
    //load data latitude and longitude
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Events"];
    self.events = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setMapCenterWithLocation:(CLLocation *)currentLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

#pragma mark - Map Related Delegates

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    if (!CLLocationCoordinate2DIsValid(userLocation.coordinate)) {
        //do nothing, invalid regions
        NSLog(@"co-ord fail");
    } else if (region.span.latitudeDelta <= 0.0 || region.span.longitudeDelta <= 0.0) {
        NSLog(@"invalid reg");
    } else {
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    }
   
    
    // add events to the map
    for (NSManagedObject *event in self.events) {
        //NSLog(@"Found event : %@ %@", [event valueForKey:@"longitude"], [event valueForKey:@"latitude"]);
        MKPointAnnotation *eventpoint = [[MKPointAnnotation alloc] init];
        eventpoint.coordinate = CLLocationCoordinate2DMake([[event valueForKey:@"latitude"] doubleValue],[[event valueForKey:@"longitude"] doubleValue]);
        eventpoint.title = [event valueForKey:@"locationName"];
        eventpoint.subtitle = [event valueForKey:@"comment"];
        
        [self.mapView addAnnotation:eventpoint];
        eventpoint = nil;
    }
    
}

@end
