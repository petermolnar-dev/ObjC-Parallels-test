//
//  PMOPictureModelController-tests.m
//  Parallels-test
//
//  Created by Peter Molnar on 13/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMOPictureModellControllerFactory.h"
#import "PMOPictureModellController.h"
#import "PMOPicture.h"
#import "PMODownloadTaskQueues.h"

@interface PMOPictureModelController_tests : XCTestCase
@property (strong, nonatomic) PMOPictureModellController *modelController;
@property (strong, nonatomic) PMODownloadTaskQueues *queues;
@end

@implementation PMOPictureModelController_tests

- (void)setUp {
    [super setUp];
    NSDictionary  *testPicture = @{ @"image" : @"testpicture.png",
                                    @"name" : @"TestPicture",
                                    @"description" : @"Local test picture"};
    
    if (!_modelController) {
        _modelController = [PMOPictureModellControllerFactory modellControllerFromDictionary:testPicture baseURLAsStringForImage:@"http://localhost"
                                                                              downloadQueues:self.queues] ;
        self.modelController = _modelController;
    }

}

- (void)tearDown {
    [super tearDown];
    _modelController = nil;
}


- (PMODownloadTaskQueues *)queues {
    if (!_queues) {
        _queues = [[PMODownloadTaskQueues alloc] init];
    }
    
    return _queues;
}

#pragma mark - Tests
- (void)testPictureCreation {
    NSDictionary *referencePicture = @{@"imageTitle":@"TestPicture",
                                       @"imageDescription": @"Local test picture",
                                       @"imageFileName": @"testpicture.png",
                                       @"imageURL" : [NSURL URLWithString:@"http://localhost/testpicture.png"] };
    
    NSMutableDictionary *expectedPictureProperties = [[NSMutableDictionary alloc] initWithDictionary:referencePicture];
    NSMutableDictionary *resultsFromPictureModel = [[NSMutableDictionary alloc] init];
    
    [resultsFromPictureModel addEntriesFromDictionary:@{@"imageTitle" : self.modelController.picture.imageTitle}];
    [resultsFromPictureModel addEntriesFromDictionary:@{@"imageDescription" : self.modelController.picture.imageDescription}];
    [resultsFromPictureModel addEntriesFromDictionary:@{@"imageFileName" : self.modelController.picture.imageFileName}];
    [resultsFromPictureModel addEntriesFromDictionary:@{@"imageURL" : self.modelController.picture.imageURL}];
    
    XCTAssertTrue([resultsFromPictureModel isEqual:expectedPictureProperties]);
}

- (void)testPictureImageDownloadRequest {
    // Get the image with "dirty" way
    NSData *referenceImageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:@"http://localhost/testpicture.png"]];
    UIImage *referenceImage = [UIImage imageWithData:referenceImageData];
    // Maje a kind of hash from the downloaded image
    NSData *referenceImagePNGData = UIImagePNGRepresentation(referenceImage);
    // Get the image from the controller
    XCTestExpectation *expectation =[self keyValueObservingExpectationForObject:self.modelController
                                                                        keyPath:@"picture.image" handler:^BOOL(id  _Nonnull observedObject, NSDictionary * _Nonnull change) {
                                                                            NSData *testImagePNGData = UIImagePNGRepresentation([change valueForKey:@"new"]);
                                                                            
                                                                            if ([referenceImagePNGData isEqual:testImagePNGData]) {
                                                                                [expectation fulfill];
                                                                                return true;
                                                                            } else {
                                                                                [expectation fulfill];
                                                                                return false;
                                                                            }
                                                                        }];
    // Triggering the KVO event
    if (self.modelController.image) {};
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testKeyCreation {
    BOOL isPictureKeyHasLength = [self.modelController.pictureKey length] > 0;
    XCTAssertTrue(isPictureKeyHasLength);
}

@end
