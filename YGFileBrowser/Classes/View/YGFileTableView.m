//
//  YGFileTableView.m
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#import "YGFileTableView.h"
#import "CJFileObjModel.h"
#import "VeFileViewCell.h"

@interface YGFileTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation YGFileTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.tableFooterView = [UIView new];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)setDataItems:(NSMutableArray *)dataItems {
    _dataItems = dataItems;
    [self reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VeFileViewCell *cell = (VeFileViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fileCell"];
    if (cell == nil) {
        cell = [[VeFileViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileCell"];
    }
    CJFileObjModel *actualFile = [self.dataItems objectAtIndex:indexPath.row];
    cell.model = actualFile;
    __weak typeof(self) weakSelf = self;
    
    // cell回调
    cell.Clickblock = ^(CJFileObjModel *model,UIButton *btn){
        if ([weakSelf.fileTableViewDelegate respondsToSelector:@selector(fileTableView:selectModel:cellButton:)]) {
            [weakSelf.fileTableViewDelegate fileTableView:tableView selectModel:model cellButton:btn];
        }
    };
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.fileTableViewDelegate respondsToSelector:@selector(fileTableView:deleteModel:deleteIndexPath:)]) {
        [self.fileTableViewDelegate fileTableView:tableView deleteModel:self.dataItems[indexPath.row] deleteIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.fileTableViewDelegate respondsToSelector:@selector(fileTableView:didSelect:)]) {
        [self.fileTableViewDelegate fileTableView:tableView didSelect:indexPath];
    }
}

@end
