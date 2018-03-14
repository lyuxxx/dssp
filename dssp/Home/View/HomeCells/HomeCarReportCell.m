//
//  HomeCarReportCell.m
//  dssp
//
//  Created by yxliu on 2018/3/13.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "HomeCarReportCell.h"

NSString * const HomeCarReportCellIdentifier = @"HomeCarReportCellIdentifier";
typedef void(^ReportBlock)(ReportType);
@interface HomeCarReportCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *bgV;
@property (nonatomic, copy) ReportBlock reportBlock;
@end

@implementation HomeCarReportCell

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
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _titleLabel.textColor = [UIColor colorWithHexString:GeneralColorString];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(24 * WidthCoefficient);
        make.top.equalTo(10 * WidthCoefficient);
        make.height.equalTo(22 * WidthCoefficient);
    }];
    
    UIImageView *red = [[UIImageView alloc] init];
    red.image = [UIImage imageNamed:@"red_vertical"];
    [self.contentView addSubview:red];
    [red makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(3 * WidthCoefficient);
        make.height.equalTo(15 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        make.centerY.equalTo(_titleLabel);
    }];
    
    self.bgV = [[UIImageView alloc] init];
    _bgV.userInteractionEnabled = YES;
    _bgV.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
    _bgV.layer.cornerRadius = 4;
    _bgV.layer.shadowColor = [UIColor colorWithHexString:@"000000"].CGColor;
    _bgV.layer.shadowOffset = CGSizeMake(0, 6);
    _bgV.layer.shadowRadius = 7;
    _bgV.layer.shadowOpacity = 0.5;
    [self.contentView addSubview:_bgV];
    [_bgV makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(344 * WidthCoefficient);
        make.height.equalTo(158 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(_titleLabel.bottom).offset(10 * WidthCoefficient);
    }];
    
    UITapGestureRecognizer *reportTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reportTap:)];
    [_bgV addGestureRecognizer:reportTap];
    
    self.descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _descriptionLabel.textColor = [UIColor whiteColor];
    _descriptionLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _descriptionLabel.numberOfLines = 1;
    [_bgV addSubview:_descriptionLabel];
    [_descriptionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.height.equalTo(25 * WidthCoefficient);
        make.top.equalTo(53 * WidthCoefficient);
    }];
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.userInteractionEnabled = NO;
    detailBtn.layer.cornerRadius = 11 * WidthCoefficient;
    detailBtn.layer.masksToBounds = YES;
    [detailBtn setTitle:NSLocalizedString(@"查看详细", nil) forState:UIControlStateNormal];
    [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    detailBtn.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    detailBtn.titleLabel.font = [UIFont fontWithName:FontName size:12];
    [_bgV addSubview:detailBtn];
    [detailBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(75 * WidthCoefficient);
        make.height.equalTo(22 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(_descriptionLabel.bottom).offset(5 * WidthCoefficient);
    }];
}

- (void)reportTap:(UITapGestureRecognizer *)sender {
    self.reportBlock(sender.view.tag);
}

+ (CGFloat)cellHeight {
    return 210 * WidthCoefficient;
}

- (void)configWithTitle:(NSString *)title clickEvent:(void (^)(ReportType))reportBlock {
    self.reportBlock = reportBlock;
    _titleLabel.text = title;
    _bgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@背景图",title]];
    if ([title isEqualToString:NSLocalizedString(@"车况报告", nil)]) {
        _descriptionLabel.text = NSLocalizedString(@"最新车况报告", nil);
        _bgV.tag = ReportTypeCarCondition;
    }
    if ([title isEqualToString:NSLocalizedString(@"驾驶行为周报", nil)]) {
        _descriptionLabel.text = NSLocalizedString(@"最新一期驾驶行为周报", nil);
        _bgV.tag = ReportTypeWeekReport;
    }
    if ([title isEqualToString:NSLocalizedString(@"行车日志", nil)]) {
        _descriptionLabel.text = NSLocalizedString(@"最新行车日志", nil);
        _bgV.tag = ReportTypeTrackList;
    }
}

@end
