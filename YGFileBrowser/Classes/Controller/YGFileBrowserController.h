//
//  YGFileBrowserController.h
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#import <UIKit/UIKit.h>
#import "CJFileObjModel.h"

@protocol FileSelectVcDelegate <NSObject>

@required
///点击发送的事件
- (void)fileViewControlerSelected:(NSArray <CJFileObjModel *> *_Nullable)fileModels; /**< 点击发送的事件 */

@end


@interface YGFileBrowserController : UIViewController

@property (nonatomic,weak) _Nullable id <FileSelectVcDelegate> fileSelectVcDelegate;
/// 允许显示的文件类型，默认无限制(不能和 typeLimits 同时使用)
@property (nonatomic,strong) NSArray * _Nullable allowTypes;
/// 文件选择限制，默认无限制(不能和 allowTypes 同时使用)，如：[@"png", @"docx"]
@property (nonatomic,strong) NSArray * _Nullable typeLimits; /**< 文件选择限制，默认无限制，如：[@"png", @"docx"] */
/// 减去导航高度
@property (nonatomic,assign) BOOL minusNavHeight; /**< 减去导航高度 */
/// 整体向下偏移，默认0
@property (nonatomic,assign) CGFloat offsetY; /**< 整体向下偏移，默认0 */
/// 文件选择的最大个数，默认无限制
@property (nonatomic,assign) NSInteger maxSelect; /**< 文件选择的最大个数，默认无限制 */
/// 选择单个文件的大小，默认无限制，单位B，5000000 = 5MB
@property (nonatomic,assign) CGFloat maxFileSize; /**< 选择单个文件的大小，默认无限制，单位B，5000000 = 5MB */

@end
