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
@interface StatsViewController ()

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
    MGBoxLine *excellentCount = [MGBoxLine lineWithLeft:@"Excellent: 0" right:excellentLabel];
    [rateBox.topLines addObject:excellentCount];
    
    UILabel *badLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
    badLabel.backgroundColor = [UIColor clearColor];
	badLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    badLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-thumbs-down"];
    MGBoxLine *badCount = [MGBoxLine lineWithLeft:@"Really Bad: 0" right:badLabel];
    [rateBox.topLines addObject:badCount];
    
    UILabel *normalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
    normalLabel.backgroundColor = [UIColor clearColor];
	normalLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    normalLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:@"icon-leaf"];
    MGBoxLine *normalCount = [MGBoxLine lineWithLeft:@"Just so so: 0" right:normalLabel];
    [rateBox.topLines addObject:normalCount];
    
    // create a second box
    //MGStyledBox *box2 = [MGStyledBox box];
    //[scroller.boxes addObject:box2];
    
    // add a line with multiline text
    NSString *blah = @"Multiline content is automatically sized and formatted "
    "given an NSString, UIFont, and desired padding.";
    MGBoxLine *multiline = [MGBoxLine multilineWithText:blah font:nil padding:24];
    [rateBox.topLines addObject:multiline];
    
    // create another box for tags
    MGStyledBox *tagsBox = [MGStyledBox box];
    [scroller.boxes addObject:tagsBox];
    
    header = [MGBoxLine lineWithLeft:@"My Tags" right:nil];
    header.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [tagsBox.topLines addObject:header];
    [self addLineForBox:tagsBox withInfo:@"11,23,344" withIcon:@"icon-tags"];
    //[scroller.boxes addObject:tagsBox];
    
    [scroller drawBoxesWithSpeed:0.6];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
