//
//  FoodieDetailViewController.m
//  fancy
//
//  Created by shaoxinjiang on 1/22/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "FoodieDetailViewController.h"
#import "NSStringHelper.h"
#import "aEvent.h"
#import "ThirdParty/MGBox/MGBox.h"
#import "ThirdParty/MGBox/MGScrollView.h"
#import "ThirdParty/MGBox/MGStyledBox.h"
#import "ThirdParty/MGBox/MGBoxLine.h"
#import "ThirdParty/FontAwesome/UIFont+FontAwesome.h"
#import "ThirdParty/FontAwesome/NSString+FontAwesome.h"
#import "Util/UIImage+Resize.h"

@interface FoodieDetailViewController ()

@end

@implementation FoodieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)addLineForBox:(MGStyledBox *)box withInfo:(NSString *)info withIcon:(NSString *)icon
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
    label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    label.text = [NSString fontAwesomeIconStringForIconIdentifier:icon];
    MGBoxLine *boxLine = [MGBoxLine lineWithLeft:label right:info];
    [box.topLines addObject:boxLine];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    MGScrollView *scroller = [[MGScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [self.view addSubview:scroller];
    scroller.alwaysBounceVertical = YES;
    //scroller.delegate = self;
    
    MGStyledBox *photoBox = [MGStyledBox box];
    [scroller.boxes addObject:photoBox];
    
    MGBoxLine *photoHeader = [MGBoxLine lineWithLeft:@"Foodie" right:nil];
    photoHeader.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [photoBox.topLines addObject:photoHeader];
    
    // get photo
    UIImage *image = [[UIImage imageWithData:self.event.photo] resizedImage:CGSizeMake(280.0f, 280.0f) interpolationQuality:nil];
    NSArray *imgLineLeft =
        [NSArray arrayWithObjects:image, nil];
    MGBoxLine *imgLine = [MGBoxLine lineWithLeft:imgLineLeft right:nil];

    [imgLine setHeight:320];
    [imgLine layoutContents];
    [photoBox.topLines addObject:imgLine];
    

    MGStyledBox *box = [MGStyledBox box];
    [scroller.boxes addObject:box];
    
    // a header line
    MGBoxLine *header = [MGBoxLine lineWithLeft:@"Event Details" right:nil];
    header.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [box.topLines addObject:header];
    
    // get date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *date = [formatter stringFromDate:self.event.publishDate];
    [self addLineForBox:box withInfo:date withIcon:@"icon-calendar"];
    
    //get location name
    [self addLineForBox:box withInfo:self.event.place withIcon:@"icon-map-marker"];
    [self addLineForBox:box withInfo:self.event.otherplace withIcon:@"icon-home"];
    
    //get rate
    [self addLineForBox:box withInfo:self.event.rate withIcon:@"icon-flag"];
    
    //get comment
    [self addLineForBox:box withInfo:self.event.comment withIcon:@"icon-comment"];
    

    MGStyledBox *tagsBox = [MGStyledBox box];
    [scroller.boxes addObject:tagsBox];
    
    header = [MGBoxLine lineWithLeft:@"My Tags" right:nil];
    header.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [tagsBox.topLines addObject:header];
    [self addLineForBox:tagsBox withInfo:self.event.tags withIcon:@"icon-tags"];
    //[scroller.boxes addObject:tagsBox];
    
    [scroller drawBoxesWithSpeed:0.6];

    //self.detailPhotoView = (UIImageView *)[self.view viewWithTag:100];
    //self.dateLabel       = (UILabel *)[self.view viewWithTag:101];
    //self.locationLabel   = (UILabel *)[self.view viewWithTag:102];
    //self.commentLabel    = (UILabel *)[self.view viewWithTag:103];

    //NSLog(@"Event passed: %@", self.event);
    //self.locationLabel.text = self.event.locationName;
    
    
//    [self.dateLabel setAttributedText:[NSString stringWithFontAwesomeIcon:@"icon-calendar" withTextContent:date]];
//    [self.commentLabel setAttributedText:[NSString stringWithFontAwesomeIcon:@"icon-comment" withTextContent:self.event.comment]];
//    [self.tagsLabel setAttributedText:[NSString stringWithFontAwesomeIcon:@"icon-tags" withTextContent:@"tags of current food"]];
//    
//    self.detailPhotoView.image = image;
//    
//    if ([NSString isEmpty:self.event.place]) {
//        [self.locationLabel setAttributedText:[NSString stringWithFontAwesomeIcon:@"icon-food" withTextContent:@"Unknown"]];
//        NSLog(@"Not Provided");
//    }else{
//        [self.locationLabel setAttributedText:[NSString stringWithFontAwesomeIcon:@"icon-food" withTextContent:self.event.place]];
//    }
    //self.commentLabel.text = self.event.comment;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doShare:(id)sender
{
    [self sharingWithContent:self.event.comment image:(UIImage *)self.event.photo];
}
#pragma mark Activity Action methods
- (void) sharingWithContent:(NSString *)text image:(UIImage *)foodiePhoto
{
    NSArray *activityItems =
    @[
      text,
      foodiePhoto
      ];
    NSArray *applicationActivities =
    @[
      [[UIActivity alloc] init]
      ];
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:applicationActivities];
    
    activityViewController.excludedActivityTypes =
    @[
      UIActivityTypeCopyToPasteboard,
      UIActivityTypeSaveToCameraRoll,
      UIActivityTypeAssignToContact,
      UIActivityTypePrint
      ];
    
    BOOL isRunningOniPhone =
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    if( isRunningOniPhone == YES){
        [self presentViewController:activityViewController
                                          animated:YES
                                        completion:nil];
    }
}

@end
