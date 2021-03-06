//
//  YGFileTableView.h
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class CJFileObjModel;

@protocol FileTableViewDelegate <NSObject>

@optional
- (void)fileTableView:(UITableView *_Nullable)tableView didSelect:(NSIndexPath *_Nullable)indexPath;
- (void)fileTableView:(UITableView *_Nullable)tableView selectModel:(CJFileObjModel *_Nullable)model cellButton:(UIButton *_Nullable)btn;
- (void)fileTableView:(UITableView *_Nullable)tableView deleteModel:(CJFileObjModel *_Nullable)model deleteIndexPath:(NSIndexPath *_Nullable)indexPath;

@end


@interface YGFileTableView : UITableView

@property (nonatomic, weak) _Nullable id <FileTableViewDelegate>fileTableViewDelegate;

@property (nonatomic, strong) PHVideoRequestOptions * _Nullable options_video;

@property (nonatomic, strong) PHImageRequestOptions * _Nullable options_image;

@property (nonatomic, strong) PHFetchResult<PHAsset *> * _Nullable assets;

@property (nonatomic, strong) NSMutableArray *_Nullable dataItems;

@end
