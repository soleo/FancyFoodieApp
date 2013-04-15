//
//  XJLocation.h
//  fancy
//
//  Created by Xinjiang Shao on 4/15/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface XJLocation : NSObject
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString   *formatedAddress;
@end
