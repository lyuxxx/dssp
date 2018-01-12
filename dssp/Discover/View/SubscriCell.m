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
    [self.contentView addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(110 * HeightCoefficient);
        make.top.equalTo(0 * HeightCoefficient);
    }];
    
    
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    [self.contentView addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(1 * HeightCoefficient);
        make.left.equalTo(15 * WidthCoefficient);
        make.right.equalTo(0);
        make.bottom.equalTo(1 - 1 * HeightCoefficient);
    }];
    
    
    self.bgImgV = [[UIImageView alloc] init];
//    _bgImgV.image = [UIImage imageNamed:@"cell_bg"];
    _bgImgV.layer.cornerRadius = 2;
    _bgImgV.layer.masksToBounds =YES;
    [whiteV addSubview:_bgImgV];
    [_bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.height.equalTo(80 * HeightCoefficient);
        make.width.equalTo(85 * HeightCoefficient);
        make.right.equalTo(-16 * WidthCoefficient);
    }];
    
    
    self.remindLabel = [[UILabel alloc] init];
//    _remindLabel.backgroundColor =[UIColor redColor];
    _remindLabel.textAlignment = NSTextAlignmentLeft;
    _remindLabel.numberOfLines = 0;
    _remindLabel.textColor = [UIColor blackColor];
    _remindLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
//    _remindLabel.text = NSLocalizedString(@"22", nil);
    [self.contentView addSubview:_remindLabel];
    [_remindLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgImgV.left).offset(-15*WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.left.equalTo(16 * HeightCoefficient);
        make.top.equalTo(15 * HeightCoefficient);
    }];
    
//    self.contentLabel = [[UILabel alloc] init];
//    [_contentLabel setNumberOfLines:0];
//    _contentLabel.textAlignment = NSTextAlignmentLeft;
//    _contentLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF "];
//    _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
////    _contentLabel.text = NSLocalizedString(@"今年的广州车展期间,国产东风正式亮相,新车定位于紧凑型SUV，是目前DS品牌的全新的车型", nil);
//    [_bgImgV addSubview:_contentLabel];
//    [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(339 * WidthCoefficient);
//        make.height.equalTo(40.5 * HeightCoefficient);
//        make.left.equalTo(10 * HeightCoefficient);
//        make.top.equalTo(_remindLabel.bottom).offset(10*HeightCoefficient);
//    }];
    
    
//    self.bottomLabel = [[UILabel alloc] init];
//    _bottomLabel.textAlignment = NSTextAlignmentLeft;
//    _bottomLabel.textColor = [UIColor colorWithHexString:@"#A18E79"];
//    _bottomLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
//    _bottomLabel.text = NSLocalizedString(@"品牌", nil);
//    [whiteV addSubview:_bottomLabel];
//    [_bottomLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(22 * WidthCoefficient);
//        make.height.equalTo(15 * HeightCoefficient);
//        make.left.equalTo(16 * HeightCoefficient);
//        make.top.equalTo(_remindLabel.bottom).offset(21 * HeightCoefficient);
//    }];
    
    self.timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
//    _timeLabel.text = NSLocalizedString(@"| 30分钟前发布", nil);
    [whiteV addSubview:_timeLabel];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(116 * WidthCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        make.top.equalTo(_remindLabel.bottom).offset(21 * HeightCoefficient);;
    }];
}

-(void)setChannelModel:(ChannelModel *)channelModel
{
//     NSString *createTime = [NSString stringWithFormat:@"| %@",[self setWithTimeString:channelModel.createTime]];
    _remindLabel.text = NSLocalizedString(channelModel.title, nil);
    _contentLabel.text = NSLocalizedString(channelModel.content, nil);
//    _bottomLabel.text = NSLocalizedString(channelModel.channelName, nil);
    _timeLabel.text = [self setWithTimeString:channelModel.createTime];
    [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:channelModel.picture2] placeholderImage:[UIImage imageNamed:@""]];

}

-(NSString *)setWithTimeString:(NSInteger)time
{
    if (time) {
      
        NSString *dueDateStr = [NSString stringWithFormat: @"%ld", time];
        NSString *publishString = dueDateStr;
        double publishLong = [publishString doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:publishLong/1000];
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        publishDate = [publishDate  dateByAddingTimeInterval: interval];
        publishString = [formatter stringFromDate:publishDate];
        return publishString;
        
        
    }else
    {
        return nil;
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
