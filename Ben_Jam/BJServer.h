//
//  BJServer.h
//  Ben_Jam
//
//  Created by David Vincent on 30/06/2015.
//  Copyright (c) 2015 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BJServer : NSObject
+ (NSURL*) theHomePage;
+ (NSURL*) itemAtPath: (NSString*) path;
+ (NSURL*) testClientsItemAtPath: (NSString*) p;
@end
