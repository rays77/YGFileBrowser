//
//  UIImage+TYHSetting.m
//  TaiYangHua
//
//  Created by Lc on 15/12/25.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import "UIImage+TYHSetting.h"
#import "CJFileObjModel.h"
#import "NSBundle+YGFileBrowser.h"
#import "YGFileBrowser.h"

@implementation UIImage (TYHSetting)

+ (UIImage *)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//+ (UIImage *)imageWithModel:(CJSession * )session
//{
//    return <#expression#>
//}

+ (UIImage *)imageWithFileModel:(CJFileObjModel *)model
{
    NSArray *textTypesArray = [NSArray arrayWithObjects: TEXT_TYPES count: TEXT_TYPES_COUNT];
    NSArray *viceViodeArray = [NSArray arrayWithObjects: VIOCEVIDIO_TYPES count: VIOCEVIDIO_COUNT];
    NSArray *appViodeArray = [NSArray arrayWithObjects: Application_types count: Application_count];
    NSArray *AVArray = [NSArray arrayWithObjects: AV_TYPES count: AV_COUNT];

    if([textTypesArray containsObject: [model.filePath pathExtension]]){
        model.fileType = MKFileTypeTxt;
        if (![[model.filePath pathExtension] compare:@"xls" options:NSCaseInsensitiveSearch] || ![[model.filePath pathExtension] compare:@"xlsx" options:NSCaseInsensitiveSearch]) {
            return [NSBundle yg_imageNamed:@"excel-文档@2x.png"];
        }
        if (![[model.filePath pathExtension] compare:@"pdf" options:NSCaseInsensitiveSearch]) {
            return [NSBundle yg_imageNamed:@"pdf-文档@2x.png"];
        }
        if (![[model.filePath pathExtension] compare:@"txt" options:NSCaseInsensitiveSearch]) {
            return [NSBundle yg_imageNamed:@"txt-文档@2x.png"];
        }
        if (![[model.filePath pathExtension] compare:@"doc" options:NSCaseInsensitiveSearch] || ![[model.filePath pathExtension] compare:@"docx" options:NSCaseInsensitiveSearch]) {
            return [NSBundle yg_imageNamed:@"word-文档@2x.png"];
        }
    }else if([viceViodeArray containsObject: [model.filePath pathExtension]] || [AVArray containsObject:[model.filePath pathExtension]]){
        model.fileType = MKFileTypeAudioVidio;
        if ([viceViodeArray containsObject: [model.filePath pathExtension]]) {
            return [NSBundle yg_imageNamed:@"音乐@2x.png"];
        }else{
            return [NSBundle yg_imageNamed:@"视频@2x.png"];
        }
    }
    else if([appViodeArray containsObject: [model.filePath pathExtension]]){
        model.fileType = MKFileTypeApplication;
        return  [NSBundle yg_imageNamed: @"未知问题-本机@2x.png"];
    }else{
        model.fileType = MKFileTypeUnknown;
        if (![[model.filePath pathExtension] compare:@"rar" options:NSCaseInsensitiveSearch] || ![[model.filePath pathExtension] compare:@"zip" options:NSCaseInsensitiveSearch]) {
            return  [NSBundle yg_imageNamed:@"rar-其他@2x.png"];
        } else if (![[model.filePath pathExtension] compare:@"htlm" options:NSCaseInsensitiveSearch]){
            return  [NSBundle yg_imageNamed:@"rar-其他@2x.png"];
        } else{
            return  [NSBundle yg_imageNamed:@"未知问题-本机@2x.png"];
        }
    }
    return nil;
}
+ (UIImage *)imageWithFileModelOnCheck:(CJFileObjModel *)model
{
    NSArray *textTypesArray = [NSArray arrayWithObjects: TEXT_TYPES count: TEXT_TYPES_COUNT];
    NSArray *viceViodeArray = [NSArray arrayWithObjects: VIOCEVIDIO_TYPES count: VIOCEVIDIO_COUNT];
    NSArray *appViodeArray = [NSArray arrayWithObjects: Application_types count: Application_count];
    NSArray *AVArray = [NSArray arrayWithObjects: AV_TYPES count: AV_COUNT];

    if([textTypesArray containsObject: [model.fileUrl pathExtension]]){
        model.fileType = MKFileTypeTxt;
        if (![[model.fileUrl pathExtension] compare:@"xls" options:NSCaseInsensitiveSearch] || ![[model.fileUrl pathExtension] compare:@"xlsx" options:NSCaseInsensitiveSearch]) {
            return  [NSBundle yg_imageNamed:@"excel-文件详情@2x.png"];
        }
        if (![[model.fileUrl pathExtension] compare:@"pdf" options:NSCaseInsensitiveSearch]) {
            return[NSBundle yg_imageNamed:@"pdf-文件详情@2x.png"];
        }
        if (![[model.fileUrl pathExtension] compare:@"txt" options:NSCaseInsensitiveSearch]) {
            return[NSBundle yg_imageNamed:@"txt-文件详情@2x.png"];
        }
        if (![[model.fileUrl pathExtension] compare:@"doc" options:NSCaseInsensitiveSearch] || ![[model.fileUrl pathExtension] compare:@"docx" options:NSCaseInsensitiveSearch]) {
            return [NSBundle yg_imageNamed:@"word-文件详情@2x.png"];
        }
    }else if([viceViodeArray containsObject: [model.fileUrl pathExtension]] || [AVArray containsObject:[model.fileUrl pathExtension]]){
        model.fileType = MKFileTypeAudioVidio;
        if ([viceViodeArray containsObject: [model.fileUrl pathExtension]]) {
            return[NSBundle yg_imageNamed:@"音乐-文件详情@2x.png"];
        }else{
            return [NSBundle yg_imageNamed:@"视频-文件详情@2x.png"];
        }
    }
    else if([appViodeArray containsObject: [model.fileUrl pathExtension]]){
        model.fileType = MKFileTypeApplication;
        return  [NSBundle yg_imageNamed:@"未知应用-文件详情@2x.png"];
    }else{
        model.fileType = MKFileTypeUnknown;
        if (![[model.fileUrl pathExtension] compare:@"rar" options:NSCaseInsensitiveSearch] || ![[model.fileUrl pathExtension] compare:@"zip" options:NSCaseInsensitiveSearch]) {
            return  [NSBundle yg_imageNamed:@"rar-文件详情@2x.png"];
        } else if (![[model.fileUrl pathExtension] compare:@"htlm" options:NSCaseInsensitiveSearch]){
            return  [NSBundle yg_imageNamed:@"rar-文件详情@2x.png"];
        } else{
            return  [NSBundle yg_imageNamed:@"未知应用-文件详情@2x.png"];
        }
    }
    return nil;
}
@end
