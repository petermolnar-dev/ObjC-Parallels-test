//
//  PMOImageTableViewController.h
//  Parallels-test
//
//  Created by Peter Molnar on 03/06/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMOViewWithIndicator.h"
#import "PMODownloadTaskQueues.h"

@interface PMOImageTableViewController : UIViewController

@property (strong, nonatomic) PMOViewWithIndicator *view;
@property (copy, nonatomic) NSString *JSONFileURLAsString;
@property (copy, nonatomic) NSString *baseImageURLAsString;
@property (weak, nonatomic) PMODownloadTaskQueues *queues;

@end
