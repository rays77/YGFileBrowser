//
//  NSBundle+YGFileBrowser.h
//
//  Created by YG on 16/6/13.
//  Copyright © 2016年 wuyiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

//文件默认存储的路径/Inbox路径
//#define HomeFilePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CJFileCache1"]
#define HomeFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Inbox"]
#define YGFileCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"YGFileCache"]

@interface NSBundle (YGFileBrowser)
+ (instancetype)yg_bundle;
+ (UIImage *)yg_imageNamed:(NSString *)name;
@end
