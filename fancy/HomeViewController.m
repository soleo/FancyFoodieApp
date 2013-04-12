//
//  HomeViewController.m
//  fancy
//
//  Created by shaoxinjiang on 1/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()


@end

@implementation HomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *background = [UIImage imageNamed: @"HomeBackground"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    [self.view addSubview:imageView];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    
    // add the project intro to frontpage
    UILabel *introLabel = [ [UILabel alloc ] initWithFrame:CGRectMake((self.view.bounds.size.width / 3), (self.view.bounds.size.height/3), 200.0, 50.0) ];
    introLabel.textAlignment =  NSTextAlignmentCenter;
    introLabel.textColor = [UIColor whiteColor];
    introLabel.backgroundColor = [UIColor blackColor];
    introLabel.font = [UIFont fontWithName:@"DriodSans" size:(40.0)];
    [self.view addSubview:introLabel];
    NSString *introStr = @"Get Started with Fancy!";
    introLabel.text = [NSString stringWithFormat: @"%@", introStr];
    
    UILabel *addnewLabel = [ [UILabel alloc ] initWithFrame:CGRectMake((self.view.bounds.size.width / 3), (self.view.bounds.size.height/9), 200.0, 20.0) ];
    addnewLabel.textAlignment =  NSTextAlignmentRight;
    addnewLabel.textColor = [UIColor blackColor];
    addnewLabel.backgroundColor = [UIColor clearColor];//[UIColor blackColor];
    addnewLabel.font = [UIFont fontWithName:@"DriodSans" size:(18.0)];
    [self.view addSubview:addnewLabel];
    NSString *addnewStr = @"Add a New Event Here";
    addnewLabel.text = [NSString stringWithFormat: @"%@", addnewStr];
    
    UILabel *foodieListLabel = [ [UILabel alloc ] initWithFrame:CGRectMake( 10.0, (self.view.bounds.size.height/9*6), 200.0, 20.0) ];
    foodieListLabel.textAlignment =  NSTextAlignmentRight;
    foodieListLabel.textColor = [UIColor blackColor];
    foodieListLabel.backgroundColor = [UIColor clearColor];//[UIColor blackColor];
    foodieListLabel.font = [UIFont fontWithName:@"DriodSans" size:(18.0)];
    [self.view addSubview:foodieListLabel];
    NSString *foodieListStr = @"Check Foodies Out Here";
    foodieListLabel.text = [NSString stringWithFormat: @"%@", foodieListStr];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

