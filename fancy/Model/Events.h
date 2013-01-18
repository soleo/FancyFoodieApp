//
//  Events.h
//  fancy
//
//  Created by shaoxinjiang on 1/17/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Events : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * photo;

@end
