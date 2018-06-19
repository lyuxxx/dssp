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

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    InfoMessageUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoMessageUserCell"];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self pullData];
    }
    return self;
}

-(void)pullData
{
    NSDictionary *paras = @{
                          
                            };
    [CUHTTPRequest POST:queryUser parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            NSDictionary *dic1 = dic[@"data"];
            self.userModel = [UserModel yy_modelWithDictionary:dic1];
            
            [self.avatar sd_setImageWithURL:[NSURL URLWithString:_userModel.headPortrait] placeholderImage:[UIImage imageNamed:@"默认头像"]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.avatar downloadImage:_userModel.headPortrait placeholder:nil success:^(CUImageCacheType cacheType, UIImage *image) {
//
//                } failure:^(NSError *error) {
//
//                } received:^(CGFloat progress) {
//
//                }];
//            });
            
        } else {
            
//            [MBProgressHUD showText:dic[@"msg"]];
        }
        
        
    } failure:^(NSInteger code) {
        
        
    }];
    
    
    
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f9f8f8"];
    self.contentView.backgroundColor = [UIColor clearColor];
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
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"photo.png"];
    NSLog(@"imageFile->>%@",imageFilePath);
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];
    self.avatar = [[UIImageView alloc] init];
//    self.avatar.image = selfPhoto?selfPhoto:[UIImage imageNamed:@"用户头像"];
    
    self.avatar.clipsToBounds=YES;
    self.avatar.layer.cornerRadius=40 * HeightCoefficient/2;
//      self.avatar.image = [UIImage imageNamed:_userModel.headPortrait];
    
    [self.contentView addSubview:self.avatar];
    [self.avatar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel).offset(20 * WidthCoefficient);
        make.right.equalTo(-16 * WidthCoefficient);
        make.width.height.equalTo(40 * WidthCoefficient);
    }];
    
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
    
    self.bubble = [[UIImageView alloc] init];
    self.bubble.image = [UIImage imageNamed:@"用户背景"];
    [self.contentView addSubview:self.bubble];
    [self.bubble makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_label).offset(UIEdgeInsetsMake(-10 * WidthCoefficient, -10 * WidthCoefficient, -10 * WidthCoefficient, -10 * WidthCoefficient));
    }];
    [self.contentView insertSubview:self.bubble belowSubview:self.label];
    
}

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

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M月d日 HH:mm";
    return [formatter stringFromDate:date];
}

@end
