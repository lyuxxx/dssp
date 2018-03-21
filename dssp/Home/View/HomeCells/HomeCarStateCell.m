//
//  HomeCarStateCell.m
//  dssp
//
//  Created by yxliu on 2018/3/13.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "HomeCarStateCell.h"
#import "TrafficReportModel.h"

NSString * const HomeCarStateCellIdentifier = @"HomeCarStateCellIdentifier";
@interface HomeCarStateCell ()
@property (nonatomic, strong) UILabel *mileageLabel;
@property (nonatomic, strong) UILabel *oilLeftLabel;
@property (nonatomic, strong) UILabel *healthLabel;
@end

@implementation HomeCarStateCell

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
    
    NSArray *dataTitles = @[NSLocalizedString(@"总里程", nil),NSLocalizedString(@"剩余油量", nil),NSLocalizedString(@"车辆状况", nil)];
    for (NSInteger i = 0; i < dataTitles.count; i++) {
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:12];
        label0.textAlignment = NSTextAlignmentCenter;
        label0.text = dataTitles[i];
        label0.textColor = [UIColor colorWithHexString:GeneralColorString];
        [self.contentView addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(114 * WidthCoefficient);
            make.height.equalTo(15 * WidthCoefficient);
            make.left.equalTo((16 + 114 * i) * WidthCoefficient);
            make.top.equalTo(20 * WidthCoefficient);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = [UIColor whiteColor];
        [self.contentView addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(114 * WidthCoefficient);
            make.height.equalTo(20 * WidthCoefficient);
            make.top.equalTo(label0.bottom);
            make.centerX.equalTo(label0);
        }];
        
        if (i == 0) {
            self.mileageLabel = label1;
        } else if (i == 1) {
            self.oilLeftLabel = label1;
        } else if (i == 2) {
            self.healthLabel = label1;
        }
    }
}

+ (CGFloat)cellHeight {
    return 80 * WidthCoefficient;
}

- (void)configWithData:(TrafficReporData *)trafficReporData {
    NSString *totalMileage = [[NSString stringWithFormat:@"%@",trafficReporData.totalMileage] stringByAppendingString:@"km"];
    
    NSString *levelOil = [[NSString stringWithFormat:@"%@",trafficReporData.levelFuel] stringByAppendingString:@"%"];
    
    
    if([trafficReporData.alertPriority isEqualToString:@"high"]) {
        
        _healthLabel.text = @"需维修";
        
    }
    else if([trafficReporData.alertPriority isEqualToString:@"low"]) {
        _healthLabel.text = @"需检查";
    }
    else
    {
        _healthLabel.text = @"未知";
        
    }
    _mileageLabel.text = trafficReporData.totalMileage?totalMileage:@"0km";
    //    _oilLeftLabel.text = trafficReporData.levelFuel?levelOil:@"0%";
    
    if(trafficReporData.levelFuel)
    {
        
        NSString *stringInt = trafficReporData.levelFuel;
        int ivalue = [stringInt intValue];
        NSString *levelFuel = [[NSString stringWithFormat:@"%@",trafficReporData.levelFuel] stringByAppendingString:@"%"];
        if (ivalue<10 || ivalue==10) {
            
            _oilLeftLabel.text=NSLocalizedString(levelFuel, nil);
            _oilLeftLabel.textColor = [UIColor redColor];
        }
        else
        {
            _oilLeftLabel.text=NSLocalizedString(levelFuel, nil);
            _oilLeftLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
            
        }
    }
    else
    {
        _oilLeftLabel.text= @"0%";
        _oilLeftLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
    }
}

@end
