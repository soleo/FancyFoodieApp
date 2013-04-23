//
//  Event.h
//  fancy
//
//  Created by shaoxinjiang on 1/22/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, strong) NSString * comment;
@property (nonatomic, strong) NSDate * creationDate;
@property (nonatomic, strong) NSData * photo;
@property (nonatomic, strong) NSString * locationName;
@end
