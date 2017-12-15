//
//  YGFileBrowser.h
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#ifndef YGFileBrowser_h
#define YGFileBrowser_h

static const UInt8 IMAGES_TYPES_COUNT = 8;
static const UInt8 TEXT_TYPES_COUNT = 14;
static const UInt8 VIOCEVIDIO_COUNT = 14;
static const UInt8 Application_count = 4;
static const UInt8 AV_COUNT = 12;

static const NSString *IMAGES_TYPES[IMAGES_TYPES_COUNT] = {@"png", @"PNG", @"jpg",@"JPG", @"jpeg", @"JPEG" ,@"gif", @"GIF"};
static const NSString *TEXT_TYPES[TEXT_TYPES_COUNT] = {@"txt", @"TXT", @"doc",@"DOC",@"docx",@"DOCX",@"xls",@"XLS", @"xlsx",@"XLSX",@"ppt",@"PPT",@"pdf",@"PDF"};
static const NSString *VIOCEVIDIO_TYPES[VIOCEVIDIO_COUNT] = {@"mp3",@"MP3",@"wav",@"WAV",@"CD",@"cd",@"ogg",@"OGG",@"midi",@"MIDE",@"vqf",@"VQF",@"amr",@"AMR"};
static const NSString *AV_TYPES[AV_COUNT] = {@"asf",@"ASF",@"wma",@"WMA",@"rm",@"RM",@"rmvb",@"RMVB",@"avi",@"AVI",@"mkv",@"MKV"};
static const NSString *Application_types[Application_count] = {@"apk",@"APK",@"ipa",@"IPA"};

///屏幕高度/宽度
#define CJScreenWidth        [UIScreen mainScreen].bounds.size.width
#define CJScreenHeight       [UIScreen mainScreen].bounds.size.height

//文件默认存储的路径/Inbox路径
//#define HomeFilePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CJFileCache1"]
#define HomeFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Inbox"]
#define YGFileCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"YGFileCache"]

#endif /* YGFileBrowser_h */
