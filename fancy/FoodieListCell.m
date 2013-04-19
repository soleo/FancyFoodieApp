//
//  FoodieListCell.m
//  fancy
//
//  Created by shaoxinjiang on 1/20/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "FoodieListCell.h"
#import "ThirdParty/BButton/BButton.h"
#import "ThirdParty/QBPopupMenu/QBPopupMenu.h"
#import "XJLongTextViewController.h"
#import "ThirdParty/BaseKit/Code/View/UIViewController+BaseKit.h"

@interface FoodieListCell ()
@property (nonatomic, strong) UIImage* photo;
@property (nonatomic, strong) NSString* comment;
@property (nonatomic, strong) UIViewController* viewController;
@property (nonatomic, strong) BWLongTextViewController* vc;
@property (nonatomic, strong) UINavigationController* nc;
@end
@implementation FoodieListCell

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMenuInCell];
        // Initialization code
//        self.photoView = (UIImageView *)[self viewWithTag:100];
//        self.dateLabel = (UILabel *)[self viewWithTag:101];
//        self.locationLabel = (UILabel *)[self viewWithTag:102];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupMenuInCell
{
    // popupMenu
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] init];
    
    QBPopupMenuItem *shareItem = [QBPopupMenuItem itemWithTitle:@"Share" target:self action:@selector(share:)];
    
    QBPopupMenuItem *commentItem = [QBPopupMenuItem itemWithTitle:@"Comment" target:self action:@selector(updateComment:)];
    //commentItem.enabled = NO;
   
    popupMenu.items = [NSArray arrayWithObjects:shareItem, commentItem, nil];
    
    self.popupMenu = popupMenu;
    NSLog(@"Set up Menu In cell");
    [self.menuButton addTarget:self action:@selector(showPopupMenu:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setupMenuInCellWithComment:(NSString *)comment andWithPhoto:(UIImage *)photo andWithEvent:(Events*)event presentViewController:(UIViewController *)viewController
{
    self.viewController = viewController;
    self.comment = comment;
    self.photo   = photo;
    self.event   = event;
    // popupMenu
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] init];
    
    QBPopupMenuItem *shareItem = [QBPopupMenuItem itemWithTitle:@"Share" target:self action:@selector(share:)];
    
    QBPopupMenuItem *commentItem = [QBPopupMenuItem itemWithTitle:@"Comment" target:self action:@selector(updateComment:)];
    //commentItem.enabled = NO;
    QBPopupMenuItem *rateItem = [QBPopupMenuItem itemWithTitle:@"Rate" target:self action:@selector(updateRate:)];
    popupMenu.items = [NSArray arrayWithObjects:shareItem, commentItem, rateItem,  nil];
    
    self.popupMenu = popupMenu;
    //NSLog(@"Set up Menu In cell");
    [self.menuButton addTarget:self action:@selector(showPopupMenu:) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)updateRate:(id)sender{
    UIActionSheet *sheet;
    
    
    sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Excellent", @"Just OK", @"Really Bad", nil];
    
    [sheet showFromTabBar:self.viewController.tabBarController.tabBar];
    //    [sheet showFromRect:self.viewController.showFromRect inView:self.showFromViewController.view animated:YES];
    

}

- (IBAction)showPopupMenu:(id)sender
{
    BButton *button = (BButton *)sender;
    NSLog(@"show Popup Menu");
    [self.popupMenu showInView:self atPoint:CGPointMake(button.center.x, button.frame.origin.y)];
}

- (IBAction)share:(id)sender
{
    //QBPopupMenuItem *item = (QBPopupMenuItem *)sender;
    NSLog(@"share: %@", [sender class]);
    //NSLog(@"Share Action = %@", item);
    [self sharingWithContent:self.comment image:self.photo];
    
}

- (IBAction)updateComment:(id)sender
{
    NSLog(@"Update Comment Action");

    [self.viewController presentModalViewControllerWithBlock:^UIViewController *{
        //NSLog(@"pre");
        self.vc = [[XJLongTextViewController alloc] initWithText:self.comment
                                                   withDoneBlock:^{
                                                       NSLog(@"Done Block , comment = %@", self.vc.textView.text);
                                                       NSManagedObjectContext *context = [self managedObjectContext];
                                                       [self.event setComment:self.vc.textView.text];
                                                       NSError *error = nil;
                                                       // Save the object to persistent store
                                                       if (![context save:&error]) {
                                                           NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                                                       }
        }
                                                 withCancelBlock:^{
                                                     NSLog(@"Cancel block");
        }];
        return self.vc;
        
    } navigationController:YES animated:YES];
   
}
#pragma mark - UIActionSheetDelegate
- (void)saveRate:(NSString *)rate{
    NSManagedObjectContext *context = [self managedObjectContext];
    [self.event setRate:rate];
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    switch (buttonIndex) {
        case 0:
            // Excellent
            [self saveRate:@"Excellent"];
            break;
            
        case 1:
            // Just OK
            [self saveRate:@"Just OK"];
            return;
            
        case 2:
            // Really Bad
            [self saveRate:@"Really bad"];
            break;
            
        default:
            break;
    }
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
        [self.viewController presentViewController:activityViewController
                           animated:YES
                         completion:nil];
    }
}
@end
