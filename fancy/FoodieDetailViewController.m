//
//  FoodieDetailViewController.m
//  fancy
//
//  Created by shaoxinjiang on 1/22/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "FoodieDetailViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.detailPhotoView = (UIImageView *)[self.view viewWithTag:100];
    //self.dateLabel       = (UILabel *)[self.view viewWithTag:101];
    //self.locationLabel   = (UILabel *)[self.view viewWithTag:102];
    //self.commentLabel    = (UILabel *)[self.view viewWithTag:103];

    NSLog(@"Event passed: %@", self.event);
    self.locationLabel.text = self.event.locationName;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *date = [formatter stringFromDate:self.event.creationDate];
    self.dateLabel.text = date;
    
    UIImage *image = [UIImage imageWithData:self.event.photo];
    self.detailPhotoView.image = image;
    
    self.commentLabel.text = self.event.comment;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
