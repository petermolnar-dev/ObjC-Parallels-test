//
//  PMOImageViewController.h
//  Parallels-test
//
//  Created by Peter Molnar on 31/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOViewWithIndicator.h"
#import "PMOPictureModelController.h"

@interface PMOImageViewController : UIViewController

@property (weak, nonatomic) PMOPictureModelController *modellController;
@property (strong, nonatomic) PMOViewWithIndicator *view;


@end
