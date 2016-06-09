//
//  PMOPIctureStorageModellController.h
//  Parallels-test
//
//  Created by Peter Molnar on 10/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMOPictureModellController.h"

// Controller for holding and manipulating the main set of Picture Modell Controllers
//
@interface PMOPictureStorageModellController : NSObject

@property (unsafe_unretained, nonatomic, readonly) NSUInteger countOfPictures;
@property (weak, nonatomic, readonly) NSArray *pictureList;
@property (copy, nonatomic) NSString *baseURLAsString;

-(PMOPictureModellController *)pictureModellAtIndex:(NSUInteger)index;
-(void)setupFromJSONFileatURL:(NSURL *)url baseURLStringForImages:(NSString *)baseURLString;



@end
