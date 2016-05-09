//
//  PMODataDownloaderTest.m
//  Parallels-test
//
//  Created by Peter Molnar on 09/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMODataDownloader.h"

@interface PMODataDownloaderTest : XCTestCase
@property (strong, nonatomic) PMODataDownloader *downloader;
@property (strong, nonatomic) XCTestExpectation *expectation;
@end

@implementation PMODataDownloaderTest

- (void)setUp {
    [super setUp];
    self.downloader =[[PMODataDownloader alloc] init];
    self.expectation = [self expectationWithDescription:@"Notification at the end of the "];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)observerForNotification {
    [self.expectation fulfill];
}

- (void)testDownloadCompleted {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(observerForNotification)
                                                 name:PMODataDownloaderDidDownloadEnded
                                               object:nil];
    [self.downloader downloadDataFromURL:[NSURL URLWithString:@""]];
 

}

- (void)testDownloadNotNil {
    
}

@end
