//
//  HomeTopView.m
//  dssp
//
//  Created by yxliu on 2017/11/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "HomeTopView.h"
#import <YYCategoriesSub/YYCategories.h>
#import "TopImgButton.h"
#import "NSArray+Sudoku.h"

@implementation NoResponseView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]) {
        return nil;
    } else {
        return view;
    }
}
@end

@implementation NoResponseImgView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]) {
        return nil;
    } else {
        return view;
    }
}

@end

@implementation NoResponseYYLabel

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]) {
        return nil;
    } else {
        return view;
    }
}

@end

@interface HomeTopView ()

@property (nonatomic, strong) UILabel *weatherLabel;
@property (nonatomic, strong) NoResponseImgView *previewImgV;
@property (nonatomic, strong) UIButton *changeColorBtn;
@property (nonatomic, strong) NoResponseImgView *carImgV;
@property (nonatomic, strong) UILabel *mileageLabel;
@property (nonatomic, strong) UILabel *oilLeftLabel;
@property (nonatomic, strong) UILabel *healthLabel;
@property (nonatomic, strong) NoResponseYYLabel *locationLabel;
@property (nonatomic, strong) NoResponseView *locationBg;
@property (nonatomic, strong) NoResponseView *btnContainer;
@property (nonatomic, strong) UIButton *settingBtn;

@property (nonatomic, strong) NSMutableArray<UIView *> *allSubViews;

@end
@implementation HomeTopView

- (instancetype)init {
    if (self = [super init]) {
        self.weatherLabel = [[UILabel alloc] init];
        _weatherLabel.text = NSLocalizedString(@"", nil);
        _weatherLabel.font = [UIFont fontWithName:FontName size:15];
        _weatherLabel.textColor = [UIColor colorWithHexString:@"#c4b7a6"];
        [self addSubview:_weatherLabel];
        [_weatherLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.equalTo(21 * HeightCoefficient);
            make.top.equalTo(0.5 * HeightCoefficient);
        }];
        
        self.previewImgV = [[NoResponseImgView alloc] init];
        _previewImgV.layer.cornerRadius = 4;
        _previewImgV.layer.shadowOffset = CGSizeMake(0, 7.5);
        _previewImgV.layer.shadowColor = [UIColor colorWithHexString:@"#333333"].CGColor;
        _previewImgV.layer.shadowOpacity = 0.3;
        _previewImgV.layer.shadowRadius = 15;
        _previewImgV.backgroundColor = [UIColor colorWithHexString:@"#3a302f"];
        _previewImgV.userInteractionEnabled = YES;
        [self addSubview:_previewImgV];
        [_previewImgV makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(343 * WidthCoefficient);
            make.height.equalTo(167.5 * HeightCoefficient);
            make.top.equalTo(_weatherLabel.bottom).offset(15 * HeightCoefficient);
        }];
        
        self.changeColorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeColorBtn.userInteractionEnabled = NO;
        [_changeColorBtn setImage:[UIImage imageNamed:@"colorchange"] forState:UIControlStateNormal];
        [_previewImgV addSubview:_changeColorBtn];
        [_changeColorBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(24 * WidthCoefficient);
            make.top.equalTo(10 * HeightCoefficient);
            make.left.equalTo(15 * WidthCoefficient);
        }];
        
        self.carImgV = [[NoResponseImgView alloc] init];
        _carImgV.image = [UIImage imageNamed:@"11"];
        [_previewImgV addSubview:_carImgV];
        [_carImgV makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(230 * WidthCoefficient);
            make.height.equalTo(106.5 * HeightCoefficient);
            make.left.equalTo(16 * WidthCoefficient);
            make.top.equalTo(48 * HeightCoefficient);
        }];
        
        UILabel *label0 = [[UILabel alloc] init];
        label0.font = [UIFont fontWithName:FontName size:11];
        label0.textAlignment = NSTextAlignmentRight;
        label0.text = NSLocalizedString(@"总里程", nil);
        label0.textColor = [UIColor colorWithHexString:GeneralColorString];
        [_previewImgV addSubview:label0];
        [label0 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(80 * WidthCoefficient);
            make.height.equalTo(15 * HeightCoefficient);
            make.right.equalTo(-15 * WidthCoefficient);
            make.top.equalTo(10 * HeightCoefficient);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = [UIFont fontWithName:FontName size:11];
        label1.textAlignment = NSTextAlignmentRight;
        label1.text = NSLocalizedString(@"剩余油量", nil);
        label1.textColor = [UIColor colorWithHexString:GeneralColorString];
        [_previewImgV addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(80 * WidthCoefficient);
            make.height.equalTo(15 * HeightCoefficient);
            make.right.equalTo(-15 * WidthCoefficient);
            make.top.equalTo(61 * HeightCoefficient);
        }];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.font = [UIFont fontWithName:FontName size:11];
        label2.textAlignment = NSTextAlignmentRight;
        label2.text = NSLocalizedString(@"车况健康", nil);
        label2.textColor = [UIColor colorWithHexString:GeneralColorString];
        [_previewImgV addSubview:label2];
        [label2 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(80 * WidthCoefficient);
            make.height.equalTo(15 * HeightCoefficient);
            make.right.equalTo(-15 * WidthCoefficient);
            make.top.equalTo(112 * HeightCoefficient);
        }];
        
        self.mileageLabel = [[UILabel alloc] init];
        _mileageLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _mileageLabel.textAlignment = NSTextAlignmentRight;
        _mileageLabel.textColor = [UIColor whiteColor];
//        _mileageLabel.text = @"12903 km";
        [_previewImgV addSubview:_mileageLabel];
        [_mileageLabel makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(21 * HeightCoefficient);
            make.top.equalTo(25.5 * HeightCoefficient);
            make.right.equalTo(- 15.2 * WidthCoefficient);
        }];
        
        self.oilLeftLabel = [[UILabel alloc] init];
        _oilLeftLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _oilLeftLabel.textAlignment = NSTextAlignmentRight;
        _oilLeftLabel.textColor = [UIColor whiteColor];
//        _oilLeftLabel.text = @"28 L";
        [_previewImgV addSubview:_oilLeftLabel];
        [_oilLeftLabel makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(21 * HeightCoefficient);
            make.top.equalTo(74.5 * HeightCoefficient);
            make.right.equalTo(- 15.2 * WidthCoefficient);
        }];
        
        self.healthLabel = [[UILabel alloc] init];
        _healthLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _healthLabel.textAlignment = NSTextAlignmentRight;
        _healthLabel.textColor = [UIColor whiteColor];
//        _healthLabel.text = @"健康";
        [_previewImgV addSubview:_healthLabel];
        [_healthLabel makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(25 * HeightCoefficient);
            make.top.equalTo(128 * HeightCoefficient);
            make.right.equalTo(- 15.2 * WidthCoefficient);
        }];
        
        NSString *str = @"未获取到车辆位置";
        self.locationLabel = [[NoResponseYYLabel alloc] init];
        _locationLabel.numberOfLines = 0;
        _locationLabel.preferredMaxLayoutWidth = kScreenWidth - 40 * WidthCoefficient - 15 * WidthCoefficient;
        _locationLabel.textAlignment = NSTextAlignmentCenter;
        _locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
        NSMutableAttributedString *locationStr = [NSMutableAttributedString new];
        UIFont *locationFont = [UIFont fontWithName:FontName size:13];
        NSMutableAttributedString *attachment = nil;
        UIImage *locationImage = [UIImage imageNamed:@"location"];
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:locationImage contentMode:UIViewContentModeCenter attachmentSize:locationImage.size alignToFont:locationFont alignment:YYTextVerticalAlignmentCenter];
        [locationStr appendAttributedString:attachment];
        [locationStr yy_appendString:str];
        locationStr.yy_alignment = NSTextAlignmentCenter;
        [locationStr addAttributes:@{NSFontAttributeName:locationFont,NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [str rangeOfString:str].length + 1)];
        _locationLabel.attributedText = locationStr;
        CGSize size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:locationStr];
        [self addSubview:_locationLabel];
        [_locationLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.equalTo(42 * HeightCoefficient);
            make.width.equalTo(layout.textBoundingRect.size.width);
            make.top.equalTo(_previewImgV.bottom).offset(15 * HeightCoefficient);
        }];

        self.locationBg = [[NoResponseView alloc] init];
        _locationBg.backgroundColor = [UIColor colorWithHexString:@"2f2726"];
        _locationBg.layer.cornerRadius = 10.5;
        [self addSubview:_locationBg];
        [self insertSubview:_locationLabel aboveSubview:_locationBg];
        [_locationBg makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_locationLabel);
            make.height.equalTo(21 * HeightCoefficient);
            make.width.equalTo(_locationLabel).offset(15 * WidthCoefficient);
        }];
        
        self.btnContainer = [[NoResponseView alloc] init];
        _btnContainer.layer.cornerRadius = 4;
        _btnContainer.backgroundColor = [UIColor whiteColor];
        _btnContainer.layer.shadowOffset = CGSizeMake(0, 4);
        _btnContainer.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
        _btnContainer.layer.shadowOpacity = 0.2;
        _btnContainer.layer.shadowRadius = 7;
        [self addSubview:_btnContainer];
        [_btnContainer makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_previewImgV.bottom).offset(73 * HeightCoefficient);
            make.centerX.equalTo(0);
            make.width.equalTo(360 * WidthCoefficient);
            make.height.equalTo(92 * WidthCoefficient);
        }];
        
        NSArray *btnImgTitles = @[
                                  @"流量查询_icon",
                                  @"智慧出行_icon",
                                  @"商城",
                                  @"违章查询_icon",
                                  @"预约保养_icon"
                                  ];
        NSArray *btnTitles = @[
                               @"实时流量",
                               @"出行",
                               @"商城",
                               @"违章查询",
                               @"预约保养"
                               ];
        
        NSMutableArray<TopImgButton *> *btns = [NSMutableArray new];
        for (NSInteger i = 0; i < btnImgTitles.count; i++) {
            TopImgButton *btn = [TopImgButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 1000 + i;
            btn.userInteractionEnabled = NO;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:btnImgTitles[i]] forState:UIControlStateNormal];
            [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#040000"] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont fontWithName:FontName size:13]];
            [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [_btnContainer addSubview:btn];
            [btns addObject:btn];
        }
        
        [btns mas_distributeSudokuViewsWithFixedItemWidth:52.5 * WidthCoefficient fixedItemHeight:62 * WidthCoefficient warpCount:5 topSpacing:16 * WidthCoefficient bottomSpacing:14 * WidthCoefficient leadSpacing:16 * WidthCoefficient tailSpacing:16 * WidthCoefficient];
        
        self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _settingBtn.userInteractionEnabled = NO;
        [_settingBtn setImage:[UIImage imageNamed:@"Group 2"] forState:UIControlStateNormal];
        [_btnContainer addSubview:_settingBtn];
        [_settingBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(20 * WidthCoefficient);
            make.top.right.equalTo(0);
        }];
    }
    return self;
}

-(void)setTrafficReporData:(TrafficReporData *)trafficReporData
{
    
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
         _healthLabel.text = @"健康";
        
    }
    _mileageLabel.text = trafficReporData.totalMileage?totalMileage:@"0km";
    _oilLeftLabel.text = trafficReporData.levelFuel?levelOil:@"0%";
 
    
}

- (void)setLocationStr:(NSString *)locationStr {
    if (![_locationStr isEqualToString:locationStr]) {
        _locationStr = locationStr;
        NSMutableAttributedString *location = [NSMutableAttributedString new];
        UIFont *locationFont = [UIFont fontWithName:FontName size:13];
        NSMutableAttributedString *attachment = nil;
        UIImage *locationImage = [UIImage imageNamed:@"location"];
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:locationImage contentMode:UIViewContentModeCenter attachmentSize:locationImage.size alignToFont:locationFont alignment:YYTextVerticalAlignmentCenter];
        [location appendAttributedString:attachment];
        [location yy_appendString:_locationStr];
        location.yy_alignment = NSTextAlignmentCenter;
        [location addAttributes:@{NSFontAttributeName:locationFont,NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [_locationStr rangeOfString:_locationStr].length + 1)];
        _locationLabel.attributedText = location;
        CGSize size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:location];
        [self addSubview:_locationLabel];
        NSInteger oriWidth = layout.textBoundingRect.size.width;
        NSInteger width = oriWidth;
        if (oriWidth > _locationLabel.preferredMaxLayoutWidth) {//两行
            width = _locationLabel.preferredMaxLayoutWidth;
            _locationBg.layer.cornerRadius = 21;
            [_locationBg updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(42 * HeightCoefficient);
            }];
        } else {//一行
            _locationBg.layer.cornerRadius = 10.5;
            [_locationBg updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(21 * HeightCoefficient);
            }];
        }
        [_locationLabel updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(width);
        }];
        [self layoutIfNeeded];
    }
}

- (void)updateWeatherText:(NSString *)text {
    self.weatherLabel.text = text;
}

- (void)btnClick:(UIButton *)sender {
    NSLog(@"click");
    self.clickBlock(sender);
}

- (void)listSubviewsOfView:(UIView *)view {
    NSArray *subviews = [view subviews];
    if ([subviews count] == 0) return;
    for (UIView *subview in subviews) {
        [self.allSubViews addObject:subview];
        [self listSubviewsOfView:subview];
    }
}

- (void)didTapWithPoint:(CGPoint)point {
    [self.allSubViews removeAllObjects];
    [self listSubviewsOfView:self];
    for (UIView *view in self.allSubViews.reverseObjectEnumerator) {
        if ([view isKindOfClass:[UIButton class]]) {
            CGPoint btnPoint = [view convertPoint:point fromView:self];
            if (CGRectContainsPoint(view.bounds, btnPoint)) {
                [(UIButton *)view sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
        if ([view isKindOfClass:[NoResponseYYLabel class]]) {
            CGPoint labelPoint = [view convertPoint:point fromView:self];
            if (CGRectContainsPoint(view.bounds, labelPoint)) {
                self.locationClick((NoResponseYYLabel *)view);
            }
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]) {
        return nil;
    } else {
        return view;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (NSMutableArray<UIView *> *)allSubViews {
    if (!_allSubViews) {
        _allSubViews = [[NSMutableArray alloc] init];
    }
    return _allSubViews;
}

@end
