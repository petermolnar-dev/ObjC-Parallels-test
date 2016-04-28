//
//  PMOPictureModelController.m
//  Parallels-test
//
//  Created by Peter Molnar on 28/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOPictureModelController.h"

@interface PMOPictureModelController()

@property (strong, nonatomic) NSMutableArray *pictures;


@end

@implementation PMOPictureModelController

- (instancetype)initWithPictureFromDictionary:(NSDictionary *)pictureDetails baseURLAsStringForImage:(NSString *)baseURLAsString {
    
    self = [super init];
    if (self && baseURLAsString) {
        [self setBaseURLAsString:baseURLAsString];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
}


- (void)addPictureFromDictionary:(NSDictionary *)pictureDetails baseURLAsStringForImage:(NSString *)baseURLAsString {
    
    PMOPicture *picture = [[PMOPicture alloc] init];
    
    [picture setImageDescription:[pictureDetails objectForKey:@"description"]];
    [picture setImageFileName:[pictureDetails objectForKey:@"image"]];
    [picture setImageTitle:[pictureDetails objectForKey:@"name"]];
    // Check if the URL ends with slash (/) character.
    if (![[baseURLAsString substringFromIndex:[baseURLAsString length]-1] isEqual:@"/"]) {
        baseURLAsString= [baseURLAsString stringByAppendingString:@"/"];
    }
    [picture setImageURL:[NSURL URLWithString:[baseURLAsString stringByAppendingString:picture.imageFileName]]];
    
    
    // Start to download the image
    
    // add to pictures array
    [self.pictures addObject:picture];
    
    // Tune to the image change
    [picture addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}

-(NSMutableArray *)pictures {
    
    if (!_pictures) {
        _pictures =[[NSMutableArray alloc] init];
    }
    
    return _pictures;
}


@end
