//
//  ViewController.h
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJFileObjModel;

@protocol FileSelectVcDelegate <NSObject>
@required
//点击发送的事件
- (void)fileViewControlerSelected:(NSArray <CJFileObjModel *> *)fileModels;
@end


@interface CJFileManagerVC : UIViewController
@property (nonatomic,weak) id<FileSelectVcDelegate> fileSelectVcDelegate;
@property (nonatomic,assign) CGFloat offsetY; /**< 整体向下偏移，默认0 */
@property (nonatomic,assign) NSInteger maxSelect; /**< 文件选择的最大个数，默认无限制 */
@property (nonatomic,assign) CGFloat maxFileSize; /**< 选择单个文件的大小，默认无限制，单位B，5000000 = 5MB */
@end
