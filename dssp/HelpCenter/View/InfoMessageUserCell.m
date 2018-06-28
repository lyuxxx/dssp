//
//  InfoMessageUserCell.m
//  dssp
//
//  Created by yxliu on 2018/2/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "InfoMessageUserCell.h"
#import "NSString+Size.h"
#import "UserModel.h"
#import <UIImageView+SDWebImage.h>
#import "UIImageView+WebCache.h"
@interface InfoMessageUserCell ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *bubble;

@property (nonatomic, strong) UserModel *userModel;
@end

@implementation InfoMessageUserCell

#pragma mark- 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    InfoMessageUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoMessageUserCell"];
    if (!cell) {
        cell = [[InfoMessageUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoMessageUserCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark- 搭建界面
- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    //  时间的Label
    self.timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _timeLabel.font = [UIFont fontWithName:FontName size:11];
    _timeLabel.preferredMaxLayoutWidth = 150 * WidthCoefficient;
    
    [self.contentView addSubview:_timeLabel];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(0 * WidthCoefficient);
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(10 * WidthCoefficient);
    }];
    
    //  头像
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *imagePath = [path stringByAppendingString:UserHead];
    NSLog(@"imageFile->>%@",imagePath);
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imagePath];
    self.avatar = [[UIImageView alloc] init];
    self.avatar.image = selfPhoto;
    self.avatar.clipsToBounds=YES;
    self.avatar.layer.cornerRadius=40 * HeightCoefficient/2;
    
    [self.contentView addSubview:self.avatar];
    [self.avatar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel).offset(20 * WidthCoefficient);
        make.right.equalTo(-16 * WidthCoefficient);
        make.width.height.equalTo(40 * WidthCoefficient);
    }];
    
    //  输入的文字label
    self.label = [[UILabel alloc] init];
    self.label.font = [UIFont fontWithName:FontName size:14];
    self.label.textColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.preferredMaxLayoutWidth = 220 * WidthCoefficient;
    [self.contentView addSubview:self.label];
    [self.label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatar).offset(10 * WidthCoefficient);
        make.right.equalTo(_avatar.left).offset(-18 * WidthCoefficient);
        make.width.equalTo(90 * WidthCoefficient);
        make.height.equalTo(21 * WidthCoefficient);
    }];
    
    //  用户背景
    self.bubble = [[UIImageView alloc] init];
    self.bubble.image = [UIImage imageNamed:@"用户背景"];
    [self.contentView addSubview:self.bubble];
    [self.bubble makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_label).offset(UIEdgeInsetsMake(-10 * WidthCoefficient, -10 * WidthCoefficient, -10 * WidthCoefficient, -10 * WidthCoefficient));
    }];
    [self.contentView insertSubview:self.bubble belowSubview:self.label];
    
}

#pragma mark- Model的set方法
- (void)setMessage:(InfoMessage *)message {
    _message = message;
    if (message.type == InfoMessageTypeOther) {
        return;
    }
    
    _timeLabel.text = [self stringFromDate:message.time];
    [_timeLabel updateConstraints:^(MASConstraintMaker *make) {
        if (message.showTime) {
            make.height.equalTo(20 * WidthCoefficient);
        } else {
            make.height.equalTo(0 * WidthCoefficient);
        }
    }];
    
    self.label.text = message.text;
    CGSize size = [message.text stringSizeWithContentSize:CGSizeMake(220 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:15]];
    [_label updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(size.width);
        make.height.equalTo(size.height);
    }];
    
    [self layoutIfNeeded];
    message.cellHeight = CGRectGetMaxY(self.bubble.frame) + 20 * WidthCoefficient;
}

#pragma mark- NSDate转字符串
- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M月d日 HH:mm";
    return [formatter stringFromDate:date];
}

@end
