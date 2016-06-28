//
//  PMOImageTableViewDelegate.h
//  Parallels-test
//
//  Created by Peter Molnar on 24/06/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

@import Foundation;
@import UIKit;
@class PMOImageTableViewDataSource;
@class PMOImageTableViewController;

@interface PMOImageTableViewDelegate : NSObject <UITableViewDelegate>

@property (weak, nonatomic) PMOImageTableViewDataSource *dataSource;
@property (weak, nonatomic) PMOImageTableViewController *tableViewController;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end

