//
//  SubscriCell.m
//  dssp
//
//  Created by qinbo on 2017/12/20.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "SubscriCell.h"
#import <YYCategoriesSub/YYCategories.h>
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
    
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"backgroud"];
    bgImgV.layer.cornerRadius = 6;
    bgImgV.layer.masksToBounds =YES;
    [whiteV addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10 * HeightCoefficient);
        make.height.equalTo(160 * HeightCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        make.right.equalTo(-16 * WidthCoefficient);
       
    }];
    
    
    UILabel *remindLabel = [[UILabel alloc] init];
    remindLabel.textAlignment = NSTextAlignmentLeft;
    remindLabel.textColor = [UIColor whiteColor];
    remindLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    remindLabel.text = NSLocalizedString(@"前卫驱动 精准操控", nil);
    [bgImgV addSubview:remindLabel];
    [remindLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(141.5 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
    }];
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [contentLabel setNumberOfLines:0];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF "];
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    contentLabel.text = NSLocalizedString(@"今年的广州车展期间,国产东风正式亮相,新车定位于紧凑型SUV，是目前DS品牌的全新的车型", nil);
    [bgImgV addSubview:contentLabel];
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(339 * WidthCoefficient);
        make.height.equalTo(40.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(remindLabel.bottom).offset(10*HeightCoefficient);
    }];
    
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.textAlignment = NSTextAlignmentLeft;
    bottomLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    bottomLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
    bottomLabel.text = NSLocalizedString(@"品牌", nil);
    [whiteV addSubview:bottomLabel];
    [bottomLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(22 * WidthCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.left.equalTo(16 * HeightCoefficient);
        make.top.equalTo(bgImgV.bottom).offset(12.5 * HeightCoefficient);
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
        make.left.equalTo(bottomLabel.right).offset(2.5 * WidthCoefficient);
        make.top.equalTo(bgImgV.bottom).offset(12.5 * HeightCoefficient);;
    }];
    
    
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
