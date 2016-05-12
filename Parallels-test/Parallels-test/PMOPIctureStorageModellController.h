//
//  PMOPIctureStorageModellController.h
//  Parallels-test
//
//  Created by Peter Molnar on 10/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMOPictureModelController.h"

@interface PMOPictureStorageModellController : NSObject

@property (strong, nonatomic) NSArray *pictures;

-(void)setupFromJSONFileatURL:(NSURL *)url;

@end
