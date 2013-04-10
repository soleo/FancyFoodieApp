//
//  aEvent.h
//  fancy
//
//  Created by shaoxinjiang on 3/30/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface aEvent : NSObject
@property (nonatomic, retain) NSString *place;
@property (nonatomic, retain) NSString *otherplace;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSDate *publishDate;
@property (nonatomic, retain) NSString *rate;
@property (nonatomic, retain) NSString *tags;
@property (nonatomic, strong) NSData *photo;
@property (nonatomic, retain) NSData *thumbnail;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSNumber *latitude;

+ (id)initWithPhoto:(NSData *)newPhoto;
@end
