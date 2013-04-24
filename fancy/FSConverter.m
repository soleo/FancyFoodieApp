//
//  FSConverter.m
//  fancy
//
//  Created by shaoxinjiang on 3/31/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "FSConverter.h"

@implementation FSConverter
-(NSArray*)convertToObjects:(NSArray*)venues{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:venues];
    for (NSDictionary *v  in venues) {

        [objects addObject:v[@"name"]];
    }
    return objects;
}

@end
