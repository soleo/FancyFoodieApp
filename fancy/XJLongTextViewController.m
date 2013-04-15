//
//  XJLongTextViewController.m
//  fancy
//
//  Created by Xinjiang Shao on 4/14/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "XJLongTextViewController.h"

@interface XJLongTextViewController ()

@end

@implementation XJLongTextViewController
 
- (id)initWithText:(NSString *)text withDoneBlock:(dispatch_block_t)doneBlock withCancelBlock:(dispatch_block_t)cancelBlock
{
    self = [super initWithText:text];
    if (self) {
        self.cancelBlock = cancelBlock;
        self.doneBlock = doneBlock;
        // add nav bar
        self.navigationItem.title = @"Comment";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(dismiss:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
        [self.textView setFont:[UIFont boldSystemFontOfSize:30]];
        NSLog(@"init Text");
        
    }
    return self;
}

- (IBAction)dismiss:(id)sender
{
    NSLog(@"dismiss:");
    self.cancelBlock();
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender
{
    NSLog(@"done:");
    self.doneBlock();
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
