//
//  HomeCarLocationCell.m
//  dssp
//
//  Created by yxliu on 2018/3/22.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "HomeCarLocationCell.h"
#import <YYText.h>

NSString * const HomeCarLocationCellIdentifier = @"HomeCarLocationCellIdentifier";

typedef void(^LocationClick)(YYLabel *);

@interface HomeCarLocationCell ()
@property (nonatomic, strong) YYLabel *locationLabel;
@property (nonatomic, copy) LocationClick locationClick;
@end

@implementation HomeCarLocationCell

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
    
    NSString *str = @"未获取到车辆位置";
    self.locationLabel = [[YYLabel alloc] init];
    _locationLabel.numberOfLines = 0;
    _locationLabel.preferredMaxLayoutWidth = kScreenWidth - 32 * WidthCoefficient;
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
    [locationStr addAttributes:@{NSFontAttributeName:locationFont,NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(1, [str rangeOfString:str].length)];
    [locationStr yy_setTextHighlightRange:NSMakeRange(1, [str rangeOfString:str].length) color:[UIColor whiteColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (self.locationClick) {
            self.locationClick(_locationLabel);
        }
    }];
    _locationLabel.attributedText = locationStr;
    CGSize size = CGSizeMake(kScreenWidth - 32 * WidthCoefficient, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:locationStr];
    [self.contentView addSubview:_locationLabel];
    [_locationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.height.equalTo(layout.textBoundingRect.size.height);
        make.width.equalTo(layout.textBoundingRect.size.width);
    }];
}

- (void)configWithLocation:(NSString *)locationStr withLocationClick:(void (^)(YYLabel *))block {
    if (!locationStr || [locationStr isEqualToString:@""]) {
        locationStr = @"未获取到车辆位置";
    }
    self.locationClick = block;
    NSMutableAttributedString *location = [NSMutableAttributedString new];
    UIFont *locationFont = [UIFont fontWithName:FontName size:13];
    NSMutableAttributedString *attachment = nil;
    UIImage *locationImage = [UIImage imageNamed:@"location"];
    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:locationImage contentMode:UIViewContentModeCenter attachmentSize:locationImage.size alignToFont:locationFont alignment:YYTextVerticalAlignmentCenter];
    [location appendAttributedString:attachment];
    [location yy_appendString:locationStr];
    location.yy_alignment = NSTextAlignmentCenter;
    [location addAttributes:@{NSFontAttributeName:locationFont,NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(1, [locationStr rangeOfString:locationStr].length)];
    [location yy_setTextHighlightRange:NSMakeRange(1, [locationStr rangeOfString:locationStr].length) color:[UIColor whiteColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (self.locationClick) {
            self.locationClick(_locationLabel);
        }
    }];
    _locationLabel.attributedText = location;
    CGSize size = CGSizeMake(kScreenWidth - 32 * WidthCoefficient, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:location];
    [_locationLabel updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(layout.textBoundingRect.size.height);
        make.width.equalTo(layout.textBoundingRect.size.width);
    }];
}

+ (CGFloat)cellHeightWithLocation:(NSString *)locationStr {
    if (!locationStr || [locationStr isEqualToString:@""]) {
        locationStr = @"未获取到车辆位置";
    }
    NSMutableAttributedString *location = [NSMutableAttributedString new];
    UIFont *locationFont = [UIFont fontWithName:FontName size:13];
    NSMutableAttributedString *attachment = nil;
    UIImage *locationImage = [UIImage imageNamed:@"location"];
    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:locationImage contentMode:UIViewContentModeCenter attachmentSize:locationImage.size alignToFont:locationFont alignment:YYTextVerticalAlignmentCenter];
    [location appendAttributedString:attachment];
    [location yy_appendString:locationStr];
    location.yy_alignment = NSTextAlignmentCenter;
    [location addAttributes:@{NSFontAttributeName:locationFont,NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(1, [locationStr rangeOfString:locationStr].length)];
    [location yy_setTextHighlightRange:NSMakeRange(1, [locationStr rangeOfString:locationStr].length) color:[UIColor whiteColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
    }];
    CGSize size = CGSizeMake(kScreenWidth - 32 * WidthCoefficient, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:location];
    
    return layout.textBoundingRect.size.height + 10 * WidthCoefficient;
}

@end
