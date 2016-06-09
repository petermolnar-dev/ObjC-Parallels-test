//
//  PMOTableViewDataSource.m
//  Parallels-test
//
//  Created by Peter Molnar on 30/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOImageTableViewDataSource.h"

@interface PMOImageTableViewDataSource()


-(UITableViewCell *)customCellFortableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath ;

@end



@implementation PMOImageTableViewDataSource

#pragma mark - Init
-(instancetype)initWithStorageController:(PMOPictureStorageModellController *)storageController URLForJSONFile:(NSURL *)jsonFile baseURLStringForImages:(NSString *)baseURLStringForImages
{
    self = [super init];
    if (self && storageController) {
        _storageController = storageController;
        [_storageController setupFromJSONFileatURL:jsonFile baseURLStringForImages:baseURLStringForImages];
    }
    
    return self;
}

-(instancetype)init {
    NSLog(@"Use initWithStorageController: storageController as Designated initializer");
    return nil;
}

#pragma mark - Helper functions

-(BOOL)isStorageControllerEmpty {
    if ([self.storageController countOfPictures] == 0) {
        return true;
    } else {
        return false;
    }
}

-(UITableViewCell *)customCellFortableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCell" forIndexPath:indexPath];
    PMOPictureModellController *controller = [self.storageController pictureModellAtIndex:indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"PictureCell"];
    }
    if (controller) {
        cell.textLabel.text = controller.imageTitle;
        cell.detailTextLabel.text = [controller.imageDescription stringByAppendingString:[controller.picture.imageURL absoluteString]];
    } else {
        cell.textLabel.text = @"";
    
    }
    return cell;
}

#pragma mark - Implementing the protocol

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isStorageControllerEmpty]) {
        return nil;
    } else {
        return [self customCellFortableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (![self isStorageControllerEmpty]) {
        return [self.storageController countOfPictures];
    } else {
        return 0;
    }
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
