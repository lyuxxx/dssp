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
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    timeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
    timeLabel.text = NSLocalizedString(@"2018/12/31", nil);
    [_white addSubview:timeLabel];
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
    [_white addSubview:remindLabel];
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
    [_white addSubview:contentLabel];
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(339 * WidthCoefficient);
        make.height.equalTo(40 * HeightCoefficient);
        make.left.equalTo(10 * HeightCoefficient);
        make.top.equalTo(remindLabel.bottom).offset(10*HeightCoefficient);
    }];
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