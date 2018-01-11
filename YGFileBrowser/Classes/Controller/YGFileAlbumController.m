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
 
    // 请求授权
    [YGFileTool requestPhotosLibraryAuthorization:^(BOOL ownAuthorization) {
        if (ownAuthorization) {
            //action
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getAllPhotosFromAlbum];
            });
        } else {
            //提示可到设置页面获取权限
            [YGFileManagerController showAlter:self];
        }
    }];
}

//从系统中捕获所有相片
- (void)getAllPhotosFromAlbum {
    
    self.options_image = [[PHImageRequestOptions alloc] init];//请求选项设置
    
    self.options_image.resizeMode = PHImageRequestOptionsResizeModeExact;//自定义图片大小的加载模式
    self.options_image.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.options_image.synchronous = YES;//是否同步加载
    
    // 排序
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    //容器类
    self.assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option]; //得到所有图片
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
    
    [YGFileTool loadPictureTypeLimits:self.typeLimits
                              extract:^(CJFileObjModel *model) {
                                  [list addObject:model];
                              } completed:^{
                                  self.dataItems = list;
                              }];
}

@end
