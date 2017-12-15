//
//  YGFileVideoController.m
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//
//  视频

#import "YGFileVideoController.h"
#import "YGFileTool.h"

@interface YGFileVideoController ()

@property (nonatomic, assign) BOOL isCompleted;

@end

@implementation YGFileVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)loadData {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    [YGFileTool loadVideoTypeLimits:self.typeLimits
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
