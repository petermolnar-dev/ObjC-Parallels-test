//
//  PMOThumbnailCreator.h
//  Parallels-test
//
//  Created by Peter Molnar on 10/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "PMOBackgroundTaskExecutable.h"
#import "PMOOperationWithQueue.h"

// Image resizer, using NSOperationQueue
//

@interface PMOThumbnailCreator : PMOOperationWithQueue <PMOBackgroundTaskExecutable>

// The required new size of the image.
// If any of the width or height values are 0.0, image won't be produced.
@property (unsafe_unretained, nonatomic) CGSize size;


@end
