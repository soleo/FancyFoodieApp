//
//  aEvent.m
//  fancy
//
//  Created by shaoxinjiang on 3/30/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import "aEvent.h"

@implementation aEvent
//@synthesize title, content, releaseDate, numberOfActor, suitAllAges, password, shortName, choice, rate;



+ (id)initWithPhoto:(NSData *)newPhoto{
    aEvent *event = [[aEvent alloc] init];
    
    //event.title = newTitle;
    //event.content = newContent;
    event.photo = newPhoto;
    return event;
}



- (NSString *)description {
    return [NSString stringWithFormat:
            @"place = %@, otherplace = %@, comment = %@, publishDate = %@, rate = %@, tags = %@, photo = %@ , latitude = %@, longitude = %@, thumbnail = %@",
            self.place, self.otherplace, self.comment, self.publishDate, self.rate, self.tags, self.photo, self.latitude, self.longitude, self.thumbnail];
}

@end
