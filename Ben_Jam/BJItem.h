//
//  BJItem.h
//  Ben Jam
//
//  Created by David Bernard on 12/12/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface BJItem : MTLModel <MTLJSONSerializing>
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSNumber* position;
@property (nonatomic,strong) NSString* imagePath;
@property (nonatomic,strong) NSString* audioPath;
@property (nonatomic,strong) NSString *parentId;


@end
