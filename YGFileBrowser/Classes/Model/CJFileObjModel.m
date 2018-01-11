//
//  FileObjModel.m
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import "CJFileObjModel.h"
#import "UIImage+TYHSetting.h"
#import "NSBundle+YGFileBrowser.h"
#import "YGFileBrowser.h"
#import "YGFileTool.h"

@implementation CJFileObjModel
{
    NSFileManager *fileMgr;
}

-(instancetype)init {
    if(self = [super init]) {
        fileMgr = [NSFileManager defaultManager];
    }
    return self;
}

-(instancetype)initWithFilePath:(NSString *)filePath typeLimits:(NSArray *)typeLimits {
    if(self = [self init]){
        self.typeLimits = typeLimits;
        self.filePath = filePath;
    }
    return self;
}

-(void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    _fileUrl = _filePath;
    
    // 判断文件类型是否允许cell勾选，包含就不允许勾选
    self.allowSelect = ![YGFileTool containsObject:self.typeLimits string:[filePath pathExtension]];
    
    self.name = [filePath lastPathComponent];
    
    BOOL isDirectory = true;
    [fileMgr fileExistsAtPath: filePath isDirectory: &isDirectory];
    self.image = [NSBundle yg_imageNamed:@"未知问题-本机@2x.png"];
    self.fileType = MKFileTypeUnknown;
    
    if(isDirectory){
        self.image = [NSBundle yg_imageNamed:@"未知问题-本机@2x.png"];
        self.fileType = MKFileTypeDirectory;
    }else{
        
        NSArray *imageTypesArray = [NSArray arrayWithObjects: IMAGES_TYPES count: IMAGES_TYPES_COUNT];
        
        if([YGFileTool containsObject:imageTypesArray string:[filePath pathExtension]]){
            self.image = [UIImage imageWithContentsOfFile: filePath];
            self.fileType = MKFileTypeUnknown;
        }else {
            self.image = [UIImage imageWithFileModel:self];
        }
        
        NSError *error = nil;
        NSDictionary *fileAttributes = [fileMgr attributesOfItemAtPath:filePath error:&error];
        
        if (fileAttributes != nil) {
            NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
            NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
            NSDate *fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
            if (fileSize) {
                CGFloat size = [fileSize unsignedLongLongValue];
                self.fileSizefloat = size;
                NSString *sizestr = [NSString stringWithFormat:@"%qi",[fileSize unsignedLongLongValue]];
                //            NSLog(@"File size: %@\n",fileSize);
                if (sizestr.length <=3) {
                    self.fileSize = [NSString stringWithFormat:@"%.1f B",size];
                } else if(sizestr.length>3 && sizestr.length<7){
                    self.fileSize = [NSString stringWithFormat:@"%.1f KB",size/1000.0];
                }else{
                    self.fileSize = [NSString stringWithFormat:@"%.1f M",size/(1000.0 * 1000)];
                }
            }
            
            if (fileModDate) {
                //用于格式化NSDate对象
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //设置格式：zzz表示时区
                [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
                //NSDate转NSString
                self.creatTime = [dateFormatter stringFromDate:fileModDate];
            }
            if (fileCreateDate) {
                //            NSLog(@"create date:%@\n", fileModDate);
            }
        }
        else {
            //        NSLog(@"Path (%@) is invalid.", filePath);
        }
    }
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
