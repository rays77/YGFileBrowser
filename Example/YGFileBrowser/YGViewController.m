//
//  YGViewController.m
//  YGFileBrowser
//
//  Created by rays77@163.com on 12/08/2017.
//  Copyright (c) 2017 rays77@163.com. All rights reserved.
//

#import "YGViewController.h"
#import "YGFileBrowserController.h"

@interface YGViewController () <FileSelectVcDelegate>

@end

@implementation YGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)file:(UIButton *)sender {
    YGFileBrowserController *vc = [[YGFileBrowserController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.fileSelectVcDelegate = self;
    vc.typeLimits = @[@"png", @"jpg", @"jpeg", @"docx", @"mp4"];
    vc.offsetY = [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.frame.size.height;
    vc.maxSelect = 5;
    vc.maxFileSize = 3145728; //3M 限制
    [self.navigationController pushViewController:vc animated:YES];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - FileSelectVcDelegate

- (void)fileViewControlerSelected:(NSArray<CJFileObjModel *> *)fileModels
{
    NSLog(@"fileModels----%@", fileModels);
}

@end
