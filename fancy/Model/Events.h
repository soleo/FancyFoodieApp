//
//  Events.h
//  fancy
//
//  Created by Xinjiang Shao on 4/14/13.
//  Copyright (c) 2013 Xinjiang Shao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoBlob, Tag;

@interface Events : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * rate;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) PhotoBlob *photoBlob;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Events (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
