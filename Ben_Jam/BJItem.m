//
//  BJItem.m
//  Ben Jam
//
//  Created by David Bernard on 12/12/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "BJItem.h"

@implementation BJItem

+ (NSDictionary *)encodingBehaviorsByPropertyKey {
    return @{
             @"id": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorUnconditional],
             @"name": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorUnconditional],
             @"position": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorUnconditional],
             @"imagePath": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorUnconditional],
             @"audioPath": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorUnconditional],
             @"parent_id": [NSNumber numberWithUnsignedInt:MTLModelEncodingBehaviorUnconditional]
             
             };
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id": @"id",
             @"name": @"name",
             @"position": @"position",
             @"imagePath": @"image",
             @"audioPath": @"audio",
             @"parentId": @"parent_id"
             };
}
+(NSString *)managedObjectEntityName
{
    // ------------------------------------------------
    // If you have a Core Data entity called "Book"
    // then you return @"Book";
    //
    // Don't return the Mantle model class name here.
    // ------------------------------------------------
    return @"BJItem";
}

+(NSDictionary *)managedObjectKeysByPropertyKey
{
    // ------------------------------------------------
    // not really sure what this does, I just put
    // it in as the example does it too
    // ------------------------------------------------
    return @{};
}
@end
