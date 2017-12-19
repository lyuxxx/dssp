//
//  NoticeCell.m
//  dssp
//
//  Created by qinbo on 2017/12/19.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "NoticeCell.h"
#import <YYCategoriesSub/YYCategories.h>
@implementation NoticeCell

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
    whiteV.layer.cornerRadius = 4;
    whiteV.layer.shadowOffset = CGSizeMake(0, 7.5);
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowOpacity = 0.2;
    whiteV.layer.shadowRadius = 7;
    whiteV.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(359 * WidthCoefficient);
        make.height.equalTo(100 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(0 * HeightCoefficient);
    }];
    
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    timeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
    timeLabel.text = NSLocalizedString(@"2018/12/31", nil);
    [whiteV addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(141.5 * WidthCoefficient);
        make.height.equalTo(13 * HeightCoefficient);
        make.right.equalTo(-10 * HeightCoefficient);
        make.top.equalTo(14.5 * HeightCoefficient);
    }];
    
    
    
    UILabel *remindLabel = [[UILabel alloc] init];
    remindLabel.textAlignment = NSTextAlignmentLeft;
    remindLabel.textColor = [UIColor colorWithHexString:@"#040000"];
    remindLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    remindLabel.text = NSLocalizedString(@"流量提醒", nil);
    [whiteV addSubview:remindLabel];
    [remindLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(141.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
    }];
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [contentLabel setNumberOfLines:0];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    contentLabel.text = NSLocalizedString(@"今年的广州车展期间,国产东风正式亮相,新车定位于紧凑型SUV，是目前DS品牌的全新的车型", nil);
    [whiteV addSubview:contentLabel];
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(339 * WidthCoefficient);
        make.height.equalTo(40 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(remindLabel.bottom).offset(10*HeightCoefficient);
    }];
   
    
    
    
   
    
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
