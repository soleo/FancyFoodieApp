//
//  Photos.h
//  fancy
//
//  Created by shaoxinjiang on 2/16/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Events;

@interface Photos : NSManagedObject

@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) Events *relationship;

@end
