//
//  NoticeCell.m
//  dssp
//
//  Created by qinbo on 2017/12/19.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "NoticeCell.h"
#import <YYCategoriesSub/YYCategories.h>
@interface NoticeCell ()
@property (nonatomic, strong) UIView *white;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *address;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end

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
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    self.multipleSelectionBackgroundView = [UIView new];
    
    self.white = ({
        UIView *whiteV = [[UIView alloc] init];
        whiteV.backgroundColor = [UIColor whiteColor];
        whiteV.layer.cornerRadius = 4;
        whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
        whiteV.layer.shadowOffset = CGSizeMake(0, 5);
        whiteV.layer.shadowRadius = 7;
        whiteV.layer.shadowOpacity = 0.5;
        [self.contentView addSubview:whiteV];
        [whiteV makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(10 * WidthCoefficient, 8 * WidthCoefficient, 0 * WidthCoefficient, 8 * WidthCoefficient));
            make.height.equalTo(100 * WidthCoefficient);
           
        }];
        
        whiteV;
    });
    
    self.timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
    _timeLabel.text = NSLocalizedString(@"2018/12/31", nil);
    [_white addSubview:_timeLabel];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(141.5 * WidthCoefficient);
        make.height.equalTo(13 * HeightCoefficient);
        make.right.equalTo(-10 * HeightCoefficient);
        make.top.equalTo(14.5 * HeightCoefficient);
    }];

    self.remindLabel = [[UILabel alloc] init];
    _remindLabel.textAlignment = NSTextAlignmentLeft;
    _remindLabel.textColor = [UIColor colorWithHexString:@"#040000"];
    _remindLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _remindLabel.text = NSLocalizedString(@"流量提醒", nil);
    [_white addSubview:_remindLabel];
    [_remindLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(141.5 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
    }];


    self.contentLabel = [[UILabel alloc] init];
    [_contentLabel setNumberOfLines:0];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _contentLabel.text = NSLocalizedString(@"今年的广州车展期间,国产东风正式亮相,新车定位于紧凑型SUV，是目前DS品牌的全新的车型", nil);
    [_white addSubview:_contentLabel];
    [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(339 * WidthCoefficient);
        make.height.equalTo(40 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(_remindLabel.bottom).offset(10*HeightCoefficient);
    }];
}


-(void)setNoticeModel:(NoticeModel *)noticeModel
{
//    _remindLabel.text = NSLocalizedString(noticeModel.title, nil);
//    _timeLabel.text = [self setWithTimeString:noticeModel.lastUpdateTime];
//    _contentLabel.text =NSLocalizedString(noticeModel.depict, nil);

}


-(NSString *)setWithTimeString:(NSInteger)time
{
    if (time) {
        NSString *dueDateStr = [NSString stringWithFormat: @"%ld", time];
        NSTimeInterval times=[dueDateStr doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:times/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSString *dateString = [formatter stringFromDate: date];
        return dateString;
    }else
    {
        return nil;
        
    }
   
}


- (void)resetColor {
//    self.white.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self resetColor];
    // Configure the view for the selected state
    if (!self.isEditing) {
        return;
    }
    if (selected) {
        [self changeCellSelectedImage];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self resetColor];
    if (!self.isEditing) {
        return;
    }
    if (highlighted) {
        [self changeCellSelectedImage];
    }
}

- (void)changeCellSelectedImage {
    //    for (UIView *view in self.subviews) {
    //
    //        if ([view isKindOfClass:[UIControl class]])
    //        {
    //            for (UIView *subview in view.subviews) {
    //                if ([subview isKindOfClass:[UIImageView class]]) {
    //                    [subview setValue:[UIColor colorWithHexString:@"#ac0042"] forKey:@"tintColor"];
    //                }
    //            }
    //        }
    //    }
    for (UIControl *control in self.subviews) {
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]) {
            for (UIView *v in control.subviews) {
                if ([v isKindOfClass:[UIImageView class]]) {
                    UIImageView *imgV = (UIImageView *)v;
                    [imgV setValue:[UIColor colorWithHexString:@"#ac0042"] forKey:@"tintColor"];
                    //                    //iOS11图片大小不对，舍弃
                    //                    if (self.selected) {
                    //                        imgV.image = [UIImage imageNamed:@"selected"];
                    //                    } else {
                    //                        imgV.image = [UIImage imageNamed:@"selected_empty"];
                    //                    }
                }
            }
        }
    }
}






@end
