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


@interface PMOTableViewDataSource : NSObject <UITableViewDataSource>
-(instancetype)initWithStorageController:(PMOPictureStorageModellController *)storageController; // Designated initializer
@end
