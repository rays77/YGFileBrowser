//
//  YGFileBrowserController.h
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#import <UIKit/UIKit.h>
@class CJFileObjModel;

@protocol FileSelectVcDelegate <NSObject>

@required
///点击发送的事件
- (void)fileViewControlerSelected:(NSArray <CJFileObjModel *> *_Nullable)fileModels; /**< 点击发送的事件 */

@end


@interface YGFileBrowserController : UIViewController

@property (nonatomic,weak) _Nullable id <FileSelectVcDelegate> fileSelectVcDelegate;
/// 文件选择限制，默认无限制，如：[@"png", @"docx"]
@property (nonatomic,strong) NSArray * _Nullable typeLimits; /**< 文件选择限制，默认无限制，如：[@"png", @"docx"] */
/// 整体向下偏移，默认0
@property (nonatomic,assign) CGFloat offsetY; /**< 整体向下偏移，默认0 */
/// 文件选择的最大个数，默认无限制
@property (nonatomic,assign) NSInteger maxSelect; /**< 文件选择的最大个数，默认无限制 */
/// 选择单个文件的大小，默认无限制，单位B，5000000 = 5MB
@property (nonatomic,assign) CGFloat maxFileSize; /**< 选择单个文件的大小，默认无限制，单位B，5000000 = 5MB */

@end
