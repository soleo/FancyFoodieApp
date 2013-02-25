//
//  FirstViewController.m
//  fancy
//
//  Created by shaoxinjiang on 1/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "FirstViewController.h"
#import "ThirdParty/MGBox/MGBox.h"
#import "ThirdParty/MGBox/MGScrollView.h"
#import "ThirdParty/MGBox/MGStyledBox.h"
#import "ThirdParty/MGBox/MGBoxLine.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    MGScrollView *scroller = [[MGScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [self.view addSubview:scroller];
    MGStyledBox *box = [MGStyledBox box];
    [scroller.boxes addObject:box];
    
    // a header line
    MGBoxLine *header = [MGBoxLine lineWithLeft:@"My First Box" right:nil];
    header.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [box.topLines addObject:header];
    
    // a string on the left and a horse on the right
    UIImage *horse = [UIImage imageNamed:@"horse"];
    MGBoxLine *line1 = [MGBoxLine lineWithLeft:@"A string on the left" right:horse];
    [box.topLines addObject:line1];
    
    // create a second box
    MGStyledBox *box2 = [MGStyledBox box];
    [scroller.boxes addObject:box2];
    
    // add a line with multiline text
    NSString *blah = @"Multiline content is automatically sized and formatted "
    "given an NSString, UIFont, and desired padding.";
    MGBoxLine *multiline = [MGBoxLine multilineWithText:blah font:nil padding:24];
    [box2.topLines addObject:multiline];
    
    [scroller drawBoxesWithSpeed:0.6];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
