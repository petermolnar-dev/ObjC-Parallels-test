//
//  PMOPictureDownloader.h
//  Parallels-test
//
//  Created by Peter Molnar on 28/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMOPicture.h"

@interface PMOPictureDownloader : NSObject

@property (weak, nonatomic) PMOPicture *picture;

-(void)downloadPictureImage;

@end
