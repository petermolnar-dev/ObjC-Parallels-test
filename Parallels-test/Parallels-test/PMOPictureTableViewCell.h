//
//  PMOPictureTableViewCell.h
//  Parallels-test
//
//  Created by Peter Molnar on 10/06/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMOViewWithIndicator.h"
#import "PMOPictureModellController.h"

@interface PMOPictureTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet PMOViewWithIndicator *indicatorView;
@property (weak, nonatomic) PMOPictureModellController *controller;

@end
