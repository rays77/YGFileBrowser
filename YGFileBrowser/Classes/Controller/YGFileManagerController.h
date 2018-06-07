//
//  YGFileManagerController.h
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "YGFileTableView.h"
#import "YGFileBrowser.h"

@interface YGFileManagerController : UIViewController

@property (nonatomic, weak) _Nullable id <FileTableViewDelegate>fileTableViewDelegate;

@property (nonatomic, strong) PHVideoRequestOptions * _Nullable options_video;

@property (nonatomic, strong) PHImageRequestOptions * _Nullable options_image;

@property (nonatomic, strong) PHFetchResult<PHAsset *> * _Nullable assets;

/// 允许显示的文件类型，默认无限制(不能和 typeLimits 同时使用)
@property (nonatomic,strong) NSArray * _Nullable allowTypes;
    
@property (nonatomic, strong) NSArray * _Nullable typeLimits;

@property (nonatomic,strong) NSMutableArray * _Nullable dataItems;

+ (void)showAlter:(UIViewController *_Nonnull)preVC;

- (void)nullData;

- (void)reloadData;

@end
