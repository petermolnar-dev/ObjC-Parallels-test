//
//  PMOTableViewDataSource.m
//  Parallels-test
//
//  Created by Peter Molnar on 30/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOImageTableViewDataSource.h"
#import "PMOPictureTableViewCell.h"

@implementation PMOImageTableViewDataSource

#pragma mark - Init
- (instancetype)initWithStorageController:(PMOPictureStorageModellController *)storageController URLForJSONFile:(NSURL *)jsonFile baseURLStringForImages:(NSString *)baseURLStringForImages
{
    self = [super init];
    if (self && storageController) {
        _storageController = storageController;
        [_storageController setupFromJSONFileatURL:jsonFile baseURLStringForImages:baseURLStringForImages];
    }
    
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Not initialized succesfully" reason:@"Use -initWithStorageController: storageController: URLForJSONFile: baseURLStringForImages: as Designated initializer" userInfo:nil];
    return nil;
}

#pragma mark - Helper functions
- (BOOL)isStorageControllerEmpty {
    if ([self.storageController countOfPictures] == 0) {
        return true;
    } else {
        return false;
    }
}

- (UITableViewCell *)customCellFortableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    PMOPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCell" forIndexPath:indexPath];
    PMOPictureModellController *controller = [self.storageController pictureModellAtIndex:indexPath.row];
    
    if (!cell) {
        cell = [[PMOPictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"PictureCell"];
    }
    
    if (controller) {
        cell.controller = controller;
        [controller addObserver:cell
                     forKeyPath:@"thumbnailImage"
                        options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        cell.titleLabel.text = controller.imageTitle;
        cell.descriptionLabel.text = controller.imageDescription;
        cell.thumbnailView.image = controller.thumbnailImage;
    }
    return cell;
}

#pragma mark - Implementing the protocol

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isStorageControllerEmpty]) {
        return nil;
    } else {
        return [self customCellFortableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (![self isStorageControllerEmpty]) {
        return [self.storageController countOfPictures];
    } else {
        return 0;
    }
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
