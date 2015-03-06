//
//  BJItemClient.m
//  Ben Jam
//
//  Created by David Bernard on 2/02/2015.
//  Copyright (c) 2015 Pegwing Pty Ltd. All rights reserved.
//

#import "BJItemClient.h"
#import "BJItem.h"

@implementation BJItemClient

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"items/*": [BJItem class],
             @"items.json": [BJItem class],
             @"items/*/items.json": [BJItem class],
             };
}

@end
