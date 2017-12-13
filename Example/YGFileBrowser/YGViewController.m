//
//  YGViewController.m
//  YGFileBrowser
//
//  Created by rays77@163.com on 12/08/2017.
//  Copyright (c) 2017 rays77@163.com. All rights reserved.
//

#import "YGViewController.h"
#import "CJFileManagerVC.h"

@interface YGViewController () <FileSelectVcDelegate>

@end

@implementation YGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)file:(UIButton *)sender {
    CJFileManagerVC *vc = [[CJFileManagerVC alloc] init];
    vc.fileSelectVcDelegate = self;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
