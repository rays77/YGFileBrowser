//
//  YGFileManagerController.m
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#import "YGFileManagerController.h"
#import "UIColor+CJColorCategory.h"
#import "NSBundle+YGFileBrowser.h"
#import "YGFileTableView.h"
#import "CJFlieLookUpVC.h"
#import "CJFileObjModel.h"
#import "UIView+CJToast.h"
#import "YGFileTool.h"
#import "Masonry.h"

@interface YGFileManagerController () <FileTableViewDelegate>

@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) YGFileTableView *tableView;
@property (nonatomic, strong) UIView *nullView;
@property (nonatomic, strong) UILabel *nullTitleLbl;

@property (nonatomic, strong) NSIndexPath *deleteIndxPath; // 记录删除的IndexPath
@property (nonatomic, strong) CJFileObjModel *deleteModel; // 记录删除的模型

@end

@implementation YGFileManagerController

+ (void)showAlter:(UIViewController *)preVC {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"尚未获取到相册权限" message:@"是否到设置处进行权限设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [YGFileTool openAppSettings];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alter dismissViewControllerAnimated:true completion:nil];
    }];
    [alter addAction:actionSure];
    [alter addAction:actionCancel];
    [preVC presentViewController:alter animated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableView];
    [self nullView];
}

- (UIAlertController *)alertController {
    if (_alertController == nil) {
        _alertController = [UIAlertController alertControllerWithTitle:@"删除本地文件后将无法找回，是否继续？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([self.fileTableViewDelegate respondsToSelector:@selector(fileTableView:deleteModel:deleteIndexPath:)]) {
                [self.fileTableViewDelegate fileTableView:self.tableView deleteModel:self.deleteModel deleteIndexPath:self.deleteIndxPath];
            }
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [_alertController addAction:deleteAction];
        [_alertController addAction:cancelAction];
    }
    return _alertController;
}

- (UIView *)nullView {
    if (_nullView == nil) {
        _nullView = [[UIView alloc] init];
        _nullView.backgroundColor = [UIColor clearColor];
        [self.tableView addSubview:_nullView];
        
        __weak typeof(self) weakSelf = self;
        [_nullView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(weakSelf.view);
            make.width.height.mas_equalTo(160);
        }];
        
        UIImage *image = [NSBundle yg_imageNamed:@"null数据.png"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(100, 100.5, 100, 100.5)];
        UIImageView *nullImage = [[UIImageView alloc] initWithImage:image];
        [_nullView addSubview:nullImage];
        
        [nullImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 30, 15));
        }];
        
        _nullTitleLbl = [[UILabel alloc] init];
        _nullTitleLbl.textColor = [UIColor colorWithHexString:@"8a8a8a"];
        _nullTitleLbl.font = [UIFont boldSystemFontOfSize:14];
        _nullTitleLbl.textAlignment = NSTextAlignmentCenter;
        _nullTitleLbl.text = @"正在加载文件...";
        [_nullView addSubview:_nullTitleLbl];
        
        [_nullTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(nullImage.mas_bottom).offset(0);
        }];
    }
    return _nullView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

#pragma mark - Getter & Setter

- (YGFileTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[YGFileTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.fileTableViewDelegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)setAssets:(PHFetchResult<PHAsset *> *)assets {
    _assets = assets;
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[assets count]];

    // 填充模型
    for (PHAsset *phAsset in assets) {
        CJFileObjModel *model = [CJFileObjModel alloc];
        model.typeLimits = self.typeLimits;
        model.asset = phAsset;
        [items addObject:model];
    }
    
    self.dataItems = items;
}

- (void)setDataItems:(NSMutableArray *)dataItems {
    _dataItems = dataItems;
    self.tableView.options_image = _options_image;
    self.tableView.options_video = _options_video;
    self.tableView.dataItems = _dataItems;
    
    [self nullData];
}

- (void)nullData {
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.dataItems.count <= 0) {
            self.nullTitleLbl.text = @"该分类没有文件";
            self.nullView.hidden = NO;
        } else {
            _nullTitleLbl.text = @"正在加载文件...";
            self.nullView.hidden = YES;
        }
    });
     */
    
    if (self.dataItems.count <= 0) {
        self.nullTitleLbl.text = @"该分类没有文件";
        self.nullView.hidden = NO;
    } else {
        _nullTitleLbl.text = @"正在加载文件...";
        self.nullView.hidden = YES;
    }
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - FileTableViewDelegate

- (void)fileTableView:(UITableView *)tableView selectModel:(CJFileObjModel *)model cellButton:(UIButton *)btn {
    if ([self.fileTableViewDelegate respondsToSelector:@selector(fileTableView:selectModel:cellButton:)]) {
        [self.fileTableViewDelegate fileTableView:tableView selectModel:model cellButton:btn];
    }
}

- (void)fileTableView:(UITableView *)tableView didSelect:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CJFileObjModel *actualFile = [self.dataItems objectAtIndex:indexPath.row];
    CJFlieLookUpVC *vc = [[CJFlieLookUpVC alloc] initWithFileModel:actualFile];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fileTableView:(UITableView *)tableView deleteModel:(CJFileObjModel *)model deleteIndexPath:(NSIndexPath *)indexPath {
    self.tableView = (YGFileTableView *)tableView;
    self.deleteModel = model;
    self.deleteIndxPath = indexPath;
    [self presentViewController:self.alertController animated:YES completion:nil];
}

@end
