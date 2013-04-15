//
//  XJWebviewControllerViewController.m
//  fancy
//
//  Created by Xinjiang Shao on 4/15/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "XJWebviewControllerViewController.h"

@interface XJWebviewControllerViewController ()

@end

@implementation XJWebviewControllerViewController
@synthesize webView;
@synthesize text = _text;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    self.webView = nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithText:(NSString *)text {
    self = [self init];
    if (self) {
        self.text = text;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = self.view.bounds;
    frame.origin.y = 3;
    self.webView.frame = frame;
    NSURL *url = [NSURL URLWithString:self.text];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    [self.view addSubview:self.webView];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
    [super viewDidUnload];
    
    //    self.textView = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

@end
