//
//  PMOImageTableViewDelegate.m
//  Parallels-test
//
//  Created by Peter Molnar on 24/06/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOImageTableViewDelegate.h"
#import "PMOPictureModellController.h"
#import "PMOImageTableViewDataSource.h"
#import "PMOImageTableViewController.h"
#import "PMOImageViewController.h"

@interface PMOImageTableViewDelegate()

@property (strong, nonatomic) PMOPictureModellController *selectedModellController;

@end

@implementation PMOImageTableViewDelegate

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedModellController = [self.dataSource modellControllerAtIndex:indexPath.row];
    // iPad checking
    id detail = self.tableViewController.splitViewController.viewControllers[1];
    // Check the root bnavigatior controller to find the proper view controller
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    if ([detail isKindOfClass:[PMOImageViewController class]]) {
        [self preparePictureViewController:detail toShowPicture:self.selectedModellController];
    } else {
        [self.tableViewController performSegueWithIdentifier:@"ShowImage" sender:self];
    }
}

#pragma mark - Segue and navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowImage"]) {
        PMOImageViewController *destinationVC = segue.destinationViewController;
        if (self.selectedModellController) {
            destinationVC.modellController = self.selectedModellController;
        }
    }
}


-(void)preparePictureViewController:(PMOImageViewController *)pvc toShowPicture:(PMOPictureModellController *)picturemodellController {
    pvc.modellController = picturemodellController;
    [pvc setTitle:[picturemodellController.imageTitle stringByAppendingString:[@" - " stringByAppendingString:picturemodellController.imageDescription]]];
    
}

@end
