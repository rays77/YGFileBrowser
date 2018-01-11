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
    
    // 请求授权
    [YGFileTool requestPhotosLibraryAuthorization:^(BOOL ownAuthorization) {
        if (ownAuthorization) {
            //action
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getAllVideoFromAlbum];
            });
        } else {
            //提示可到设置页面获取权限
            [YGFileManagerController showAlter:self];
        }
    }];
    
//    [self loadData];
}

- (void)getAllVideoFromAlbum {
    
    self.options_video = [[PHVideoRequestOptions alloc] init];//请求选项设置
    
    self.options_video.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    // 排序
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    //容器类
    self.assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:option]; //得到所有图片
    /*
     PHAssetMediaType：
     PHAssetMediaTypeUnknown = 0,//在这个配置下，请求不会返回任何东西
     PHAssetMediaTypeImage   = 1,//图片
     PHAssetMediaTypeVideo   = 2,//视频
     PHAssetMediaTypeAudio   = 3,//音频
     */
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
