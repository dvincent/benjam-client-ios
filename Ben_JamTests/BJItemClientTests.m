//
//  BJItemClientTests.m
//  Ben Jam
//
//  Created by David Bernard on 2/02/2015.
//  Copyright (c) 2015 Pegwing Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BJItemClient.h"
#import "BJItem.h"
#import <Overcoat/PromiseKit+Overcoat.h>
#import <PromiseKit/PromiseKit.h>
#import <Mantle/EXTScope.h>

@interface BJItemClientTests : XCTestCase

@end

@implementation BJItemClientTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetItem
{
    NSURL *itemURL = [NSURL URLWithString:@"http://10.0.1.127:3000"];
    BJItemClient * itemClient = [[BJItemClient alloc] initWithBaseURL:itemURL];


    __block BOOL waitingForBlock = YES;
    

    //[PMKPromise until:(id)^(void){
        [itemClient GET:@"items/1.json" parameters:nil ].then(^(OVCResponse *response){
        NSLog(@" %@", response);
        BJItem *item = response.result;
        XCTAssertNotNil(item, @"Result");
        XCTAssertTrue([item isKindOfClass:[BJItem class]], @"Correct type returned");

    }).catch(^(NSError *error){
        XCTFail(@"Error obtaining item %@", error);
    }).finally(^(void) {
        NSLog(@"Finished");
        waitingForBlock = NO;
    });
    NSLog(@"Waiting for block %d", waitingForBlock);
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        NSLog(@"Waiting for block %d", waitingForBlock);
    }


}
- (void)testGetItems
{
    NSURL *itemURL = [NSURL URLWithString:@"http://10.0.1.127:3000"];
    BJItemClient * itemClient = [[BJItemClient alloc] initWithBaseURL:itemURL];
    
    __block BOOL waitingForBlock = YES;
    
    [itemClient GET:@"items/1/items.json" parameters:nil].then(^(OVCResponse *response) {
        NSArray *items = response.result;
        NSLog(@"Items %@", items);
        NSLog(@"items[0] %@", items[0]);
        XCTAssertNotNil(items, @"Result");
        XCTAssertTrue([items[0] isKindOfClass:[BJItem class]], @"Correct type returned");
    }).catch(^(NSError *error){
        XCTFail(@"Error obtaining item %@", error);
}
             ).finally(^(void){
        NSLog(@"Finished");
        waitingForBlock = NO;
    });
    
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}
@end
