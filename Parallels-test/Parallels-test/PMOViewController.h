//
//  PMOViewController.h
//  Parallels-test
//
//  Created by Peter Molnar on 28/04/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMODownloadTaskQueues.h"
#import "PMOViewWithIndicator.h"

@interface PMOViewController : UIViewController
@property (strong, nonatomic) PMODownloadTaskQueues *downloadQueues;
@property (strong, nonatomic) PMOViewWithIndicator *view;
@end
