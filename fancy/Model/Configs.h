//
//  Configs.h
//  fancy
//
//  Created by shaoxinjiang on 1/22/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Configs : NSManagedObject

@property (nonatomic, retain) NSString * authorEmail;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSString * version;

@end
