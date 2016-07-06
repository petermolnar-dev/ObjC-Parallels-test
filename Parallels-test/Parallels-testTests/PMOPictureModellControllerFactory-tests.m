//
//  PMOPictureModellControllerFactory-tests.m
//  Parallels-test
//
//  Created by Peter Molnar on 05/07/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMOPictureModellControllerFactory.h"
#import "PMODownloadTaskQueues.h"

@interface PMOPictureModellControllerFactory_tests : XCTestCase
@property (strong, nonatomic) PMODownloadTaskQueues *queues;
@end

@implementation PMOPictureModellControllerFactory_tests

- (void)setUp {
    [super setUp];
    self.queues = [[PMODownloadTaskQueues alloc] init];
 }

- (void)testFactoryProducingNotNil {
    NSDictionary  *testPicture = @{ @"image" : @"testpicture.png",
                                    @"name" : @"TestPicture",
                                    @"description" : @"Local test picture"};
    
    PMOPictureModellController *modellControllerBuilt = [PMOPictureModellControllerFactory modellControllerFromDictionary:testPicture
                                                                                                  baseURLAsStringForImage:@"http://localhost"
                                                                                                           downloadQueues:self.queues];

    XCTAssertNotNil(modellControllerBuilt);
}

- (void)testTrailingHashAdded {
   NSString *urlStringWithTrailingSlash = [PMOPictureModellControllerFactory updateURLAsStringWithTrailingSlash:@"http://localhost"];
    NSString *expectedString = @"http://localhost/";
    
    XCTAssert([expectedString isEqualToString:urlStringWithTrailingSlash]);
}

- (void)testTrailingHashNotAdded {
    NSString *urlStringWithTrailingSlash = [PMOPictureModellControllerFactory updateURLAsStringWithTrailingSlash:@"http://localhost/"];
    NSString *expectedString = @"http://localhost/";
    
    XCTAssert([expectedString isEqualToString:urlStringWithTrailingSlash]);
}

- (void)tearDown {
    self.queues = nil;
    [super tearDown];
}


@end
