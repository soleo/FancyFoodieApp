//
//  MoreinfoTableViewController.m
//  fancy
//
//  Created by shaoxinjiang on 3/30/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "MoreinfoTableViewController.h"
#import "ThirdParty/FormKit/FormKit.h"
#import "ThirdParty/SVProgressHUD/SVProgressHUD.h"
#import "aEvent.h"
#import "NearbyVenuesController.h"
#import "FSConverter.h"
#import "Util/UIImage+Resize.h"
#import "Model/Events.h"
#import "Model/Settings.h"
#import "Model/Tag.h"
@interface MoreinfoTableViewController ()

- (NSManagedObjectContext *)managedObjectContext;

@end

#define start_color [UIColor colorWithHex:0xEEEEEE]
#define end_color [UIColor colorWithHex:0xDEDEDE]

@implementation MoreinfoTableViewController

@synthesize formModel;
@synthesize event = _event;


- (NSManagedObjectContext *) managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void) fetchTagsArray{
    // Put the fetched tags into a mutable array.
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag"
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"label"
																   ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSError *error;
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil) {
		// Handle the error.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	NSMutableArray *mutableArray = [fetchedObjects mutableCopy];
	self.tagsArray = mutableArray;

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (IBAction)saveEvent:(id)sender{
    NSManagedObjectContext *context = [self managedObjectContext];
    // save ablum if user need
    if ([Settings isSaveToAlbum]) {
        if (! self.assetsLibrary)
            _assetsLibrary = [[ALAssetsLibrary alloc] init];
        [self.assetsLibrary saveImage:(UIImage *)self.event.photo
                              toAlbum:@"Fancy Foodie Photos"
                  withCompletionBlock:^(NSError *error) {
                      // @TODO: if failed , need to deal with it,too.
                      NSLog(@"Save to album");
                  }];
       
    }
    // save event to database
    Events *newEvent =
    [NSEntityDescription insertNewObjectForEntityForName:@"Events"
                                  inManagedObjectContext:context];
    [newEvent setValue:self.event.comment forKey:@"comment"];
    
    NSData *imageData = UIImagePNGRepresentation((UIImage *)self.event.photo);
    NSManagedObject *photoBlob = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoBlob" inManagedObjectContext:newEvent.managedObjectContext];
    [photoBlob setValue:imageData forKey:@"bytes"];
    [newEvent setValue:photoBlob forKey:@"photoBlob"];

    [newEvent setValue:self.event.publishDate forKey:@"creationDate"];
    [newEvent setValue:self.event.latitude forKey:@"latitude"];
    [newEvent setValue:self.event.longitude forKey:@"longitude"];
    [newEvent setValue:self.event.place forKey:@"locationName"];
    [newEvent setValue:self.event.rate forKey:@"rate"];
    [newEvent setValue:self.event.otherplace forKey:@"address"];
    
    NSData *thumbnailData = UIImagePNGRepresentation((UIImage *)self.event.thumbnail);
    [newEvent setValue:thumbnailData forKey:@"thumbnail"];
    //NSSet *tags = [[NSSet alloc]init] ;
    //[tags setByAddingObjectsFromArray:[self.event.tags componentsSeparatedByString:@","]];
    
    NSArray *tags = [self.event.tags componentsSeparatedByString:@","];
    [self fetchTagsArray];
    NSLog(@"already have tags = %@", self.tagsArray);
    for (NSString *tag in tags) {
        NSLog(@"tag = %@", tag);
        
        Tag *aTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:[newEvent managedObjectContext]];
        aTag.label = tag;
        [aTag addPhotosObject:newEvent];
        // Presumably the tag was added for the current event, so relate it to the event.
        [newEvent addTagsObject:aTag];
    }
    
    //[newEvent addTags:tags];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)initForm
{
    self.formModel = [FKFormModel formTableModelForTableView:self.tableView
                                        navigationController:self.navigationController];
    
    
    self.event.publishDate = [NSDate date];
    
    [FKFormMapping mappingForClass:[aEvent class] block:^(FKFormMapping *formMapping) {
        [formMapping sectionWithTitle:@"Your Foodie" identifier:@"customCells"];
        
        [formMapping mapCustomCell:[UITableViewCell class]
                        identifier:@"custom"
                         rowHeight:300
              willDisplayCellBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
                  
                  UIImage *newImage = (UIImage *)self.event.photo;
                  self.event.thumbnail = (NSData *)[newImage thumbnailImage:80
                                                          transparentBorder:3
                                                               cornerRadius:10
                                                       interpolationQuality:kCGInterpolationNone];
                  
                  
                  cell.imageView.image = [newImage thumbnailImage:320
                                                transparentBorder:3
                                                     cornerRadius:10
                                             interpolationQuality:kCGInterpolationNone];
                  
              }     didSelectBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
                  NSLog(@"You pressed me");
                  
              }];
        
        [formMapping sectionWithTitle:@"About it" footer:@"Save and Start Eating. Don't forget to make comments afterward. " identifier:@"info"];
        [formMapping mapAttribute:@"tags"
                            title:@"Tags"
                  placeholderText:@"Chinese, Bun, Pork"
                             type:FKFormAttributeMappingTypeText];
        
        [formMapping mappingForAttribute:@"publishDate"
                                   title:@"When"
                                    type:FKFormAttributeMappingTypeDate
                        attributeMapping:^(FKFormAttributeMapping *mapping) {
                            
                            mapping.dateFormat = @"dd MMM YYYY";
                        }];
        
        [formMapping mapAttribute:@"place"
                            title:@"Where"
                     showInPicker:NO
                selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                    *selectedValueIndex = 0;
                    
                    NearbyVenuesController *nvc = [NearbyVenuesController sharedManager];
                    //NSLog(@"current = %@", self.currentLocation);
                    self.event.longitude   = [NSNumber numberWithDouble:nvc.currentLocation.coordinate.longitude];
                    self.event.latitude    = [NSNumber numberWithDouble:nvc.currentLocation.coordinate.latitude];
                    return nvc.nearbyVenues;
                    
                } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                    
                    return value;
                    
                } labelValueBlock:^id(id value, id object) {
                    return value;
                    
                }];
        
        [formMapping mapAttribute:@"otherplace"
                            title:@"Address"
                  placeholderText:@"If you didn't see your option above, input here"
                             type:FKFormAttributeMappingTypeText];
        
        [formMapping mapAttribute:@"comment"
                            title:@"Comment"
                             type:FKFormAttributeMappingTypeBigText];
        
        [formMapping mapAttribute:@"rate"
                            title:@"Rate"
                     showInPicker:NO
                selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                    *selectedValueIndex = 0;
                    return [NSArray arrayWithObjects:@"Excellent", @"Just OK", @"Really bad",nil];
                    
                } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                    return value;
                    
                } labelValueBlock:^id(id value, id object) {
                    return value;
                    
                }];
        

        
//        [formMapping sectionWithTitle:@"Actions" identifier:@"saveButton"];
//        
//        
//        [formMapping buttonSave:@"Save" handler:^{
//            NSLog(@"save pressed");
//            NSLog(@"%@", self.event);
//            [self.formModel save];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }];
//        
//        [formMapping button:@"Share with friends"
//                 identifier:@"share"
//                    handler:^(id object) {
//                        NSLog(@"save pressed");
//                        NSLog(@"%@", object);
//                        [self sharingWithContent:self.event.comment
//                                           image:(UIImage *)self.event.photo];
//                        
//                    }
//               accesoryType:UITableViewCellAccessoryNone];
        
        [formMapping validationForAttribute:@"tags" validBlock:^BOOL(NSString *value, id object) {
            return value.length < 256;
            
        } errorMessageBlock:^NSString *(id value, id object) {
            return @"Text is too long.";
        }];
        
        [formMapping validationForAttribute:@"publishDate" validBlock:^BOOL(id value, id object) {
            return YES;
        }];
        
        [self.formModel registerMapping:formMapping];
    }];
    
    [self.formModel setDidChangeValueWithBlock:^(id object, id value, NSString *keyPath) {
        NSLog(@"did change model value");
    }];
    
    [self.formModel loadFieldsWithObject:_event];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initForm];
}
- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.formModel = nil;
    self.event = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end
