//
//  BJServer.m
//  Ben_Jam
//
//  Created by David Vincent on 30/06/2015.
//  Copyright (c) 2015 Pegwing Pty Ltd. All rights reserved.
//

#import "Foundation/NSURL.h"
#import "BJServer.h"

@implementation BJServer
// At the time of writing, hide dependencies on the source of the images and so forth on the Internet.  Ideally, no other code in the project should have to mention "http:".
static NSString* SCHEME = @"http";
static NSString* HOST = @"benjam.herokuapp.com";
+ (NSURL*)theHomePage {
    // The 'home page' works both as a link to use with a mobile browser, and as a component for certain code in the iOS app that must construct web requests.
    // We could add smarts here.  For unit tests, it would be nice if we could avoid requiring an internet connection.
    // return [[NSURL alloc] initWithScheme: SCHEME host:HOST path:@"/"];
    return [BJServer itemAtPath:@"/"];
}
+ (NSURL*)itemAtPath: (NSString*) p {
    return [[NSURL alloc] initWithScheme: SCHEME host:HOST path: p];
}
@end