//
//  ViewController.m
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//
#import <Photos/Photos.h>

///屏幕高度/宽度
#define CJScreenWidth        [UIScreen mainScreen].bounds.size.width
#define CJScreenHeight       [UIScreen mainScreen].bounds.size.height
#import "CJFileManagerVC.h"
#import "CJFileObjModel.h"
#import "VeFileViewCell.h"
#import "VeFileManagerToolBar.h"
#import "VeFileDepartmentView.h"
#import "CJFlieLookUpVC.h"
#import "UIView+CJToast.h"
#import "UIColor+CJColorCategory.h"
#import "CJFileObjModel.h"
#import "MJExtension.h"
#import "NSBundle+YGFileBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>

CGFloat departmentH = 48;
CGFloat toolBarHeight = 49;

@interface CJFileManagerVC ()<UITableViewDelegate,UITableViewDataSource,TYHInternalAssetGridToolBarDelegate,CJDepartmentViewDelegate>

@property (strong, nonatomic) VeFileDepartmentView *departmentView;//文件的类目视图
@property (strong, nonatomic) VeFileManagerToolBar *assetGridToolBar;//底部发送的工具条
@property (strong, nonatomic) NSMutableArray *selectedItems;//记录选中的cell的模型
@property (nonatomic,strong) UITableView *tabvlew;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *originFileArray;
@property (nonatomic,strong) UIDocumentInteractionController *documentInteraction;

@property (nonatomic,strong) NSArray *depatmentArray;

@property (nonatomic,strong) NSMutableArray *recentTimeSource;

@property (nonatomic,strong) NSMutableArray *videoArray;

@property (nonatomic,strong) NSMutableArray *albumPic;

@end

@implementation CJFileManagerVC

- (NSMutableArray *)albumPic {
    if (!_albumPic) {
        _albumPic = [NSMutableArray array];
    }return _albumPic;
}

- (NSMutableArray *)recentTimeSource {
    if (!_recentTimeSource ) {
        _recentTimeSource = [NSMutableArray array];
    }return _recentTimeSource;
}

- (NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }return _videoArray;
}

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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"文件默认存储的路径---%@",HomeFilePath);
    NSLog(@"bundle路径---%@", [NSBundle yg_bundle]);
    
    self.title = @"我的文件";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initNAV];
    
    [self loadData];
    
    [self searchDocumentsForPath];
    [self loadVideo];
    [self loadPicture];
    [self departmentView];
    [self setupToolbar];
}

- (void)loadPicture {
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author ==PHAuthorizationStatusDenied) {
        //无权限
    }else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            PHFetchOptions *option = [PHFetchOptions new];
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            //根据图片的创建时间升序排列
            PHFetchResult *imageResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
            
            PHImageManager *manager = [PHImageManager defaultManager];
            
            [imageResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //多一层判断,容错处理
                if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
                    PHAsset *asset = obj;
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
                    CJFileObjModel *model = [CJFileObjModel new];
                    model.creatTime = [dateFormatter stringFromDate:asset.creationDate];
                    
                    //请求图片
                    PHImageRequestOptions *imageOption = [PHImageRequestOptions new];
                    imageOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                    imageOption.resizeMode = PHImageRequestOptionsResizeModeFast;
                    
                    [manager requestImageForAsset:asset targetSize:CGSizeMake(70, 70) contentMode:PHImageContentModeAspectFill options:imageOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        
                        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
                        if (downloadFinined && result) {
//                            model.name = [NSString stringWithFormat:@"%ld.png",@(asset.creationDate.timeIntervalSince1970 * 1000).integerValue];
//                            model.image = result;
//                            model.fileData = UIImageJPEGRepresentation(result,0.5);
                            
                            //准确获取原图大小
                            [manager requestImageDataForAsset:asset options:imageOption resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
                                if (downloadFinined && imageData) {
                                    model.filePath = [self getPHImageFileURLPath:[NSString stringWithFormat:@"%@", [info objectForKey:@"PHImageFileURLKey"]]];
                                    model.fileSizefloat = imageData.length;
                                    model.fileSize = [self getBytesFromDataLength:model.fileSizefloat];
                                    model.image = result;
                                    model.fileData = UIImageJPEGRepresentation(result,0.5);
                                    [self.albumPic addObject:model];
                                }
                            }];
                        }
                    }];
                }
            }];
        });
    }
}

- (NSString *)getPHImageFileURLPath:(NSString *)path {
    NSArray *pathList = [path componentsSeparatedByString:@"//"];
    if (pathList.count > 1) {
        return pathList[1];
    }
    return path;
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        return image;
    }
}

- (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB",dataLength];
    }
    return bytes;
}

- (void)loadVideo {
    
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author ==PHAuthorizationStatusDenied) {
        //无权限
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //这里用PHAsset来获取视频数据 ALAsset显得很无力了。。。
            PHFetchOptions *option = [PHFetchOptions new];
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *voideResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:option];
            PHImageManager *manager = [PHImageManager defaultManager];
            // 视频请求对象
            PHVideoRequestOptions *options = [PHVideoRequestOptions new];
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
            [voideResult enumerateObjectsUsingBlock:^(PHAsset *obj, NSUInteger idx, BOOL *stop) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
                CJFileObjModel *model = [CJFileObjModel new];
                model.creatTime = [dateFormatter stringFromDate:obj.creationDate];
                
                [manager requestImageForAsset:obj targetSize:CGSizeMake(80, 80) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    model.image = result;
                }];
                [manager requestAVAssetForVideo:obj options:options resultHandler:^(AVAsset * asset, AVAudioMix * audioMix, NSDictionary * info) {
                    
                    NSArray *tracks = asset.tracks;
                    
                    for (AVAssetTrack * track in tracks) {
                        float rate = ([track estimatedDataRate] / 8); // convert bits per second to bytes per second
                        float seconds = CMTimeGetSeconds([track timeRange].duration);
                        model.fileSizefloat += seconds * rate;
                    }
                    
                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
                    
                    model.fileSize = [NSString stringWithFormat:@"%.2lfM",model.fileSizefloat / 1024 / 1024];
                    
                    model.fileUrl =  [urlAsset.URL absoluteString];
                    model.name = [asset mj_keyValues][@"propertyListForProxy"][@"name"];
                    
                    model.fileData = [asset mj_keyValues][@"propertyListForProxy"][@"moop"];
                    [self.videoArray addObject:model];
                }];
                
            }];
        });
    }
}

- (NSArray *)depatmentArray {
    if (!_depatmentArray) {
        _depatmentArray = @[@"文档",@"视频",@"相册",@"音乐",@"其他"];
    }
    return _depatmentArray;
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
- (UITableView *)tabvlew
{
    if (_tabvlew == nil) {
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.departmentView.frame), CJScreenWidth, CJScreenHeight - toolBarHeight - departmentH-self.navigationController.navigationBar.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height);
        _tabvlew = [[UITableView alloc]   initWithFrame:frame style:UITableViewStylePlain];
        _tabvlew.tableFooterView = [[UIView alloc] init];
        _tabvlew.delegate = self;
        _tabvlew.dataSource = self;
        [self.view addSubview:self.tabvlew];
    }
    return _tabvlew;
}
- (void)setupToolbar
{
    VeFileManagerToolBar *toolbar = [[VeFileManagerToolBar alloc] initWithFrame:CGRectMake(0, CJScreenHeight - toolBarHeight, CJScreenWidth, toolBarHeight)];
    toolbar.delegate = self;
    _assetGridToolBar = toolbar;
    _assetGridToolBar.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_assetGridToolBar];
}

- (void)initNAV {
    self.title = @"本地文件";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
}

#pragma mark - loadData
- (void)loadData{
    [_dataSource removeAllObjects];
    self.originFileArray = @[].mutableCopy;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //遍历HomeFilePath文件夹下的子文件
    NSArray<NSString *> *subPathsArray = [fileManager contentsOfDirectoryAtPath:HomeFilePath error: NULL];
    
    for(NSString *str in subPathsArray){
        CJFileObjModel *object = [[CJFileObjModel alloc] initWithFilePath: [NSString stringWithFormat:@"%@/%@",HomeFilePath, str]];
        [self.originFileArray addObject: object];
    }
    
    self.dataSource = self.originFileArray.mutableCopy;
    [self.tabvlew reloadData];
}

#pragma mark - Action
- (void)cancelAction {
    [self.selectedItems enumerateObjectsUsingBlock:^(CJFileObjModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.select = NO;
    }];
    [self.selectedItems removeAllObjects];
    self.assetGridToolBar.selectedItems = self.selectedItems;
    [self.tabvlew reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VeFileViewCell *cell = (VeFileViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fileCell"];
    if (cell == nil) {
        cell = [[VeFileViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileCell"];
    }
    CJFileObjModel *actualFile = [_dataSource objectAtIndex:indexPath.row];
    cell.model = actualFile;
    __weak typeof(self) weakSelf = self;
    
    // cell回调
    cell.Clickblock = ^(CJFileObjModel *model,UIButton *btn){
        if (weakSelf.selectedItems.count>= weakSelf.maxSelect && btn.selected) {
            btn.selected =  NO;
            model.select = btn.selected;
            [weakSelf.view makeToast:[NSString stringWithFormat:@"最多支持%ld个文件选择", weakSelf.maxSelect] duration:1.0 position:CSToastPositionCenter];
            return ;
        }
        if ([weakSelf checkFileSize:model]) {
            if (btn.isSelected) {
                [weakSelf.selectedItems addObject:model];
                weakSelf.assetGridToolBar.selectedItems = weakSelf.selectedItems;
            }else{
                [weakSelf.selectedItems removeObject:model];
                weakSelf.assetGridToolBar.selectedItems = weakSelf.selectedItems;
            }
        }else{
            [weakSelf.view makeToast:[NSString stringWithFormat:@"暂时不支持超过%.1fMB的文件", weakSelf.maxFileSize/1024/1024] duration:1.0 position:CSToastPositionCenter];
            btn.selected =  NO;
            model.select = btn.selected;
        }
    };
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CJFileObjModel *actualFile = [_dataSource objectAtIndex:indexPath.row];
    NSString *cachePath = actualFile.filePath;
    NSLog(@"调用文件查看控制器%@---type %zd, %@",actualFile.name,actualFile.fileType,cachePath);
    CJFlieLookUpVC *vc = [[CJFlieLookUpVC alloc] initWithFileModel:actualFile];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -  SEARCH -> Action
//获得其他文件
- (void)searchUnkownFileForPath{
    [self.dataSource removeAllObjects];
    for (CJFileObjModel * model in self.originFileArray) {
        if (model.fileType == MKFileTypeUnknown) {
            [self.dataSource addObject:model];
        }
    }
    [self.tabvlew reloadData];
}

//获得应用
- (void)searchAPPForPath {
    [self.dataSource removeAllObjects];
    for (CJFileObjModel * model in self.originFileArray) {
        if (model.fileType == MKFileTypeApplication) {
            [self.dataSource addObject:model];
        }
    }
    [self.tabvlew reloadData];
}

//获得MP3
- (void)searchMP3ForPath {
    [self.dataSource removeAllObjects];
    for (CJFileObjModel * model in self.originFileArray) {
        if (model.fileType == MKFileTypeAudioVidio) {
            [self.dataSource addObject:model];
        }
    }
    [self.tabvlew reloadData];
}

//获得文档
- (void)searchDocumentsForPath {
    [self.dataSource removeAllObjects];
    for (CJFileObjModel * model in self.originFileArray) {
        if (model.fileType == MKFileTypeTxt) {
            [self.dataSource addObject:model];
        }
    }
    [self.tabvlew reloadData];
}

//获取视频
- (void)searchVideoForPhoto {
    [self.dataSource removeAllObjects];
    
    NSArray *results =[self.videoArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CJFileObjModel *model1 = obj1;
        CJFileObjModel *model2 = obj2;
        NSComparisonResult result = [model1.creatTime compare:model2.creatTime];
        return result == NSOrderedAscending;
    }];
    [self.videoArray removeAllObjects];
    [self.videoArray addObjectsFromArray:results];
    
    [self.dataSource addObjectsFromArray:self.videoArray];
    [self.tabvlew reloadData];
}

//获取图片
- (void)searchPictureForPhoto {
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:self.albumPic];
    [self.tabvlew reloadData];
}

#pragma mark --CJDepartmentViewDelegate
//根据点击进行数据过滤
- (void)didScrollToIndex:(NSInteger)index withSelectMode:(NSInteger)selectMode{
    [self setOrigArray];
    switch (index) {
        case 0:
        {
            [self searchDocumentsForPath];
        }
            break;
            
        case 1:
        {
            //获取视频
            [self searchVideoForPhoto];
        }
            break;
            
        case 2:
        {
            [self searchPictureForPhoto];
        }
            break;
            
        case 3:
        {
            [self searchMP3ForPath];
        }
            break;
            
        case 4:
        {
            [self searchUnkownFileForPath];
        }
            break;
            
        default:
            NSLog(@"btn.tag%zd",index);
            break;
    }
}

//将已经记录选中的文件，保存
- (void)setOrigArray{
    for (CJFileObjModel *model in self.selectedItems) {
        [self.originFileArray enumerateObjectsUsingBlock:^(CJFileObjModel *origModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([origModel.filePath isEqualToString:model.filePath]) {
                origModel.select = model.select;
                NSLog(@"被选中的item 是：%@",origModel.filePath);
            }
        }];
    }
}

#pragma mark --TYHInternalAssetGridToolBarDelegate

- (void)didClickSenderButtonInAssetGridToolBar:(VeFileManagerToolBar *)internalAssetGridToolBar
{
    if ([self.fileSelectVcDelegate respondsToSelector:@selector(fileViewControlerSelected:)]) {
        [self.fileSelectVcDelegate fileViewControlerSelected:self.selectedItems];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
- (BOOL)checkFileSize:(CJFileObjModel *)model
{
    if (model.fileSizefloat >= self.maxFileSize) {
        return NO;
    }
    return YES;
}
@end
