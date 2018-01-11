//
//  YGFileTool.m
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#import "YGFileTool.h"
#import "CJFileObjModel.h"
#import "MJExtension.h"

@implementation YGFileTool

/**
 获取相册权限
 @param handler 获取权限结果
 */
+ (void)requestPhotosLibraryAuthorization:(void(^)(BOOL ownAuthorization))handler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (handler) {
            BOOL boolean = false;
            if (status == PHAuthorizationStatusAuthorized) {
                boolean = true;
            }
            handler(boolean);
        }
    }];
}

/**
 进入app设置页面
 */
+ (void)openAppSettings {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSLog(@"无法打开设置");
    }
}

+ (void)loadPictureTypeLimits:(NSArray *)typeLimits extract:(void (^)(CJFileObjModel *))extract completed:(void (^)(void))completed {
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author ==PHAuthorizationStatusDenied) {
        //无权限
    }else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            //根据图片的创建时间升序排列
            PHFetchResult *imageResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
            
            PHImageManager *manager = [PHImageManager defaultManager];
            
            if ([imageResult count] <= 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completed();
                });
            }
            
            [imageResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //多一层判断,容错处理
                if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
                    PHAsset *asset = obj;
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
                    CJFileObjModel *model = [[CJFileObjModel alloc] init];
                    model.typeLimits = typeLimits;
                    model.creatTime = [dateFormatter stringFromDate:asset.creationDate];
                    model.asset = asset;
                    //请求图片
                    PHImageRequestOptions *imageOption = [[PHImageRequestOptions alloc] init];
                    imageOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                    imageOption.resizeMode = PHImageRequestOptionsResizeModeExact;
                    
                    [manager requestImageForAsset:asset targetSize:CGSizeMake(140, 140) contentMode:PHImageContentModeAspectFill options:imageOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        
                        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
                        
                        if (downloadFinined && result) {
                            //准确获取原图大小
                            [manager requestImageDataForAsset:asset options:imageOption resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
                                if (downloadFinined && imageData) {
//                                    model.filePath = [[info objectForKey:@"PHImageFileURLKey"] absoluteString];
                                    model.fileSizefloat = imageData.length;
                                    model.fileSize = [self getBytesFromDataLength:model.fileSizefloat];
                                    model.image = result;
                                    model.fileData = UIImageJPEGRepresentation(result,0.5);
                                    model.name = [[NSString stringWithFormat:@"%@", [info objectForKey:@"PHImageFileURLKey"]] lastPathComponent];
                                    
                                    model.allowEdite = NO;
                                    
                                    NSString *filePath = [NSString stringWithFormat:@"%@", [info objectForKey:@"PHImageFileURLKey"]];
                                    
                                    model.allowSelect = ![YGFileTool containsObject:typeLimits string:[filePath pathExtension]];
                                    
                                    // 提取数据
                                    if (extract) {
                                        extract(model);
                                    }

                                    // 提取完成
                                    if (completed && ([imageResult count] - 1) == idx) {
                                        completed();
                                    }
                                }
                            }];
                        }
                    }];
                }
            }];
        });
    }
}

+ (void)loadVideoTypeLimits:(NSArray *)typeLimits extract:(void (^)(CJFileObjModel *))extract completed:(void (^)(void))completed {
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author ==PHAuthorizationStatusDenied) {
        //无权限
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //这里用PHAsset来获取视频数据 ALAsset显得很无力了。。。
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *voideResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:option];
            PHImageManager *manager = [PHImageManager defaultManager];
            // 视频请求对象
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            
            if ([voideResult count] <= 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completed();
                });
            }
            
            [voideResult enumerateObjectsUsingBlock:^(PHAsset *obj, NSUInteger idx, BOOL *stop) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
                CJFileObjModel *model = [[CJFileObjModel alloc] init];
                model.typeLimits = typeLimits;
                model.creatTime = [dateFormatter stringFromDate:obj.creationDate];
                model.asset = obj;
                
                [manager requestImageForAsset:obj targetSize:CGSizeMake(160, 160) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    model.image = result;
                }];
                [manager requestAVAssetForVideo:obj options:options resultHandler:^(AVAsset * asset, AVAudioMix * audioMix, NSDictionary * info) {
                    
                    NSArray *tracks = asset.tracks;
                    
                    for (AVAssetTrack * track in tracks) {
                        float rate = ([track estimatedDataRate] / 8); // convert bits per second to bytes per second
                        float seconds = CMTimeGetSeconds([track timeRange].duration);
                        model.fileSizefloat += seconds * rate;
                    }
                    
                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
//                    model.fileUrl =  [urlAsset.URL absoluteString];
                    
                    model.fileSize = [NSString stringWithFormat:@"%.2lfM",model.fileSizefloat / 1024 / 1024];
                    
//                    model.name = [asset mj_keyValues][@"propertyListForProxy"][@"name"];
                    model.name = [[urlAsset.URL absoluteString] lastPathComponent];
              
//                    model.fileData = [asset mj_keyValues][@"propertyListForProxy"][@"moop"];
                    
                    model.allowEdite = NO;
                    
                    model.allowSelect = ![YGFileTool containsObject:typeLimits string:[[urlAsset.URL absoluteString] pathExtension]];
                    
                    // 提取数据
                    if (extract) {
                        extract(model);
                    }
                    
                    // 提取完成
                    if (completed && ([voideResult count] - 1) == idx) {
                        completed();
                    }
                }];
            }];
        });
    }
}

+ (void)request:(PHAsset *)asset size:(CGSize)size model:(PHImageContentMode)model options:(nullable id)options resultHandler:(nonnull void (^)(UIImage * _Nullable image, AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info))resultHandler
{
    PHImageManager *manager = [PHImageManager defaultManager];
    
    if (asset.mediaType == PHAssetMediaTypeImage) {
        [manager requestImageForAsset:asset targetSize:size contentMode:model options:options resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
            resultHandler(image, nil, nil, info);
        }];
    } else {
        [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            resultHandler(nil, asset, audioMix, info);
        }];
    }
}

#pragma mark - Tool

+ (BOOL)containsObject:(NSArray *)contains string:(NSString *)string {
    if (contains.count <= 0) {
        return NO;
    }
    
    if (string == nil || string.length <= 0 || string == (id)(kCFNull)) {
        return NO;
    }
    
    __block BOOL contain = NO;
    [contains enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([string compare:obj options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame) {
            contain = YES;
            *stop = YES;
        }
    }];
    
    return contain;
}

+ (NSString *)getPHImageFileURLPath:(NSString *)path {
    NSArray *pathList = [path componentsSeparatedByString:@"//"];
    if (pathList.count > 1) {
        return pathList[1];
    }
    return path;
}

+ (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB",dataLength];
    }
    return bytes;
}

@end
