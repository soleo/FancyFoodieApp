//
//  SharingActivity.m
//  fancy
//
//  Created by shaoxinjiang on 1/19/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "SharingActivity.h"

@implementation SharingActivity
#pragma mark - Hierarchy
#pragma mark UIActivity
- (NSString *)activityTitle {
    return @"EXACT";
    //return NSLocalizedString(@"Activity", @"");
}

- (UIImage *)activityImage {
    
    UIImage *activityImage =
    //UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ?
    [UIImage imageNamed:@"logo"]; //:
    //[UIImage imageNamed:@"activity-ipad"];
    
    return activityImage;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    
    return YES;
}

#pragma mark Activity
- (UIViewController *)performWithActivityItems:(NSArray *)activityItems {
    
//    ZYHelloViewController *helloViewController =
//    [[ZYHelloViewController alloc] initWithNibName:@"ZYHelloViewController"
//                                            bundle:nil];
//    
//    helloViewController.activity = self;
    
    return NO;//helloViewController;
}

@end
