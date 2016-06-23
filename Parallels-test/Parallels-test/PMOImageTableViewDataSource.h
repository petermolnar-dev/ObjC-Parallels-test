//
//  PMOTableViewDataSource.h
//  Parallels-test
//
//  Created by Peter Molnar on 30/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "PMOPictureStorageModellController.h"

@interface PMOImageTableViewDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) PMOPictureStorageModellController *storageController;

- (instancetype)initWithStorageController:(PMOPictureStorageModellController *)storageController URLForJSONFile:(NSURL *)jsonFile baseURLStringForImages:(NSString *)baseURLStringForImages;
 // Designated initializer

- (PMOPictureModellController *)modellControllerAtIndex:(NSUInteger )index;

@end
