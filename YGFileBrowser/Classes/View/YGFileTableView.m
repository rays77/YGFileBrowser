//
//  YGFileTableView.m
//  Pods
//
//  Created by wuyiguang on 2017/12/14.
//

#import "YGFileTableView.h"
#import "CJFileObjModel.h"
#import "VeFileViewCell.h"
#import "YGFileTool.h"
#import "MJExtension.h"

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
    
    // 图片
    if (self.options_image) {
        [self reqeustPhoto:actualFile cell:cell];
    } else if (self.options_video) { // 视频
        [self reqeustVideo:actualFile cell:cell];
    } else {
        cell.model = actualFile;
    }
    
    // cell回调
    __weak typeof(self) weakSelf = self;
    cell.Clickblock = ^(CJFileObjModel *model,UIButton *btn){
        if ([weakSelf.fileTableViewDelegate respondsToSelector:@selector(fileTableView:selectModel:cellButton:)]) {
            [weakSelf.fileTableViewDelegate fileTableView:tableView selectModel:model cellButton:btn];
        }
    };
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    CJFileObjModel *model = [self.dataItems objectAtIndex:indexPath.row];
    return model.allowEdite;
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

- (void)reqeustPhoto:(CJFileObjModel *)actualFile cell:(UITableViewCell *)cell
{
    VeFileViewCell *fileCell = (VeFileViewCell *)cell;
    
    // 获取时间
    if (actualFile.creatTime.length <= 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
        actualFile.creatTime = [dateFormatter stringFromDate:actualFile.asset.creationDate];
    }
    
    if (actualFile.image == nil) {
        
        PHImageManager *manager = [PHImageManager defaultManager];
        
        [manager requestImageForAsset:actualFile.asset targetSize: CGSizeMake(110, 110) contentMode:PHImageContentModeAspectFill options:self.options_image resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            if (result) {
                
                actualFile.image = result;
                
                [manager requestImageDataForAsset:actualFile.asset options:self.options_image resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    
                    if (imageData) {
                        
                        actualFile.fileSizefloat = imageData.length;
                        
                        actualFile.fileSize = [CJFileObjModel getBytesFromDataLength:actualFile.fileSizefloat];
                        
                        actualFile.fileData = UIImageJPEGRepresentation(result,0.5);
                        
                        actualFile.name = [[NSString stringWithFormat:@"%@", [info objectForKey:@"PHImageFileURLKey"]] lastPathComponent];
                        
                        actualFile.allowEdite = NO;
                        
                        NSString *filePath = [NSString stringWithFormat:@"%@", [info objectForKey:@"PHImageFileURLKey"]];
                        
                        actualFile.allowSelect = ![YGFileTool containsObject:actualFile.typeLimits allowTypes:actualFile.allowTypes string:[filePath pathExtension]];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 刷新Cell
                            fileCell.model = actualFile;
                        });
                    }
                }];
            }
        }];
    } else {
        // 刷新Cell
        fileCell.model = actualFile;
    }
}

- (void)reqeustVideo:(CJFileObjModel *)actualFile cell:(UITableViewCell *)cell
{
    VeFileViewCell *fileCell = (VeFileViewCell *)cell;
    
    // 获取时间
    if (actualFile.creatTime.length <= 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
        actualFile.creatTime = [dateFormatter stringFromDate:actualFile.asset.creationDate];
    }
    
    if (actualFile.image == nil) {
        
        PHImageManager *manager = [PHImageManager defaultManager];
        
        [manager requestImageForAsset:actualFile.asset targetSize: CGSizeMake(110, 110) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                actualFile.image = result;
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 刷新Cell
                    fileCell.headImagV.image = result;
                });
            }
        }];
        
        [manager requestAVAssetForVideo:actualFile.asset options:self.options_video resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            NSArray *tracks = asset.tracks;
            
            actualFile.fileSizefloat = 0;
            
            for (AVAssetTrack * track in tracks) {
                float rate = ([track estimatedDataRate] / 8); // convert bits per second to bytes per second
                float seconds = CMTimeGetSeconds([track timeRange].duration);
                actualFile.fileSizefloat += seconds * rate;
            }
            
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            
            actualFile.fileSize = [NSString stringWithFormat:@"%.2lfM",actualFile.fileSizefloat / 1024 / 1024];
            
            actualFile.name = [[urlAsset.URL absoluteString] lastPathComponent];
            
//            actualFile.fileData = [asset mj_keyValues][@"propertyListForProxy"][@"moop"];
            
            actualFile.allowEdite = NO;
            
            actualFile.allowSelect = ![YGFileTool containsObject:actualFile.typeLimits allowTypes:actualFile.allowTypes string:[[urlAsset.URL absoluteString] pathExtension]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 刷新Cell
                fileCell.model = actualFile;
            });
        }];
    }
    else
    {
        // 刷新Cell
        fileCell.model = actualFile;
    }
}

@end
