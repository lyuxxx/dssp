//
//  CommodityCommentCell.m
//  dssp
//
//  Created by yxliu on 2018/2/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CommodityCommentCell.h"
#import "NSString+Size.h"
#import "StoreObject.h"
#import <UIImageView+SDWebImage.h>
#import "YYStarView.h"

NSString * const CommodityCommentCellIdentifier = @"CommodityCommentCellIdentifier";

@interface CommodityCommentCell ()
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *user;
@property (nonatomic, strong) YYStarView *starView;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *comment;
@end

@implementation CommodityCommentCell

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
    [self.contentView addSubview:bg];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 16 * WidthCoefficient, 0, 16 * WidthCoefficient));
        make.width.equalTo(343 * WidthCoefficient);
        make.top.equalTo(self.contentView);
    }];
    
    self.avatar = [[UIImageView alloc] init];
    _avatar.layer.cornerRadius = 15 * WidthCoefficient;
    _avatar.layer.masksToBounds = YES;
    [bg addSubview:_avatar];
    [_avatar makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(30 * WidthCoefficient);
        make.left.top.equalTo(10 * WidthCoefficient);
    }];
    
    self.user = [[UILabel alloc] init];
    _user.font = [UIFont fontWithName:FontName size:12];
    _user.textColor = [UIColor whiteColor];
    _user.text = @"A用户";
    [bg addSubview:_user];
    [_user makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(124 * WidthCoefficient);
        make.height.equalTo(15 * WidthCoefficient);
        make.top.equalTo(_avatar);
        make.left.equalTo(_avatar.right).offset(10 * WidthCoefficient);
    }];
    
    self.starView = [[YYStarView alloc] initWithFrame:CGRectMake(50 * WidthCoefficient, 27.5 * WidthCoefficient, 70 * WidthCoefficient, 12 * WidthCoefficient) numberOfStars:5];
    _starView.userInteractionEnabled = NO;
    _starView.scorePercent = 1;
    _starView.allowIncompleteStar = YES;
    _starView.hasAnimation = NO;
    [bg addSubview:_starView];
    
    self.time = [[UILabel alloc] init];
    _time.textAlignment = NSTextAlignmentRight;
    _time.font = [UIFont fontWithName:FontName size:13];
    _time.textColor = [UIColor colorWithHexString:@"#999999"];
    _time.text = @"2018/01/26 12:35";
    [bg addSubview:_time];
    [_time makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(124 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
        make.top.equalTo(_avatar);
        make.right.equalTo(bg).offset(-10 * WidthCoefficient);
    }];
    
    self.comment = [[UILabel alloc] init];
    _comment.numberOfLines = 0;
    _comment.font = [UIFont fontWithName:FontName size:13];
    _comment.textColor = [UIColor whiteColor];
    [bg addSubview:_comment];
    [_comment makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(323 * WidthCoefficient);
        make.height.equalTo(20 * WidthCoefficient);
        make.centerX.equalTo(bg);
        make.top.equalTo(_avatar.bottom).offset(10 * WidthCoefficient);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor colorWithHexString:@"#1e1918"];
    [bg addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(323 * WidthCoefficient);
        make.height.equalTo(1 * WidthCoefficient);
        make.bottom.equalTo(bg);
        make.centerX.equalTo(bg);
    }];
    [bg makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_comment).offset(11 * WidthCoefficient);
    }];
}

- (void)configWithComment:(CommodityComment *)comment {
    self.comment.text = comment.content;
    self.user.text = comment.nickName;
    self.starView.scorePercent = comment.itemScore / 5.0f;
    self.time.text = [self stringFromDate:comment.createTime];
    [self.avatar downloadImage:comment.headPortrait placeholder:[UIImage imageNamed:@"加载中小"] success:^(CUImageCacheType cacheType, UIImage *image) {
        
    } failure:^(NSError *error) {
        _avatar.image = [UIImage imageNamed:@"加载失败小"];
    } received:^(CGFloat progress) {
        
    }];
    CGSize size = [comment.content stringSizeWithContentSize:CGSizeMake(323 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:13]];
    [self.comment updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(ceil(size.height));
    }];
}

+ (CGFloat)cellHeightWithComment:(CommodityComment *)comment {
    CGSize size = [comment.content stringSizeWithContentSize:CGSizeMake(323 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:13]];
    return ceil(size.height) + 61 * WidthCoefficient;
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY/MM/dd HH:mm";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return [formatter stringFromDate:date];
}

@end
