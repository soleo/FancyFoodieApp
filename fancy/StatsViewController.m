//
//  StatsViewController.m
//  fancy
//
//  Created by Xinjiang Shao on 4/14/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "StatsViewController.h"
#import "ThirdParty/MGBox/MGBox.h"
#import "ThirdParty/MGBox/MGScrollView.h"
#import "ThirdParty/MGBox/MGStyledBox.h"
#import "ThirdParty/MGBox/MGBoxLine.h"
#import "ThirdParty/FontAwesome/UIFont+FontAwesome.h"
#import "ThirdParty/FontAwesome/NSString+FontAwesome.h"
#import "Model/Tag.h"

@interface StatsViewController ()
@property (nonatomic,strong) NSMutableArray *tagsArray;
@end

@implementation StatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

-(void)viewWillAppear:(BOOL)animated
{
    [self fetchTagsArray];
}

- (NSInteger *)getRatesWithCondition:(NSString *)rate{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Events" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setIncludesSubentities:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY %K == %@", @"rate", rate];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSInteger count = [[self managedObjectContext] countForFetchRequest:fetchRequest error:&error];
    NSLog(@"fetch results count = %i", count);
    return count;
}
- (NSInteger *)getCountWithEntityName:(NSString *)entityName{
    int entityCount = 0;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setIncludesSubentities:NO];
    NSError *error = nil;
    NSUInteger count = [[self managedObjectContext] countForFetchRequest: fetchRequest error: &error];
    if(error == nil){
        entityCount = count;
    }
    return entityCount;
}
- (void)addLineForBox:(MGStyledBox *)box withInfo:(NSString *)info withIcon:(NSString *)icon
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
    label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    label.text = [NSString fontAwesomeIconStringForIconIdentifier:icon];
    MGBoxLine *boxLine = [MGBoxLine lineWithLeft:info right:label];
    [box.topLines addObject:boxLine];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self fetchTagsArray];
    
    MGScrollView *scroller = [[MGScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [self.view addSubview:scroller];
    MGStyledBox *box = [MGStyledBox box];
    [scroller.boxes addObject:box];
    
    // a header line
    MGBoxLine *header = [MGBoxLine lineWithLeft:@"How places I went so far?" right:nil];
    header.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [box.topLines addObject:header];
    
    // a string on the left and a home on the right
    UILabel *homeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
    homeLabel.backgroundColor = [UIColor clearColor];
	homeLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    homeLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-home"];
    //UIImage *home = [UIImage imageNamed:@"home"];
    int placeCountNum = [self getCountWithEntityName:@"Events"];
    MGBoxLine *placeCount;
    if (placeCountNum > 0) {
        NSString *placeStr = [[NSString alloc] initWithFormat:@"%d places", placeCountNum];
        placeCount = [MGBoxLine lineWithLeft:placeStr right:homeLabel];
    }else{
        placeCount = [MGBoxLine lineWithLeft:@"0 place" right:homeLabel];
    }
    
    [box.topLines addObject:placeCount];
    
    // create a second box
    MGStyledBox *rateBox = [MGStyledBox box];
    [scroller.boxes addObject:rateBox];
    
    header = [MGBoxLine lineWithLeft:@"My Rates" right:nil];
    header.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [rateBox.topLines addObject:header];
    
    // add rate data
    UILabel *excellentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
    excellentLabel.backgroundColor = [UIColor clearColor];
	excellentLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    excellentLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-thumbs-up"];
    NSInteger excellentCountNum= [self getRatesWithCondition:@"Excellent"];
    MGBoxLine *excellentCount = [MGBoxLine lineWithLeft:[[NSString alloc]
                                                         initWithFormat:@"Excellent: %i", excellentCountNum]
                                                  right:excellentLabel];
    [rateBox.topLines addObject:excellentCount];
    
    UILabel *badLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
    badLabel.backgroundColor = [UIColor clearColor];
	badLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    badLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-thumbs-down"];
    NSInteger badCountNum= [self getRatesWithCondition:@"Really bad"];
    MGBoxLine *badCount = [MGBoxLine lineWithLeft:[[NSString alloc]
                                                   initWithFormat:@"Really bad: %i", badCountNum]
                                            right:badLabel];
    [rateBox.topLines addObject:badCount];
    
    UILabel *normalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
    normalLabel.backgroundColor = [UIColor clearColor];
	normalLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    normalLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-leaf"];
    NSInteger normalCountNum= [self getRatesWithCondition:@"Just OK"];
    MGBoxLine *normalCount = [MGBoxLine lineWithLeft:[[NSString alloc]
                                                      initWithFormat:@"Just OK: %i", normalCountNum]
                                               right:normalLabel];
    [rateBox.topLines addObject:normalCount];
    
    
    // create another box for tags
    MGStyledBox *tagsBox = [MGStyledBox box];
    [scroller.boxes addObject:tagsBox];
    
    header = [MGBoxLine lineWithLeft:@"My Tags" right:nil];
    header.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [tagsBox.topLines addObject:header];
    
    NSMutableArray *eventTagNames = [NSMutableArray array];
    for (Tag *tag in _tagsArray) {
        [eventTagNames addObject:tag.label];
    }
    
    NSString *tagsString = @"";
    if ([eventTagNames count] > 0) {
        tagsString = [eventTagNames componentsJoinedByString:@", "];
    }
    //NSLog(@"Tags = %@", self.tagsArray);
    [self addLineForBox:tagsBox withInfo:[[NSString alloc] initWithFormat:@"Tags in total: %i",
                                          [eventTagNames count]]
                                withIcon:@"icon-tags"];
    MGBoxLine *tagsLine = [MGBoxLine multilineWithText:tagsString font:nil padding:16.0f];
    [tagsBox.topLines addObject:tagsLine];
    //[self addLineForBox:tagsBox withInfo:tagsString withIcon:@"icon-tag"];
    //[scroller.boxes addObject:tagsBox];
    
    [scroller drawBoxesWithSpeed:0.6];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
