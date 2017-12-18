//
//  YGFileTool.m
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#import "YGFileTool.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CJFileObjModel.h"
#import "MJExtension.h"

@implementation YGFileTool

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
                    
                    //请求图片
                    PHImageRequestOptions *imageOption = [[PHImageRequestOptions alloc] init];
                    imageOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                    imageOption.resizeMode = PHImageRequestOptionsResizeModeFast;
                    
                    [manager requestImageForAsset:asset targetSize:CGSizeMake(70, 70) contentMode:PHImageContentModeAspectFill options:imageOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        
                        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
                        
                        if (downloadFinined && result) {
                            //准确获取原图大小
                            [manager requestImageDataForAsset:asset options:imageOption resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
                                if (downloadFinined && imageData) {
//                                    model.filePath = [NSString stringWithFormat:@"%@", [info objectForKey:@"PHImageFileURLKey"]];
                                    model.fileSizefloat = imageData.length;
                                    model.fileSize = [self getBytesFromDataLength:model.fileSizefloat];
                                    model.image = result;
                                    model.fileData = UIImageJPEGRepresentation(result,0.5);
                                    model.name = [[NSString stringWithFormat:@"%@", [info objectForKey:@"PHImageFileURLKey"]] lastPathComponent];
                                    model.allowEdite = NO;
//                                    [self.albumPic addObject:model];
                                    
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
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
            
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
                
                [manager requestImageForAsset:obj targetSize:CGSizeMake(80, 80) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    model.image = result;
                }];
                [manager requestAVAssetForVideo:obj options:options resultHandler:^(AVAsset * asset, AVAudioMix * audioMix, NSDictionary * info) {
                    
                    NSArray *tracks = asset.tracks;
                    
                    for (AVAssetTrack * track in tracks) {
                        float rate = ([track estimatedDataRate] / 8); // convert bits per second to bytes per second
                        float seconds = CMTimeGetSeconds([track timeRange].duration);
                        model.fileSizefloat += seconds * rate;
                    }
                    
//                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
//                    model.fileUrl =  [urlAsset.URL absoluteString];
                    
                    model.fileSize = [NSString stringWithFormat:@"%.2lfM",model.fileSizefloat / 1024 / 1024];
                    
                    model.name = [asset mj_keyValues][@"propertyListForProxy"][@"name"];
                    
                    model.fileData = [asset mj_keyValues][@"propertyListForProxy"][@"moop"];
                    
                    model.allowEdite = NO;
                    
//                    [self.videoArray addObject:model];
                    
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

#pragma mark - Tool

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
