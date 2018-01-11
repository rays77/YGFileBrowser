//
//  YGFileTool.h
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class CJFileObjModel;

@interface YGFileTool : NSObject

/**
 进入app设置页面
 */
+ (void)openAppSettings;

/**
 获取相册权限
 @param handler 获取权限结果
 */
+ (void)requestPhotosLibraryAuthorization:(void(^_Nullable)(BOOL ownAuthorization))handler;

/**
 加载本地相册
 */
+ (void)loadPictureTypeLimits:(NSArray *_Nullable)typeLimits
                      extract:(void(^_Nullable)(CJFileObjModel * _Nullable model))extract
                    completed:(void(^_Nullable)(void))completed; /**< 加载本地相册 */

/**
 加载本地视频
 */
+ (void)loadVideoTypeLimits:(NSArray *_Nullable)typeLimits
                    extract:(void(^_Nullable)(CJFileObjModel * _Nullable model))extract
                  completed:(void(^_Nullable)(void))completed; /**< 加载本地视频 */

/// 加载附件
+ (void)request:(PHAsset *_Nullable)asset size:(CGSize)size
          model:(PHImageContentMode)model
        options:(nullable id)options
  resultHandler:(nonnull void (^)(UIImage * _Nullable image, AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info))resultHandler; /**< 加载附件 */

/// 获取文件正式路径:file:///user/name/df.JPG == /user/name/df.JPG
+ (NSString *_Nullable)getPHImageFileURLPath:(NSString *_Nullable)path; /**< 获取文件正式路径:file:///user/name/df.JPG == /user/name/df.JPG */

/// 获取文件大小
+ (NSString *_Nullable)getBytesFromDataLength:(NSInteger)dataLength; /**< 获取文件大小 */

+ (BOOL)containsObject:(NSArray *_Nullable)contains string:(NSString *_Nullable)string;

@end
