//
//  PMOTableViewDataSource.m
//  Parallels-test
//
//  Created by Peter Molnar on 30/05/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOTableViewDataSource.h"

@interface PMOTableViewDataSource()

@property (weak, nonatomic) PMOPictureStorageModellController *storageController; // Injected from outside with the init

-(UITableViewCell *)customCellFortableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath ;

@end



@implementation PMOTableViewDataSource

#pragma mark - Init
-(instancetype)initWithStorageController:(PMOPictureStorageModellController *)storageController
{
    self = [super init];
    if (self && storageController) {
        _storageController = storageController;
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
        NSLog(@"Storage controller is empty");
        return true;
    } else {
        return false;
    }
}

-(UITableViewCell *)customCellFortableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureCell" forIndexPath:indexPath];
    PMOPictureModelController *controller = [self.storageController pictureModelAtIndex:indexPath.row];
    
    
    cell.textLabel.text = controller.imageTitle;
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
