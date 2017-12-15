//
//  YGFileManagerController.h
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#import <UIKit/UIKit.h>
#import "YGFileTableView.h"
#import "YGFileBrowser.h"

@interface YGFileManagerController : UIViewController

@property (nonatomic, weak) _Nullable id <FileTableViewDelegate>fileTableViewDelegate;

@property (nonatomic, strong) NSArray * _Nullable typeLimits;

@property (nonatomic,strong) NSMutableArray * _Nullable dataItems;

- (void)nullData;

- (void)reloadData;

@end
