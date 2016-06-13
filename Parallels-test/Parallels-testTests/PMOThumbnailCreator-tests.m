//
//  PMOThumbnailCreator-tests.m
//  Parallels-test
//
//  Created by Peter Molnar on 13/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMOThumbnailCreator.h"
#import "PMOThumbnailCreatorNotification.h"

@interface PMOThumbnailCreator_tests : XCTestCase
@property (strong, nonatomic)PMOThumbnailCreator *thumbnailCreator;
@end

@implementation PMOThumbnailCreator_tests

- (void)setUp {
    [super setUp];
    if (!_thumbnailCreator) {
        _thumbnailCreator = [[PMOThumbnailCreator alloc] init];
        self.thumbnailCreator = _thumbnailCreator;
    }
    
}

- (void)tearDown {
    [super tearDown];
    _thumbnailCreator = nil;
}

-(void)testresizeImageWithFixedValues20x20 {
    self.thumbnailCreator.size = CGSizeMake(20.0, 20.0);
    NSUUID *uuid = [[NSUUID alloc] init];
    NSDictionary *options = @{@"pictureKey" : [uuid UUIDString]};
    [self.thumbnailCreator processData:[UIImage imageNamed:@"testpicture"] withOptions:options];
    XCTestExpectation *expectation = [self expectationForNotification:PMOThumbnailImageGenerated
                                                               object:self.thumbnailCreator
                                                              handler:^BOOL(NSNotification * _Nonnull notification) {
                                                                  NSLog(@"Handler call");
                                                                  UIImage *image = [notification.userInfo objectForKey:@"image"];
                                                                  if (image.size.height == 20.0 && image.size.width == 20.0) {
                                                                      [expectation fulfill];
                                                                      return true;
                                                                  } else {
                                                                      return false;
                                                                  }
                        
                                                              }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
    
}

-(void)testresizeImageWithFixedValues40x40 {
    self.thumbnailCreator.size = CGSizeMake(40.0, 40.0);
    NSUUID *uuid = [[NSUUID alloc] init];
    NSDictionary *options = @{@"pictureKey" : [uuid UUIDString]};
    [self.thumbnailCreator processData:[UIImage imageNamed:@"testpicture"] withOptions:options];
    XCTestExpectation *expectation = [self expectationForNotification:PMOThumbnailImageGenerated
                                                               object:self.thumbnailCreator
                                                              handler:^BOOL(NSNotification * _Nonnull notification) {
                                                                  NSLog(@"Handler call");
                                                                  UIImage *image = [notification.userInfo objectForKey:@"image"];
                                                                  if (image.size.height == 40.0 && image.size.width == 40.0) {
                                                                      [expectation fulfill];
                                                                      return true;
                                                                  } else {
                                                                      return false;
                                                                  }
                                                                  
                                                              }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
    
}


@end
