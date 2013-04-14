//
//  Settings.h
//  fancy
//
//  Created by Xinjiang Shao on 4/14/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (nonatomic, strong) NSNumber *saveToAlbum;
//@property (nonatomic, strong) NSString *lang;

+ (Settings *)shared;

+ (BOOL)isSaveToAlbum;

- (void)save;
@end
