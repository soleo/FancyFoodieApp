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
//        FSVenue *ann = [[FSVenue alloc]init];
//        ann.name = v[@"name"];
//        ann.venueId = v[@"id"];
//        
//        ann.location.address = v[@"location"][@"address"];
//        ann.location.distance = v[@"location"][@"distance"];
//        
//        [ann.location setCoordinate:CLLocationCoordinate2DMake([v[@"location"][@"lat"] doubleValue],
//                                                               [v[@"location"][@"lng"] doubleValue])];
        [objects addObject:v[@"name"]];
    }
    return objects;
}

@end
