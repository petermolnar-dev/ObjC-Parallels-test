//
//  PMOImageTableViewDataSource-tests.m
//  Parallels-test
//
//  Created by Peter Molnar on 06/07/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMOImageTableViewDataSource.h"
#import "PMOPictureModellController.h"

@interface PMOImageTableViewDataSource_tests : XCTestCase
@property (strong, nonatomic) PMOImageTableViewDataSource *dataSource;
@property (strong, nonatomic) PMOPictureStorageModellController *storageController;
@end

@implementation PMOImageTableViewDataSource_tests

- (void)setUp {
    [super setUp];
    NSURL *jsonURL = [NSURL URLWithString:@"http://localhost/items.json"];
    [self.storageController setupFromJSONFileatURL:jsonURL baseURLStringForImages:@"http://localhost"];

    self.dataSource = [[PMOImageTableViewDataSource alloc] initWithStorageController:self.storageController URLForJSONFile:jsonURL baseURLStringForImages:@"http://localhost"];
}

- (void)tearDown {
    self.dataSource = nil;
    self.storageController = nil;
    [super tearDown];
}

- (void)testDataSourceNotNil {
    
    XCTAssertNotNil(self.dataSource);
}

- (void)testModellReceivedFromTheDataSource {
    PMOPictureModellController *modellControllerFromStorage = [self.storageController pictureModellAtIndex:3];
    PMOPictureModellController *modellControllerFromDataSource = [self.dataSource modellControllerAtIndex:3];
    XCTAssertEqual(modellControllerFromStorage, modellControllerFromDataSource);
}

@end
