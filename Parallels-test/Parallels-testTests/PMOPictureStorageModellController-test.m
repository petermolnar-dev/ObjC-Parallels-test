//
//  PMOPictureStorageModellController-test.m
//  Parallels-test
//
//  Created by Peter Molnar on 16/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMOPictureModellControllerFactory.h"
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

- (void)tearDown {
    [super tearDown];
    _storage = nil;
}


#pragma mark - Tests
-(void)testSetupFromJSONFile {
    [self.storage setupFromJSONFileatURL:[NSURL URLWithString:@"http://localhost/items.json"] baseURLStringForImages:@"http://localhost/"];
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
    [self.storage setupFromJSONFileatURL:[NSURL URLWithString:@"http://localhost/items.json"] baseURLStringForImages:@"http://localhost/"];

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

- (BOOL)arePictureModelControllersEqualController1:(PMOPictureModellController *)mc1 Controller2:(PMOPictureModellController *)mc2 {
    BOOL result;
    
    BOOL resultOfTitle = [mc1.picture.imageTitle isEqualToString:mc2.picture.imageTitle];
    BOOL resultOfURL = [mc1.picture.imageURL isEqual:mc2.picture.imageURL];
    BOOL resultOfImageDescription = [mc1.picture.imageDescription isEqualToString:mc2.picture.imageDescription];
    BOOL resultOfImageFileName= [mc1.picture.imageFileName isEqualToString:mc2.picture.imageFileName];
    
    result = resultOfTitle && resultOfURL && resultOfImageDescription && resultOfImageFileName;
    
    return result;
}


-(void)testSelectItem {
    [self.storage setupFromJSONFileatURL:[NSURL URLWithString:@"http://localhost/items.json"] baseURLStringForImages:@"http://localhost"];
    NSDictionary *testItemDetails = @{
        @"description" : @"Image for WWDC 2009",
        @"image" : @"wwdc9.png",
        @"name" : @"WWDC'09"
    };
    PMOPictureModellController *modellController = [PMOPictureModellControllerFactory modellControllerFromDictionary:testItemDetails baseURLAsStringForImage:@"http://localhost"];

    XCTestExpectation *expectation = [ self keyValueObservingExpectationForObject:self.storage
                                                                          keyPath:@"countOfPictures"
                                                                          handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
                                                                                  NSLog(@"******* ******* Checked item: %@",[self.storage pictureModellAtIndex:4].imageTitle );
                                                                              if (self.storage && [self arePictureModelControllersEqualController1:modellController Controller2:[self.storage pictureModellAtIndex:4]] ) {
                                                                                 
                                                                                  [expectation fulfill];
                                                                                  return true;
                                                                              } else {
                                                                                  return false;
                                                                              }
                                                                          }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}




@end
