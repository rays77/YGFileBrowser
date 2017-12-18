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

@end

@implementation YGFileVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

- (void)loadData {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    [YGFileTool loadVideoTypeLimits:self.typeLimits
                            extract:^(CJFileObjModel *model) {
                                [list addObject:model];
                            } completed:^{
                                self.dataItems = list;
                            }];
}

@end
