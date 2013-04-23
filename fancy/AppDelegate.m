//
//  AppDelegate.m
//  fancy
//
//  Created by shaoxinjiang on 1/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "AppDelegate.h"
#import "Util/Utility.h"
#import "NearbyVenuesController.h"
#import "ThirdParty/BaseKit/Code/LocationManager/BaseKitLocationManager.h"
#import "Model/Settings.h"


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)initSettings
{
    Settings *settings = [Settings shared];
    
    if (nil == settings.saveToAlbum)
        settings.saveToAlbum = BK_BOOLEAN(YES);
    //for testing purpose
    //settings.saveToAlbum = BK_BOOLEAN(NO);
    //NSLog(@"Settings = %@", settings.saveToAlbum);
}

- (void)initLocationManager
{
    BKLocationManager *manager = [BKLocationManager sharedManager];
    [manager setDidUpdateLocationBlock:^(CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation) {
        NSLog(@"didUpateLocation");
        NearbyVenuesController *nvc = [NearbyVenuesController sharedManager];
        [nvc getNearbyVenues:newLocation];
        NSLog(@"%@", nvc.nearbyVenues);
        //[manager stopUpdatingLocation];
    }];
    [manager setDidFailBlock:^(CLLocationManager *manager, NSError *error) {
        NSLog(@"didFailUpdateLocation");
    }];
    [manager startUpdatingLocationWithAccuracy:kCLLocationAccuracyHundredMeters];
    
}

- (void)initAppearance
{
    // Change Navigation Bar Style
    UIImage *navBarBtn = [[UIImage imageNamed:@"NavigationButtonBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 6, 14, 6)];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"NavigationBarBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 6, 14, 6)]
                                       forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:navBarBtn
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:navBarBtn
                                                                                        forState:UIControlStateNormal
                                                                                      barMetrics:UIBarMetricsDefault];
    // Assign tab bar item with titles
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [tabBar.items objectAtIndex:4];
    
    tabBarItem1.title = @"Home";
    tabBarItem2.title = @"Food List";
    tabBarItem3.title = @"Statistics";
    tabBarItem4.title = @"Search";
    tabBarItem5.title = @"Settings";
    
    // @TODO: add icons for tabs
    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"home"]
              withFinishedUnselectedImage:[UIImage imageNamed:@"home"]];
    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"foodielist"]
              withFinishedUnselectedImage:[UIImage imageNamed:@"foodielist"]];
    [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"statistics"]
              withFinishedUnselectedImage:[UIImage imageNamed:@"statistics"]];
    [tabBarItem4 setFinishedSelectedImage:[UIImage imageNamed:@"search"]
              withFinishedUnselectedImage:[UIImage imageNamed:@"search"]];
    [tabBarItem5 setFinishedSelectedImage:[UIImage imageNamed:@"settings"]
              withFinishedUnselectedImage:[UIImage imageNamed:@"settings"]];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selection"]];
    
    NSDictionary *normalState = @{
                                  UITextAttributeTextColor : [UIColor colorWithWhite:0.213 alpha:1.000],
                                  UITextAttributeTextShadowColor: [UIColor whiteColor],
                                  UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0, 1.0)]
                                  };
    
    NSDictionary *selectedState = @{
                                    UITextAttributeTextColor : [UIColor blackColor],
                                    UITextAttributeTextShadowColor: [UIColor whiteColor],
                                    UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0, 1.0)]
                                    };
    
    [[UITabBarItem appearance] setTitleTextAttributes:normalState forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:selectedState forState:UIControlStateSelected];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
#define TESTING 1
#ifdef TESTING
    [TestFlight setDeviceIdentifier:[UIDevice currentDevice].identifierForVendor.UUIDString];
#endif
    [TestFlight takeOff:@"518f85be-d660-4d94-a2ff-5f7e55a1bbec"];
    [self initAppearance];
    [self initSettings];
    [self initLocationManager];
    return YES;
}
						
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self initAppearance];
    [self initSettings];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"fancyModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"fancyModel.sqlite"];
    
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
