//
//  TrackSingleCell.m
//  dssp
//
//  Created by yxliu on 2018/3/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "TrackSingleCell.h"
#import "TrackObject.h"

@interface TrackSingleCell ()
@property (nonatomic, strong) UILabel *startAddressLabel;
@property (nonatomic, strong) UILabel *endAddressLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *mileageLabel;
@property (nonatomic, strong) UILabel *fuelLabel;
@end

@implementation TrackSingleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    bg.layer.cornerRadius = 4;
    bg.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
    bg.layer.shadowOffset = CGSizeMake(0, 4);
    bg.layer.shadowOpacity = 0.5;
    bg.layer.shadowRadius = 7;
    [self.contentView addSubview:bg];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(5 * WidthCoefficient, 16 * WidthCoefficient, 5 * WidthCoefficient, 16 * WidthCoefficient));
    }];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"轨迹_icon"];
    [bg addSubview:imgV];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(36 * WidthCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.top.equalTo(17 * WidthCoefficient);
    }];
    
    NSArray *topTitles = @[NSLocalizedString(@"起点:", nil),NSLocalizedString(@"终点:", nil)];
    for (NSInteger i = 0; i < topTitles.count; i++) {
        UIView *dot = [[UIView alloc] init];
        if (i == 0) {
            dot.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
        } else {
            dot.backgroundColor = [UIColor colorWithHexString:@"ac0042"];
        }
        dot.layer.cornerRadius = 3 * WidthCoefficient;
        [bg addSubview:dot];
        [dot makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(6 * WidthCoefficient);
            make.left.equalTo(imgV.right).offset(15 * WidthCoefficient);
            make.top.equalTo((17 + 30 * i) * WidthCoefficient);
        }];
        
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:14];
        label0.textColor = [UIColor colorWithHexString:@"#999999"];
        label0.textAlignment = NSTextAlignmentLeft;
        label0.text = topTitles[i];
        [bg addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(35 * WidthCoefficient);
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(dot.right).offset(5 * WidthCoefficient);
            make.centerY.equalTo(dot);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = [UIFont fontWithName:FontName size:14];
        label1.textColor = [UIColor colorWithHexString:@"#ffffff"];
        label1.textAlignment = NSTextAlignmentLeft;
        [bg addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(151 * WidthCoefficient);
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(label0.right).offset(5 * WidthCoefficient);
            make.top.equalTo(label0);
        }];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.font = [UIFont fontWithName:FontName size:14];
        label2.textColor = [UIColor colorWithHexString:@"#999999"];
        label2.textAlignment = NSTextAlignmentRight;
        [bg addSubview:label2];
        [label2 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(60 * WidthCoefficient);
            make.height.equalTo(20 * WidthCoefficient);
            make.right.equalTo(-10 * WidthCoefficient);
            make.top.equalTo(label1);
        }];
        
        if (i == 0) {
            self.startAddressLabel = label1;
            self.startTimeLabel = label2;
        } else if (i == 1) {
            self.endAddressLabel = label1;
            self.endTimeLabel = label2;
        }
    }
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashLine"]];
    [bg addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(323 * WidthCoefficient);
        make.height.equalTo(1 * WidthCoefficient);
        make.centerX.equalTo(bg);
        make.top.equalTo(imgV.bottom).offset(17 * WidthCoefficient);
    }];
    
    NSArray *imgNames = @[@"速度_icon",@"里程_icon",@"油耗_icon"];
    for (NSInteger i = 0; i < imgNames.count; i++) {
        UIImageView *imgV0 = [[UIImageView alloc] init];
        imgV0.image = [UIImage imageNamed:imgNames[i]];
        [bg addSubview:imgV0];
        [imgV0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(16 * WidthCoefficient);
            make.top.equalTo(line.bottom).offset(10 * WidthCoefficient);
            make.left.equalTo((10 + 114.5 * i) * WidthCoefficient);
        }];
        
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:14];
        label0.textColor = [UIColor colorWithHexString:@"#ffffff"];
        [bg addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imgV0);
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(imgV0.right).offset(10 * WidthCoefficient);
        }];
        
        if (i == 0) {
            self.speedLabel = label0;
        } else if (i == 1) {
            self.mileageLabel = label0;
        } else if (i == 2) {
            self.fuelLabel = label0;
        }
    }
}

- (void)configWithTrackInfo:(TrackInfo *)info {
    self.startAddressLabel.text = info.geometry.afterCoordinates[0].address;
    self.startTimeLabel.text = info.properties.startTime;
    self.endAddressLabel.text = info.geometry.afterCoordinates[1].address;
    self.endTimeLabel.text = info.properties.endTime;
    
    self.speedLabel.text = [NSString stringWithFormat:@"%@km/h",info.properties.averageSpeed];
    self.mileageLabel.text = [NSString stringWithFormat:@"%@km",info.properties.mileage];
    self.fuelLabel.text = [NSString stringWithFormat:@"%@L",info.properties.fuelConsumed];
}

@end
