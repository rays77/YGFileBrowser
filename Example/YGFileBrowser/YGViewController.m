//
//  YGViewController.m
//  YGFileBrowser
//
//  Created by rays77@163.com on 12/08/2017.
//  Copyright (c) 2017 rays77@163.com. All rights reserved.
//

#import "YGViewController.h"
#import "YGFileBrowserController.h"
#import "YGFileTool.h"

@interface YGViewController () <FileSelectVcDelegate>

@end

@implementation YGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)file:(UIButton *)sender {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    
    YGFileBrowserController *vc = [[YGFileBrowserController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.fileSelectVcDelegate = self;
    vc.typeLimits = @[@"docx", @"mp4"];
    vc.offsetY = [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.frame.size.height;
    vc.maxSelect = 10;
    vc.maxFileSize = 3145728; //3M 限制
    [self.navigationController pushViewController:vc animated:YES];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - FileSelectVcDelegate

- (void)fileViewControlerSelected:(NSArray<CJFileObjModel *> *)fileModels
{
    NSLog(@"fileModels----%@", fileModels);
    
//    for (int i = 0; i < fileModels.count; i++) {
//        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.frame = CGRectMake(10, (80+10) * i + 70, 80, 80);
//        imageView.image = fileModels[i].image;
//        [self.view addSubview:imageView];
//    }
    

    [fileModels enumerateObjectsUsingBlock:^(CJFileObjModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(10, (80+10) * idx + 70, 80, 80);
        if (obj.asset && obj.asset.mediaType == PHAssetMediaTypeImage) {
            //请求图片
            PHImageRequestOptions *imageOption = [[PHImageRequestOptions alloc] init];
            imageOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            imageOption.resizeMode = PHImageRequestOptionsResizeModeExact;
            
            [YGFileTool request:obj.asset size:CGSizeMake(1242, 2208) model:PHImageContentModeAspectFit options:imageOption resultHandler:^(UIImage * _Nullable image, AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                
                if (image) {
                    imageView.image = image;
                }
            }];
            [self.view addSubview:imageView];
        } else {
           
        }
    }];
}

@end
