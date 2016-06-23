//
//  PMOImageViewScrollViewDelegate.h
//  Parallels-test
//
//  Created by Peter Molnar on 01/06/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface PMOImageViewScrollViewDelegate : NSObject <UIScrollViewDelegate>
@property (weak, nonatomic) UIView *scrollDestinationView;


@end
