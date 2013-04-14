//
//  Settings.m
//  fancy
//
//  Created by Xinjiang Shao on 4/14/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "Settings.h"
#import "BKMacrosDefinitions.h"

@implementation Settings

+ (Settings *)shared {
    BK_ADD_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    })
}

+ (BOOL)isSaveToAlbum {
    return [[[self shared] saveToAlbum] boolValue];
}


- (void)save {
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark -
#pragma mark Getters and setters



////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSNumber *)saveToAlbum {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"saveToAlbum"];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSaveToAlbum:(NSNumber *)saveToAlbum {
    [[NSUserDefaults standardUserDefaults] setObject:saveToAlbum forKey:@"saveToAlbum"];
}

@end
