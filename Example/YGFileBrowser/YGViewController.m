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
    vc.fileSelectVcDelegate = self;
    vc.typeLimits = @[@"png", @"PNG", @"jpg", @"JPG", @"jpeg", @"JPEG", @"docx"];
    vc.offsetY = 64;
    vc.maxSelect = 5;
    vc.maxFileSize = 1572864;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - FileSelectVcDelegate

- (void)fileViewControlerSelected:(NSArray<CJFileObjModel *> *)fileModels
{
    NSLog(@"fileModels----%@", fileModels);
}

@end
