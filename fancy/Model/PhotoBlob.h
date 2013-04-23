//
//  PhotoBlob.h
//  fancy
//
//  Created by shaoxinjiang on 2/16/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Events;

@interface PhotoBlob : NSManagedObject

@property (nonatomic, retain) NSData * bytes;
@property (nonatomic, retain) Events *photo;

@end
