//
//  PMOPictureModelController.h
//  Parallels-test
//
//  Created by Peter Molnar on 28/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMOPicture.h"

@interface PMOPictureModelController : NSObject

@property (strong, nonatomic) NSString *baseURLAsString;

- (instancetype)initWithPictureFromDictionary:(NSDictionary *)pictureDetails baseURLAsStringForImage:(NSString *)baseURLAsString; // Designated initializer


@end
