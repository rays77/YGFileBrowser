//
//  YGFileBrowserController.m
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#import "YGFileBrowserController.h"
#import "UIColor+CJColorCategory.h"
#import "NSBundle+YGFileBrowser.h"
#import "YGFileManagerController.h"
#import "YGFileAlbumController.h"
#import "YGFileVideoController.h"
#import "VeFileManagerToolBar.h"
#import "VeFileDepartmentView.h"
#import "UIView+LCCategory.h"
#import "UIView+CJToast.h"
#import "YGFileBrowser.h"
#import "YGFileTool.h"

CGFloat departmentH = 48;
CGFloat toolBarHeight = 49;

@interface YGFileBrowserController () <TYHInternalAssetGridToolBarDelegate, CJDepartmentViewDelegate, FileTableViewDelegate>

@property (strong, nonatomic) VeFileDepartmentView *departmentView;//文件的类目视图
@property (strong, nonatomic) VeFileManagerToolBar *assetGridToolBar;//底部发送的工具条

@property (strong, nonatomic) NSMutableArray *originFileArray;//文档、音乐、其他
@property (strong, nonatomic) NSMutableArray *selectedItems;//记录选中的cell的模型
@property (strong, nonatomic) NSArray *depatmentArray;//栏目

@property (strong, nonatomic) UIViewController *currentVC;//当前展示的控制器
@property (strong, nonatomic) YGFileManagerController *docVC;//文档控制器
@property (strong, nonatomic) YGFileVideoController *videoVC;//视频控制器
@property (strong, nonatomic) YGFileAlbumController *albumVC;//相册控制器
@property (strong, nonatomic) YGFileManagerController *musicVC;//音乐控制器
@property (strong, nonatomic) YGFileManagerController *otherVC;//其它控制器

@end

@implementation YGFileBrowserController

+ (void)initialize
{
    [self getHomeFilePath];
}

- (instancetype)init {
    if (self = [super init]) {
        self.offsetY = 0;
        self.maxSelect = NSIntegerMax;
        self.maxFileSize = CGFLOAT_MAX;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.offsetY = 0;
        self.maxSelect = NSIntegerMax;
        self.maxFileSize = CGFLOAT_MAX;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.offsetY = 0;
        self.maxSelect = NSIntegerMax;
        self.maxFileSize = CGFLOAT_MAX;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"文件默认存储的路径---%@",HomeFilePath);
    NSLog(@"bundle路径---%@", [NSBundle yg_bundle]);
    
    [self initNAV];
    
    [self loadData];
    
    [self departmentView];
    [self docVC];
    [self assetGridToolBar];
}

#pragma mark - loadData

- (void)loadData {
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //遍历HomeFilePath文件夹下的子文件
    NSArray<NSString *> *subPathsArray = [fileManager contentsOfDirectoryAtPath:HomeFilePath error: NULL];
    
    for(NSString *str in subPathsArray){
        CJFileObjModel *object = [[CJFileObjModel alloc] initWithFilePath:[NSString stringWithFormat:@"%@/%@",HomeFilePath, str] typeLimits:self.typeLimits];
        object.allowEdite = YES;
        [self.originFileArray addObject: object];
    }
}

#pragma mark - 数据提取

//获得其他文件
- (NSMutableArray *)searchUnkownFileForPath{
    NSMutableArray *items = @[].mutableCopy;
    for (CJFileObjModel * model in self.originFileArray) {
        if (model.fileType == MKFileTypeUnknown) {
            [items addObject:model];
        }
    }
    return items;
}

//获得应用
- (NSMutableArray *)searchAPPForPath {
    NSMutableArray *items = @[].mutableCopy;
    for (CJFileObjModel * model in self.originFileArray) {
        if (model.fileType == MKFileTypeApplication) {
            [items addObject:model];
        }
    }
    return items;
}

//获得MP3
- (NSMutableArray *)searchMP3ForPath {
    NSMutableArray *items = @[].mutableCopy;
    for (CJFileObjModel * model in self.originFileArray) {
        if (model.fileType == MKFileTypeAudioVidio) {
            [items addObject:model];
        }
    }
    return items;
}

//获得文档
- (NSMutableArray *)searchDocumentsForPath {
    NSMutableArray *items = @[].mutableCopy;
    for (CJFileObjModel * model in self.originFileArray) {
        if (model.fileType == MKFileTypeTxt) {
            [items addObject:model];
        }
    }
    return items;
}

#pragma mark - instance UI

- (void)initNAV {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"本地文件";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    
    if (self.presentingViewController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    }
}

#pragma mark - Action

- (void)cancelAction {
    [self.selectedItems enumerateObjectsUsingBlock:^(CJFileObjModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.select = NO;
    }];
    [self.selectedItems removeAllObjects];
    self.assetGridToolBar.selectedItems = self.selectedItems;
    
    [self.docVC reloadData];
    [self.videoVC reloadData];
    [self.albumVC reloadData];
    [self.musicVC reloadData];
    [self.otherVC reloadData];
}

- (void)doneAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 切换视图控制器

- (void)changeToViewController:(UIViewController *)toVC {
    UIViewController *oldVC = self.currentVC;
    [self transitionFromViewController:self.currentVC
                      toViewController:toVC
                              duration:0.25
                               options:UIViewAnimationOptionCurveEaseIn
                            animations:^{
        //动画
    } completion:^(BOOL finished) {
        if (finished) {
            self.currentVC = toVC;
        } else {
            self.currentVC = oldVC;
        }
    }];
}

#pragma mark - Getter & Setter

- (NSArray *)depatmentArray {
    if (!_depatmentArray) {
        _depatmentArray = @[@"文档",@"视频",@"相册",@"音乐",@"其他"];
    }
    return _depatmentArray;
}

- (NSMutableArray *)originFileArray {
    if (!_originFileArray) {
        _originFileArray = @[].mutableCopy;
    }
    return _originFileArray;
}

- (NSMutableArray *)selectedItems
{
    if (!_selectedItems) {
        _selectedItems = @[].mutableCopy;
    }
    return _selectedItems;
}

- (VeFileDepartmentView *)departmentView
{
    if (_departmentView == nil) {
        CGRect frame = CGRectMake(0, self.offsetY, CJScreenWidth, departmentH);
        _departmentView = [[VeFileDepartmentView alloc] initWithParts:self.depatmentArray withFrame:frame];
        _departmentView.cj_delegate = self;
        [self.view addSubview:_departmentView];
    }
    return _departmentView;
}

- (VeFileManagerToolBar *)assetGridToolBar
{
    if (_assetGridToolBar == nil) {
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.docVC.view.frame) - (self.minusNavHeight ? ([UIApplication sharedApplication].statusBarFrame.size.height-self.navigationController.navigationBar.frame.size.height) : 0), CJScreenWidth, toolBarHeight+(Is_iPhoneX?34:0));
        _assetGridToolBar = [[VeFileManagerToolBar alloc] initWithFrame:frame];
        _assetGridToolBar.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        _assetGridToolBar.delegate = self;
        [self.view addSubview:_assetGridToolBar];
    }
    return _assetGridToolBar;
}

- (YGFileManagerController *)docVC {
    if (_docVC == nil) {
        _docVC = [[YGFileManagerController alloc] init];
        _docVC.typeLimits = self.typeLimits;
        [self addChildViewController:_docVC];
        [_docVC didMoveToParentViewController:self];
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.departmentView.frame), CJScreenWidth, CJScreenHeight-CGRectGetMaxY(self.departmentView.frame)-toolBarHeight-(Is_iPhoneX?34:0));
        _docVC.view.frame = frame;
        _docVC.fileTableViewDelegate = self;
        [self.view addSubview:_docVC.view];
        self.currentVC = _docVC;
        
        _docVC.dataItems = [self searchDocumentsForPath];
    }
    return _docVC;
}

- (YGFileVideoController *)videoVC {
    if (_videoVC == nil) {
        _videoVC = [[YGFileVideoController alloc] init];
        _videoVC.typeLimits = self.typeLimits;
        _videoVC.view.frame = _currentVC.view.frame;
        [self addChildViewController:_videoVC];
        [_videoVC didMoveToParentViewController:self];
        _videoVC.fileTableViewDelegate = self;
    }
    return _videoVC;
}

- (YGFileAlbumController *)albumVC {
    if (_albumVC == nil) {
        _albumVC = [[YGFileAlbumController alloc] init];
        _albumVC.typeLimits = self.typeLimits;
        _albumVC.view.frame = _currentVC.view.frame;
        [self addChildViewController:_albumVC];
        [_albumVC didMoveToParentViewController:self];
        _albumVC.fileTableViewDelegate = self;
    }
    return _albumVC;
}

- (YGFileManagerController *)musicVC {
    if (_musicVC == nil) {
        _musicVC = [[YGFileManagerController alloc] init];
        _musicVC.typeLimits = self.typeLimits;
        _musicVC.view.frame = _currentVC.view.frame;
        [self addChildViewController:_musicVC];
        [_musicVC didMoveToParentViewController:self];
        _musicVC.fileTableViewDelegate = self;
        
        _musicVC.dataItems = [self searchMP3ForPath];
    }
    return _musicVC;
}

- (YGFileManagerController *)otherVC {
    if (_otherVC == nil) {
        _otherVC = [[YGFileManagerController alloc] init];
        _otherVC.typeLimits = self.typeLimits;
        _otherVC.view.frame = _currentVC.view.frame;
        [self addChildViewController:_otherVC];
        [_otherVC didMoveToParentViewController:self];
        _otherVC.fileTableViewDelegate = self;
        
        _otherVC.dataItems = [self searchUnkownFileForPath];
    }
    return _otherVC;
}

- (BOOL)checkFileSize:(CJFileObjModel *)model
{
    if (model.fileSizefloat >= self.maxFileSize) {
        return NO;
    }
    return YES;
}

#pragma mark - FileTableViewDelegate

- (void)fileTableView:(UITableView *)tableView selectModel:(CJFileObjModel *)model cellButton:(UIButton *)btn {
    if (self.selectedItems.count >= self.maxSelect && btn.selected) {
        btn.selected =  NO;
        model.select = btn.selected;
        [self.view makeToast:[NSString stringWithFormat:@"最多支持%ld个文件选择", self.maxSelect] duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if ([self checkFileSize:model]) {
        if (btn.isSelected) {
            [self.selectedItems addObject:model];
            self.assetGridToolBar.selectedItems = self.selectedItems;
        }else{
            [self.selectedItems removeObject:model];
            self.assetGridToolBar.selectedItems = self.selectedItems;
        }
    }else{
        [self.view makeToast:[NSString stringWithFormat:@"暂时不支持超过%.1fMB的文件", self.maxFileSize/1024/1024] duration:1.0 position:CSToastPositionCenter];
        btn.selected =  NO;
        model.select = btn.selected;
    }
}

- (void)fileTableView:(UITableView *)tableView deleteModel:(CJFileObjModel *)model deleteIndexPath:(NSIndexPath *)indexPath {
    [self.selectedItems removeObject:model];
    [self.originFileArray removeObject:model];
    [((YGFileTableView *)tableView).dataItems removeObject:model];
    
    UIViewController *vc = tableView.yg_viewController;
    if ([vc isKindOfClass:[YGFileManagerController class]]) {
        [((YGFileManagerController *)vc).dataItems removeObject:model];
        [(YGFileManagerController *)vc nullData];
    }
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    // 删除文件
    [[NSFileManager defaultManager] removeItemAtPath:model.fileUrl error:nil];
}

#pragma mark - CJDepartmentViewDelegate

//根据点击进行数据过滤
- (void)didScrollToIndex:(NSInteger)index withSelectMode:(NSInteger)selectMode{
    switch (index) {
        case 0:
        {
            [self changeToViewController:self.docVC];
        }
            break;
            
        case 1:
        {
            [self changeToViewController:self.videoVC];
        }
            break;
            
        case 2:
        {
            [self changeToViewController:self.albumVC];
        }
            break;
            
        case 3:
        {
            [self changeToViewController:self.musicVC];
        }
            break;
            
        case 4:
        {
            [self changeToViewController:self.otherVC];
        }
            break;
            
        default:
            NSLog(@"btn.tag%zd",index);
            break;
    }
}

#pragma mark - TYHInternalAssetGridToolBarDelegate

- (void)didClickSenderButtonInAssetGridToolBar:(VeFileManagerToolBar *)internalAssetGridToolBar
{
    if ([self.fileSelectVcDelegate respondsToSelector:@selector(fileViewControlerSelected:)]) {
        [self.fileSelectVcDelegate fileViewControlerSelected:self.selectedItems];
    }
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

+ (void)getHomeFilePath
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:HomeFilePath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:HomeFilePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
}

@end
