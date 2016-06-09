//
//  PMOTableViewDataSource.h
//  Parallels-test
//
//  Created by Peter Molnar on 30/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMOPictureStorageModellController.h"
@import UIKit;


@interface PMOImageTableViewDataSource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) PMOPictureStorageModellController *storageController; // Injected from outside with the init

-(instancetype)initWithStorageController:(PMOPictureStorageModellController *)storageController URLForJSONFile:(NSURL *)jsonFile baseURLStringForImages:(NSString *)baseURLStringForImages;
 // Designated initializer

@end
