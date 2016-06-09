//
//  PMOPictureModellControllerFactory.h
//  Parallels-test
//
//  Created by Peter Molnar on 05/06/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMOPictureModellController.h"

@interface PMOPictureModellControllerFactory : NSObject

+ (PMOPictureModellController *)modellControllerFromDictionary:(NSDictionary *)dictionary baseURLAsStringForImage:(NSString *)baseURLAsString;
+ (NSString *)updateURLAsStringWithTrailingHash:(NSString *)URLstring;

@end
