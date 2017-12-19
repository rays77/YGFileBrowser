//
//  YGFileTool.h
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#import <Foundation/Foundation.h>
@class CJFileObjModel;

@interface YGFileTool : NSObject

/// 加载本地相册
+ (void)loadPictureTypeLimits:(NSArray *)typeLimits
                      extract:(void(^)(CJFileObjModel *model))extract
                    completed:(void(^)(void))completed; /**< 加载本地相册 */

/// 加载本地视频
+ (void)loadVideoTypeLimits:(NSArray *)typeLimits
                    extract:(void(^)(CJFileObjModel *model))extract
                  completed:(void(^)(void))completed; /**< 加载本地视频 */

/// 获取文件正式路径:file:///user/name/df.JPG == /user/name/df.JPG
+ (NSString *)getPHImageFileURLPath:(NSString *)path; /**< 获取文件正式路径:file:///user/name/df.JPG == /user/name/df.JPG */

/// 获取文件大小
+ (NSString *)getBytesFromDataLength:(NSInteger)dataLength; /**< 获取文件大小 */

+ (BOOL)containsObject:(NSArray *)contains string:(NSString *)string;

@end
