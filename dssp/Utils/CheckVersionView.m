//
//  CheckVersionView.m
//  dssp
//
//  Created by yxliu on 2018/3/21.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CheckVersionView.h"
#import "NSString+Size.h"

@implementation VersionObject
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *tmpTime = dic[@"updateTime"];
    NSTimeInterval interval = tmpTime.floatValue / 1000.0f;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+8"];
    _updateTime = [formatter stringFromDate:date];
    
    return YES;
}
@end

@interface CheckVersionView ()

@property (nonatomic, strong) VersionObject *version;

@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;
@property (nonatomic, strong) UITextView *descTextView;
@property (nonatomic, strong) UIButton *ignoreBtn;
@property (nonatomic, strong) UIButton *updateBtn;
@end
@implementation CheckVersionView

+ (instancetype)showWithVersion:(VersionObject *)version {
    for (UIView *view in [[UIApplication sharedApplication].keyWindow.subviews reverseObjectEnumerator]) {
        if ([view isKindOfClass:NSClassFromString(@"InputAlertView")]) {
            [view removeFromSuperview];
            break;
        }
    }
    
    CheckVersionView *view = [[self alloc] initWithVersion:version];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return view;
}

+ (void)dismiss
{
    for (UIView *view in [[UIApplication sharedApplication].keyWindow.subviews reverseObjectEnumerator]) {
        if ([view isKindOfClass:[self class]]) {
            [view removeFromSuperview];
            break;
        }
    }
}

- (instancetype)initWithVersion:(VersionObject *)version {
    self = [super init];
    if (self) {
        self.version = version;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    CGSize descSize = [self.version.updateDesc stringSizeWithContentSize:CGSizeMake(200 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:14]];
    CGFloat tHeight = descSize.height > 145 * WidthCoefficient ? 145 * WidthCoefficient : descSize.height;
    CGFloat wHeight = tHeight + 215 * WidthCoefficient;
    
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor whiteColor];
    bg.layer.masksToBounds = YES;
    bg.layer.cornerRadius = 4;
    bg.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    bg.layer.shadowOffset = CGSizeMake(0, 6);
    bg.layer.shadowRadius = 7;
    bg.layer.shadowOpacity = 0.5;
    [self addSubview:bg];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(270 * WidthCoefficient);
        make.height.equalTo(wHeight);
        make.center.equalTo(self);
    }];
    [bg.layer addAnimation:[self animation] forKey:@"d"];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"版本更新_icon"];
    [bg addSubview:imgV];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(40 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(30 * WidthCoefficient);
    }];
    
    UILabel *label0 = [[UILabel alloc] init];
    label0.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    label0.textColor = [UIColor colorWithHexString:@"ac0042"];
    label0.text = NSLocalizedString(@"发现新版本", nil);
    [bg addSubview:label0];
    [label0 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(80 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
        make.left.equalTo(70 * WidthCoefficient);
        make.top.equalTo(imgV.bottom).offset(20 * WidthCoefficient);
    }];
    
    self.versionLabel = [[UILabel alloc] init];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    _versionLabel.backgroundColor = [UIColor colorWithHexString:@"#ac0042"];
    _versionLabel.layer.masksToBounds = YES;
    _versionLabel.layer.cornerRadius = 2;
    _versionLabel.font = [UIFont fontWithName:FontName size:13];
    _versionLabel.textColor = [UIColor whiteColor];
    _versionLabel.text = [NSString stringWithFormat:@"V%@",self.version.versionName];
    [bg addSubview:_versionLabel];
    [_versionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-70 * WidthCoefficient);
        make.width.equalTo(50 * WidthCoefficient);
        make.height.equalTo(16 * WidthCoefficient);
        make.centerY.equalTo(label0);
    }];
    
    self.updateTimeLabel = [[UILabel alloc] init];
    _updateTimeLabel.textAlignment = NSTextAlignmentCenter;
    _updateTimeLabel.font = [UIFont fontWithName:FontName size:13];
    _updateTimeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _updateTimeLabel.text = [NSString stringWithFormat:@"更新时间:%@",self.version.updateTime];
    [bg addSubview:_updateTimeLabel];
    [_updateTimeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(20 * WidthCoefficient);
        make.top.equalTo(label0.bottom).offset(3.5 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
//    [label0 updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_updateTimeLabel);
//    }];
//
//    [_versionLabel updateConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_updateTimeLabel);
//    }];
    
    self.descTextView = [[UITextView alloc] init];
    _descTextView.font = [UIFont fontWithName:FontName size:14];
    _descTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _descTextView.editable = NO;
    _descTextView.text = self.version.updateDesc;
    _descTextView.textColor = [UIColor colorWithHexString:@"#999999"];
    [bg addSubview:_descTextView];
    [_descTextView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(200 * WidthCoefficient);
        make.height.equalTo(tHeight);
        make.top.equalTo(_updateTimeLabel.bottom).offset(15.5 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [bg addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(bg);
        make.height.equalTo(1.5 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(_descTextView.bottom).offset(16.5 * WidthCoefficient);
    }];
    
    if (self.version.isCompulsoryEscalation.integerValue) {//1强制更新
        self.updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _updateBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_updateBtn setTitle:NSLocalizedString(@"立即更新", nil) forState:UIControlStateNormal];
        [_updateBtn setTitleColor:[UIColor colorWithHexString:@"#ac0042"] forState:UIControlStateNormal];
        [bg addSubview:_updateBtn];
        _updateBtn.frame = CGRectMake(0, wHeight - 48 * WidthCoefficient, 270 * WidthCoefficient, 48 * WidthCoefficient);
    } else {//0选择更新
        self.ignoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ignoreBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _ignoreBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
        [_ignoreBtn setTitle:NSLocalizedString(@"下次再说", nil) forState:UIControlStateNormal];
        [_ignoreBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [bg addSubview:_ignoreBtn];
        _ignoreBtn.frame = CGRectMake(0, wHeight - 48 * WidthCoefficient, 135.5 * WidthCoefficient, 48 * WidthCoefficient);
        
        self.updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _updateBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_updateBtn setTitle:NSLocalizedString(@"立即更新", nil) forState:UIControlStateNormal];
        [_updateBtn setTitleColor:[UIColor colorWithHexString:@"#ac0042"] forState:UIControlStateNormal];
        [bg addSubview:_updateBtn];
        _updateBtn.frame = CGRectMake(135.5 * WidthCoefficient, wHeight - 48 * WidthCoefficient, 135.5 * WidthCoefficient, 48 * WidthCoefficient);
        
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        [bg addSubview:line1];
        [line1 makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(1.25 * WidthCoefficient);
            make.centerX.equalTo(0);
            make.bottom.equalTo(bg);
            make.top.equalTo(line.bottom);
        }];
    }
    
}

- (void)btnClick:(UIButton *)sender {
    if (sender == _ignoreBtn) {
        [[self class] dismiss];
    }
    if (sender == _updateBtn) {
        if ([self.version.marketDownloadUrl containsString:@"itunes.apple.com"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.version.marketDownloadUrl]];
        }
    }
}

- (CAAnimation *)animation {
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.6;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    return animation;
}

@end
