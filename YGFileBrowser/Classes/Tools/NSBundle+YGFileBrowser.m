//
//  NSBundle+YGFileBrowser.m
//
//  Created by YG on 16/6/13.
//  Copyright © 2016年 wuyiguang. All rights reserved.
//

#import "NSBundle+YGFileBrowser.h"
#import "VeFileViewCell.h"

@implementation NSBundle (YGFileBrowser)
+ (instancetype)yg_bundle
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[VeFileViewCell class]] pathForResource:@"YGFileBrowser" ofType:@"bundle"]];
    }
    return bundle;
}

+ (UIImage *)yg_imageNamed:(NSString *)name
{
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self yg_bundle] pathForResource:name ofType:nil]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return image;
}

@end
