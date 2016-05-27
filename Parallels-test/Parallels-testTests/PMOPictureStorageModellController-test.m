//
//  PMOPictureStorageModellController-test.m
//  Parallels-test
//
//  Created by Peter Molnar on 16/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMOPictureStorageModellController.h"

@interface PMOPictureStorageModellController_test : XCTestCase

@property (strong, nonatomic) PMOPictureStorageModellController *storage;

@end

@implementation PMOPictureStorageModellController_test

- (void)setUp {
    [super setUp];
    if (!_storage) {
        _storage = [[PMOPictureStorageModellController alloc] init];
    }
}

-(void)testSetupFromJSONFile {
    [self.storage setupFromJSONFileatURL:[NSURL URLWithString:@"http://localhost/items.json"]];
    XCTestExpectation *expectation = [ self keyValueObservingExpectationForObject:self.storage
                                                                          keyPath:@"countOfPictures"
                                                                          handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
                                                                              if (self.storage && [self.storage countOfPictures] > 0) {
                                                                                  [expectation fulfill];
                                                                                  return true;
                                                                              } else {
                                                                                  return false;
                                                                              }
                                                                          }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}


-(void)testItemCount {
    [self.storage setupFromJSONFileatURL:[NSURL URLWithString:@"http://localhost/items.json"]];

    XCTestExpectation *expectation = [ self keyValueObservingExpectationForObject:self.storage
                                                                          keyPath:@"countOfPictures"
                                                                          handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
                                                                              if (self.storage && [self.storage countOfPictures] == 10) {
                                                                                  [expectation fulfill];
                                                                                  return true;
                                                                              } else {
                                                                                  return false;
                                                                              }
                                                                          }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}




-(void)testSelectItem {
    [self.storage setupFromJSONFileatURL:[NSURL URLWithString:@"http://localhost/items.json"]];
    NSDictionary *testItemDetails = @{
        @"description" : @"Image for WWDC 2009",
        @"image" : @"wwdc9.png",
        @"name" : @"WWDC'09"
    };
    
    XCTestExpectation *expectation = [ self keyValueObservingExpectationForObject:self.storage
                                                                          keyPath:@"countOfPictures"
                                                                          handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
                                                                              if (self.storage && [testItemDetails isEqualToDictionary:[self.storage pictureModelAtIndex:4]]) {
                                                                                 
                                                                                  [expectation fulfill];
                                                                                  return true;
                                                                              } else {
                                                                                  return false;
                                                                              }
                                                                          }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)tearDown {
    [super tearDown];
    _storage = nil;
}


@end
