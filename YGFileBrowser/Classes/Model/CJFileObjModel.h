//
//  FileObjModel.h
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//  文件模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger, MKFileType) {
    MKFileTypeUnknown = -1, //其他
    MKFileTypeAll = 0, //所有
    MKFileTypeImage = 1, //图片
    MKFileTypeTxt = 2, //文档
    MKFileTypeAudioVidio = 3, //音乐视频
    MKFileTypeApplication = 4, //应用
    MKFileTypeDirectory = 5, //目录
    MKFileTypeSandboxImage = 6, //沙盒图片
};

@interface CJFileObjModel : NSObject

-(instancetype)initWithFilePath:(NSString *)filePath typeLimits:(NSArray *)typeLimits;

+ (NSString *)getBytesFromDataLength:(NSInteger)dataLength;

@property (copy, nonatomic) NSString *filePath; //文件路径
@property (copy, nonatomic) NSString *fileUrl; //文件URL

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *fileSize;
@property (nonatomic, assign) CGFloat fileSizefloat;

@property (copy,nonatomic) NSData *fileData;
@property (copy, nonatomic) NSString *creatTime;

@property (strong, nonatomic) UIImage *image; //图标

@property (strong, nonatomic) PHAsset *asset; //相册图片、视频 asset

@property (assign, nonatomic) MKFileType fileType;
@property (nonatomic,strong) NSArray *typeLimits;//类型限制
@property (nonatomic,assign) BOOL allowEdite;//是否允许编辑（删除）
@property (nonatomic,assign) BOOL allowSelect;//是否允许被选择
@property (nonatomic,assign) BOOL select;//是否被选中

@end
