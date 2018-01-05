//
//  SubscriCell.m
//  dssp
//
//  Created by qinbo on 2017/12/20.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "SubscriCell.h"
#import <YYCategoriesSub/YYCategories.h>
#import "UIImageView+WebCache.h"
@implementation SubscriCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
        
    }
    return self;
}

-(void)createUI
{
    UIView *whiteV = [[UIView alloc] init];
    whiteV.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(210 * HeightCoefficient);
        make.top.equalTo(0 * HeightCoefficient);
    }];
    
    
    self.bgImgV = [[UIImageView alloc] init];
//    _bgImgV.image = [UIImage imageNamed:@"cell_bg"];
    _bgImgV.layer.cornerRadius = 6;
    _bgImgV.layer.masksToBounds =YES;
    [whiteV addSubview:_bgImgV];
    [_bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10 * HeightCoefficient);
        make.height.equalTo(160 * HeightCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        make.right.equalTo(-16 * WidthCoefficient);
       
    }];
    
    
    self.remindLabel = [[UILabel alloc] init];
    _remindLabel.textAlignment = NSTextAlignmentLeft;
    _remindLabel.textColor = [UIColor whiteColor];
    _remindLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
//    _remindLabel.text = NSLocalizedString(@"22", nil);
    [_bgImgV addSubview:_remindLabel];
    [_remindLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(180 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
    }];
    
    
    self.contentLabel = [[UILabel alloc] init];
    [_contentLabel setNumberOfLines:0];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF "];
    _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
//    _contentLabel.text = NSLocalizedString(@"今年的广州车展期间,国产东风正式亮相,新车定位于紧凑型SUV，是目前DS品牌的全新的车型", nil);
    [_bgImgV addSubview:_contentLabel];
    [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(339 * WidthCoefficient);
        make.height.equalTo(40.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(_remindLabel.bottom).offset(10*HeightCoefficient);
    }];
    
    
    self.bottomLabel = [[UILabel alloc] init];
    _bottomLabel.textAlignment = NSTextAlignmentLeft;
    _bottomLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _bottomLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
//    _bottomLabel.text = NSLocalizedString(@"品牌", nil);
    [whiteV addSubview:_bottomLabel];
    [_bottomLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(22 * WidthCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.left.equalTo(16 * HeightCoefficient);
        make.top.equalTo(_bgImgV.bottom).offset(12.5 * HeightCoefficient);
    }];
    
    UILabel *bottomsLabel = [[UILabel alloc] init];
    bottomsLabel.textAlignment = NSTextAlignmentLeft;
    bottomsLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    bottomsLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
    bottomsLabel.text = NSLocalizedString(@"| 30分钟前发布", nil);
    [whiteV addSubview:bottomsLabel];
    [bottomsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(116 * WidthCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.left.equalTo(_bottomLabel.right).offset(2.5 * WidthCoefficient);
        make.top.equalTo(_bgImgV.bottom).offset(12.5 * HeightCoefficient);;
    }];
    
}

-(void)setChannelModel:(ChannelModel *)channelModel
{
    
    _remindLabel.text = NSLocalizedString(channelModel.title, nil);
    _contentLabel.text = NSLocalizedString(channelModel.content, nil);
    _bottomLabel.text = NSLocalizedString(channelModel.channelName, nil);
    
    [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:channelModel.picture1] placeholderImage:[UIImage imageNamed:@"backgroud_mine"]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
