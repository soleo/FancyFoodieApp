//
//  XJWebviewControllerViewController.h
//  fancy
//
//  Created by Xinjiang Shao on 4/15/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJWebviewControllerViewController : UIViewController

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *text;

- (id)initWithText:(NSString *)text;

@end

