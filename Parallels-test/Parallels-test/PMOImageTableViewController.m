//
//  PMOImageTableViewController.m
//  Parallels-test
//
//  Created by Peter Molnar on 03/06/2016.
//  Copyright © 2016 Peter Molnar. All rights reserved.
//

#import "PMOImageTableViewController.h"
#import "PMOImageTableViewDataSource.h"
#import "PMOPictureStorageModellController.h"
#import "PMOPictureJSONParserNotification.h"
#import "PMOImageViewController.h"
#import "PMOViewWithIndicator.h"

@interface PMOImageTableViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PMOImageTableViewDataSource *dataSource;
@property (strong, nonatomic) PMOPictureModellController *selectedModellController;

@end

@implementation PMOImageTableViewController

@dynamic view;

#pragma mark - Accessors
- (NSString *)JSONFileURLAsString {
    if (!_JSONFileURLAsString) {
        _JSONFileURLAsString = @"http://93.175.29.76/web/wwdc/items.json";
    }
    
    return _JSONFileURLAsString;
}

- (NSString *)baseImageURLAsString {
    if (!_baseImageURLAsString) {
        _baseImageURLAsString = @"http://93.175.29.76/web/wwdc/";
    }
    
    return _baseImageURLAsString;
}

#pragma mark - Helpers
- (void)setupTableViewDataSource {
    PMOPictureStorageModellController *storageModelController = [[PMOPictureStorageModellController alloc] init];
    NSURL *jsonFileURL = [NSURL URLWithString:self.JSONFileURLAsString];
    
    self.dataSource = [[PMOImageTableViewDataSource alloc]
                       initWithStorageController:storageModelController URLForJSONFile:jsonFileURL baseURLStringForImages:self.baseImageURLAsString];
    self.tableView.dataSource = self.dataSource;
}


- (void)setupObservers {    
    [self.dataSource addObserver:self
                      forKeyPath:@"storageController.countOfPictures"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
}


#pragma mark - LifeCycle
- (void)loadView {
    [super loadView];
    
    [self setupTableViewDataSource];
    [self setupObservers];
    self.tableView.delegate = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"PMOPictureTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PictureCell"];

    self.tableView.hidden = true;
    [self.view startSpinner];

}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - Observer triggers
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"storageController.countOfPictures"]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.view stopSpinner];
            self.tableView.hidden=false;
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedModellController = [self.dataSource modellControllerAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ShowImage" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowImage"]) {
        PMOImageViewController *destinationVC = segue.destinationViewController;
        if (self.selectedModellController) {
            destinationVC.modellController = self.selectedModellController;
        }
    }
}

@end
