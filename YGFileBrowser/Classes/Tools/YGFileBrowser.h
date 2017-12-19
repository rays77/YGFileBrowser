//
//  YGFileBrowser.h
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#ifndef YGFileBrowser_h
#define YGFileBrowser_h

static const UInt8 IMAGES_TYPES_COUNT = 4;
static const UInt8 TEXT_TYPES_COUNT = 7;
static const UInt8 VIOCEVIDIO_COUNT = 7;
static const UInt8 Application_count = 2;
static const UInt8 AV_COUNT = 6;

static const NSString *IMAGES_TYPES[IMAGES_TYPES_COUNT] = {@"png",@"jpg",@"jpeg",@"gif"};
static const NSString *TEXT_TYPES[TEXT_TYPES_COUNT] = {@"txt", @"doc",@"docx",@"xls",@"xlsx",@"ppt",@"pdf"};
static const NSString *VIOCEVIDIO_TYPES[VIOCEVIDIO_COUNT] = {@"mp3",@"wav",@"cd",@"ogg",@"midi",@"vqf",@"amr"};
static const NSString *AV_TYPES[AV_COUNT] = {@"asf",@"wma",@"rm",@"rmvb",@"avi",@"mkv"};
static const NSString *Application_types[Application_count] = {@"apk",@"ipa"};

///屏幕高度/宽度
#define CJScreenWidth        [UIScreen mainScreen].bounds.size.width
#define CJScreenHeight       [UIScreen mainScreen].bounds.size.height

///判断是否为iPhoneX
#define Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//文件默认存储的路径/Inbox路径
#define HomeFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Inbox"]
#define YGFileCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"YGFileCache"]

#endif /* YGFileBrowser_h */
