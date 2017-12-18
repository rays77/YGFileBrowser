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

@end

@implementation YGFileAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self loadData];
}

- (void)loadData {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    [YGFileTool loadPictureTypeLimits:self.typeLimits
                              extract:^(CJFileObjModel *model) {
                                  [list addObject:model];
                              } completed:^{
                                  self.dataItems = list;
                              }];
}

@end
