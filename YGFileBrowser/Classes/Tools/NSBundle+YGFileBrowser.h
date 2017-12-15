//
//  NSBundle+YGFileBrowser.h
//
//  Created by YG on 16/6/13.
//  Copyright © 2016年 wuyiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (YGFileBrowser)
+ (instancetype)yg_bundle;
+ (UIImage *)yg_imageNamed:(NSString *)name;
@end
