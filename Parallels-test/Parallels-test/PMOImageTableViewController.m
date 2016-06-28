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
#import "PMOImageTableViewDelegate.h"
#import "PMOSettingsURLs.h"

@interface PMOImageTableViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PMOImageTableViewDataSource *dataSource;
@property (strong, nonatomic) PMOPictureModellController *selectedModellController;
@property (strong, nonatomic) PMOImageTableViewDelegate *tableDelegate;

@end

@implementation PMOImageTableViewController

@dynamic view;

#pragma mark - Accessors
- (NSString *)JSONFileURLAsString {
    if (!_JSONFileURLAsString) {
        _JSONFileURLAsString = kJSONURLAsString;
    }
    
    return _JSONFileURLAsString;
}

- (NSString *)baseImageURLAsString {
    if (!_baseImageURLAsString) {
        _baseImageURLAsString = kDataBaseURLAsString;
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


- (void)setupTableViewDelegate {
    
    self.tableDelegate = [[PMOImageTableViewDelegate alloc] init];
    self.tableDelegate.tableViewController = self;
    self.tableDelegate.dataSource = self.dataSource;
    self.tableView.delegate = self.tableDelegate;
}


#pragma mark - LifeCycle
- (void)loadView {
    [super loadView];
    
    [self setupTableViewDataSource];
    [self setupTableViewDelegate];
    [self setupObservers];
;
    
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

#pragma mark - Observers and triggers
- (void)setupObservers {
    [self.dataSource addObserver:self
                      forKeyPath:@"storageController.countOfPictures"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"storageController.countOfPictures"]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.view stopSpinner];
            self.tableView.hidden=false;
            [self.tableView reloadData];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.tableDelegate prepareForSegue:segue sender:sender];
}




@end
