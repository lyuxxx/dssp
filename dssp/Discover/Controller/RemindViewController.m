//
//  RemindViewController.m
//  dssp
//
//  Created by yxliu on 2017/12/18.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "RemindViewController.h"
#import <YYCategories.h>
@interface RemindViewController ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *msgLabel;

@end

@implementation RemindViewController

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message {
    self = [super init];
    if (self) {
        self.image = image;
        self.intro = title;
        self.message = message;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.intro;
    self.view.backgroundColor=[UIColor colorWithHexString:@"#F9F8F8"];
    [self requestNoticeData];
  
    [self setupUI];
}


-(void)requestNoticeData1
{
    
    NSDictionary *paras = @{
                            @"readStatus":@"1",
                            @"isDel":@"0",
                            @"id":_noticeId
                            };
    [CUHTTPRequest POST:updateReadStatusOrIsDelByVinAndType parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//            NoticedatailModel *notice = [NoticedatailModel yy_modelWithDictionary:dic[@"data"]];
//            self.notice = notice;
            
        } else {
            
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        
        
        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
        
    }];
}

-(void)requestNoticeData
{
    NSDictionary *paras = @{
                            @"vin":_vin,
                            @"businType":_businType
                            };
    [CUHTTPRequest POST:findAppPushInboxInfoByVin parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
               NoticedatailModel *notice = [NoticedatailModel yy_modelWithDictionary:dic[@"data"]];
               self.notice = notice;
              [self requestNoticeData1];
        } else {
         
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        
      
        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
        
    }];
}

-(void)setNotice:(NoticedatailModel *)notice
{
    _titleLabel.text = notice.title;
    _msgLabel.text = notice.noticeData;
}

- (void)setupUI {
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.backgroundColor = [UIColor whiteColor];
    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
    whiteV.layer.shadowRadius = 7;
    whiteV.layer.shadowOpacity = 0.5;
    [self.view addSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(359 * WidthCoefficient, 130 * HeightCoefficient));
        make.top.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
    }];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"详细_预约保养_icon"];
    [self.view addSubview:imgV];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(48 * WidthCoefficient, 48 * WidthCoefficient));
        make.top.equalTo(20 * HeightCoefficient);
        make.centerX.equalTo(0);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#040000"];
    [whiteV addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(34 * HeightCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.centerX.equalTo(0);
    }];
    
    self.msgLabel = [[UILabel alloc] init];
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    _msgLabel.numberOfLines = 0;
    _msgLabel.font = [UIFont fontWithName:FontName size:13];
    _msgLabel.textColor = [UIColor colorWithHexString:@"#666666"];
  
    [whiteV addSubview:_msgLabel];
    [_msgLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(66.5 * HeightCoefficient);
        make.width.equalTo(343 * WidthCoefficient);
        make.centerX.equalTo(0);
        make.bottom.equalTo(whiteV);
    }];
}

@end
