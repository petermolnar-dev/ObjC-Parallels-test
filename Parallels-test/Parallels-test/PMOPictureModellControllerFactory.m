//
//  PMOPictureModellControllerFactory.m
//  Parallels-test
//
//  Created by Peter Molnar on 05/06/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOPictureModellControllerFactory.h"

@implementation PMOPictureModellControllerFactory

#pragma mark - Helper functions
+ (NSString *)updateURLAsStringWithTrailingHash:(NSString *)URLstring {
    
    // Check if the URL ends with slash (/) character.
    if (![[URLstring substringFromIndex:[URLstring length]-1] isEqual:@"/"]) {
        URLstring= [URLstring stringByAppendingString:@"/"];
    }
    return URLstring;
}

+ (PMOPicture *)setupPictureDetailsFromDictionary:(NSDictionary *)pictureDetails  baseURLAsStringForImage:(NSString *)baseURLAsString {
    
    PMOPicture *picture = [[PMOPicture alloc] init];
    [picture setImageDescription:[pictureDetails objectForKey:@"description"]];
    [picture setImageFileName:[pictureDetails objectForKey:@"image"]];
    [picture setImageTitle:[pictureDetails objectForKey:@"name"]];
    [picture setImageURL:[NSURL URLWithString:[[self updateURLAsStringWithTrailingHash:baseURLAsString] stringByAppendingString:picture.imageFileName]]];
    
    return picture;
}

#pragma mark - Factory main function
+ (PMOPictureModellController *)modellControllerFromDictionary:(NSDictionary *)dictionary baseURLAsStringForImage:(NSString *)baseURLAsString {
    
    PMOPictureModellController *modellController = [[PMOPictureModellController alloc] init];
    
    modellController.picture = [self setupPictureDetailsFromDictionary:dictionary
                                               baseURLAsStringForImage:baseURLAsString];
    
    return modellController;
}


@end
