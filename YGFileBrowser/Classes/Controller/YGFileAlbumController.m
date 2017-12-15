//
//  YGFileAlbumController.m
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//
//  相册

#import "YGFileAlbumController.h"
#import "YGFileTool.h"

@interface YGFileAlbumController ()

@property (nonatomic, assign) BOOL isCompleted;

@end

@implementation YGFileAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

- (void)loadData {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    [YGFileTool loadPictureTypeLimits:self.typeLimits
                              extract:^(CJFileObjModel *model) {
                                  [list addObject:model];
                              } completed:^{
                                  self.isCompleted = YES;
                                  self.dataItems = list;
                              }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.dataItems.count <= 0 && !self.isCompleted) {
        [self loadData];
    }
}

@end
