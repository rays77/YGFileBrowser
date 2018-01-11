//
//  FileViewCell.m
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import "VeFileViewCell.h"
#import "Masonry.h"
#import "CJFileObjModel.h"
#import "UIColor+CJColorCategory.h"
#import "NSBundle+YGFileBrowser.h"

@interface VeFileViewCell ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) UIImage *norImage;
@property (nonatomic,strong) UIImage *selImage;
@end
@implementation VeFileViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImagV = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.lineBreakMode=NSLineBreakByTruncatingMiddle;
        
        _titleLabel.numberOfLines = 1;
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.numberOfLines = 1;
        _detailLabel.lineBreakMode=NSLineBreakByTruncatingMiddle;
        
        _sendBtn = [[UIButton alloc] init];
        
        [_sendBtn setImage:self.norImage forState:UIControlStateNormal];
        [_sendBtn setImage:self.selImage forState:UIControlStateSelected];
        
        [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_sendBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _detailLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [self.contentView addSubview:_headImagV];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_detailLabel];
        [self.contentView addSubview:_sendBtn];
    }
    return self;
}

- (UIImage *)norImage
{
    if (_norImage == nil) {
        _norImage = [NSBundle yg_imageNamed:@"未选@2x.png"];
    }
    return _norImage;
}
- (UIImage *)selImage
{
    if (_selImage == nil) {
        _selImage = [NSBundle yg_imageNamed:@"选中@2x.png"];
    }
    return _selImage;
}
- (void)setModel:(CJFileObjModel *)model
{
    _model = model;
    self.headImagV.image = model.image;
    self.titleLabel.text = model.name;
    self.detailLabel.text = [model.creatTime stringByAppendingString:[NSString stringWithFormat:@"   %@",model.fileSize]];
    self.sendBtn.selected = model.select;
    self.sendBtn.hidden = !_model.allowSelect;
}
- (void)clickBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.model.select = btn.selected;
    if (_Clickblock) {
        _Clickblock(_model,btn);
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 12;
    
    [_headImagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(margin);
        make.top.equalTo(self.mas_top).offset(8);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.width.equalTo(self.headImagV.mas_height);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImagV.mas_right).offset(10);
        make.right.equalTo(self.sendBtn.mas_left).offset(-margin);
        make.top.equalTo(self.headImagV.mas_top).offset(2);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImagV.mas_right).offset(10);
        make.right.equalTo(self.sendBtn.mas_left).offset(-margin);
        make.bottom.equalTo(self.headImagV.mas_bottom).offset(-2);
    }];
    
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-margin);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}
@end
