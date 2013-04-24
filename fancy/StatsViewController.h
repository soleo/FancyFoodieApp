//
//  StatsViewController.h
//  fancy
//
//  Created by Xinjiang Shao on 4/14/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGStyledBox;
@interface StatsViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *tagsArray;

- (void) fetchTagsArray;
- (NSManagedObjectContext *)managedObjectContext;
- (NSInteger *)getRatesWithCondition:(NSString *)rate;
- (NSInteger *)getCountWithEntityName:(NSString *)entityName;
- (void)addLineForBox:(MGStyledBox *)box withInfo:(NSString *)info withIcon:(NSString *)icon;
@end
