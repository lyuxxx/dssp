//
//  RemindViewController.m
//  dssp
//
//  Created by yxliu on 2017/12/18.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "RemindViewController.h"
#import <YYCategories.h>
#import "NoticeViewController.h"
#import "LllegalViewController.h"
@interface RemindViewController ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *msgLabel;
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UILabel *content;

@end

@implementation RemindViewController

- (BOOL)needGradientBg {
    return YES;
}

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
    self.navigationItem.title = _noticeModel.title;
    self.view.backgroundColor=[UIColor colorWithHexString:@"#F9F8F8"];
    [self requestNoticeData];
  
    [self setupUI];
}

-(void)requestNoticeData1
{
    NSDictionary *paras = @{
                            @"readStatus":@"1",
                            @"isDel":@"0",
                            @"id":_noticeModel.noticeId
                            };
    [CUHTTPRequest POST:updateReadStatusOrIsDelByVinAndType parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//            NoticedatailModel *notice = [NoticedatailModel yy_modelWithDictionary:dic[@"data"]];
//            self.notice = notice;
//            NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
//            [defaults1 setObject:@"1" forKey:@"notice"];
//            [defaults1 synchronize];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"NoticeVCneedRefresh" object:nil userInfo:nil];
            
        } else {
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        
        
///[MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
        
    }];
}

-(void)requestNoticeData
{
    NSDictionary *paras = @{
//                            @"vin":_vin,
//                            @"businType":_businType
                            };
    
    NSString *findAppPushByVin = [NSString stringWithFormat:@"%@/%@",findAppPushInboxInfoById,_noticeModel.noticeId];
    
    [CUHTTPRequest POST:findAppPushByVin parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
               NoticedatailModel *notice = [NoticedatailModel yy_modelWithDictionary:dic[@"data"]];
               self.notice = notice;
              [self requestNoticeData1];
        } else {
         
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
//        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
        
    }];
}


-(void)setNotice:(NoticedatailModel *)notice
{
    //宽度
    CGFloat contentW = self.view.bounds.size.width - 34;
    //label的字体 HelveticaNeue  Courier
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
    _content.font = fnt;
    // iOS7中用以下方法替代过时的iOS6中的sizeWithFont:constrainedToSize:lineBreakMode:方法
    CGRect tmpRect = [notice.noticeData boundingRectWithSize:CGSizeMake(contentW, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
    // 高度H
    CGFloat contentH = tmpRect.size.height;
    NSLog(@"调整后的显示宽度:%f,显示高度:%f",contentW,contentH);
    
    UIView *whiteV = [[UIView alloc] init];
    whiteV.layer.cornerRadius = 4;
    whiteV.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
//    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
//    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
//    whiteV.layer.shadowRadius = 7;
//    whiteV.layer.shadowOpacity = 0.5;
    [self.view addSubview:whiteV];
//    [self.view insertSubview:_content aboveSubview:whiteV];
    [whiteV makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(359 * WidthCoefficient, 140 * HeightCoefficient));
        make.top.equalTo(20 * HeightCoefficient);
        make.centerX.equalTo(0);
    }];
    
    
    self.imgV = [[UIImageView alloc] init];
     _imgV.userInteractionEnabled = YES;
    [whiteV addSubview:_imgV];
    [_imgV makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(48 * WidthCoefficient, 48 * WidthCoefficient));
        make.top.equalTo(-24 * WidthCoefficient);
        make.centerX.equalTo(0);
    }];
    
    
    UILabel *topLabel = [[UILabel alloc] init];
   
    topLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    topLabel.textColor = [UIColor colorWithHexString:@"#AC0042"];
    //    botLabel.backgroundColor =[UIColor redColor];
    [whiteV addSubview:topLabel];
    [topLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16 * WidthCoefficient);
        make.top.equalTo(10 * HeightCoefficient);
        make.right.equalTo(-16 * WidthCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    
    
    _content = [[UILabel alloc] init];
//    _content.frame = CGRectMake(17, 30, self.view.frame.size.width-34, 120);
    _content.textColor = [UIColor colorWithHexString:@"#999999"];
//        _content.backgroundColor = [UIColor redColor];
    _content.clipsToBounds = YES;
    _content.clipsToBounds = YES;
    _content.numberOfLines = 0;
     _content.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    _content.text =notice.noticeData;
    if (contentH > 30) {
         _content.textAlignment = NSTextAlignmentLeft;
    }
    else
    {
        _content.textAlignment = NSTextAlignmentLeft;
    }
   
    [whiteV addSubview:_content];
    [_content makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(20 * HeightCoefficient);
                make.left.equalTo(16 * WidthCoefficient);
                make.right.equalTo(-16 * WidthCoefficient);
                make.bottom.equalTo (-20 *HeightCoefficient);
            }];
    
    
    if ([notice.businType isEqualToString:@"maintenance_notice"]) {

         topLabel.text = NSLocalizedString(@"保养提醒", nil);
//         _imgV.image = [UIImage imageNamed:@"详细_预约保养_icon"];
    }
    if ([notice.businType isEqualToString:@"CaTtheft"]) {
         topLabel.text = NSLocalizedString(@"盗车提醒", nil);
//         _imgV.image = [UIImage imageNamed:@"详细_盗车提醒_icon"];
    }
    if ([notice.businType isEqualToString:@"flow"]) {
         topLabel.text = NSLocalizedString(@"流量查询", nil);
//         _imgV.image = [UIImage imageNamed:@"详细_流量查询_icon"];
    }
    if ([notice.businType isEqualToString:@"svn"]) {
        topLabel.text = NSLocalizedString(@"盗车提醒", nil);
//         _imgV.image = [UIImage imageNamed:@"详细_盗车提醒_icon"];
    }
    if ([notice.businType isEqualToString:@"violation"]) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [whiteV addGestureRecognizer:tapGesture];
//        _imgV.userInteractionEnabled = YES;

        topLabel.text = NSLocalizedString(@"违章提醒", nil);
//        _imgV.image = [UIImage imageNamed:@"违章提醒_icon"];
    }
    
    
}

-(void)clickImage
{
    LllegalViewController *vc =[[LllegalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupUI {
//    UIView *whiteV = [[UIView alloc] init];
//    whiteV.layer.cornerRadius = 4;
//    whiteV.backgroundColor = [UIColor whiteColor];
//    whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
//    whiteV.layer.shadowOffset = CGSizeMake(0, 4);
//    whiteV.layer.shadowRadius = 7;
//    whiteV.layer.shadowOpacity = 0.5;
//    [self.view addSubview:whiteV];
//    [whiteV makeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(CGSizeMake(359 * WidthCoefficient, 130 * HeightCoefficient));
//        make.top.equalTo(44 * HeightCoefficient);
//        make.centerX.equalTo(0);
//    }];
//
  
    
//    self.titleLabel = [[UILabel alloc] init];
//    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
//    _titleLabel.textColor = [UIColor colorWithHexString:@"#040000"];
//    [whiteV addSubview:_titleLabel];
//    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(34 * HeightCoefficient);
//        make.height.equalTo(22.5 * HeightCoefficient);
//        make.centerX.equalTo(0);
//    }];
    
//    self.contentlabel =[[UITextView alloc] init];
//    _contentlabel.editable = NO;
//    [self.view addSubview:_contentlabel];
//    [_contentlabel makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(0 * WidthCoefficient);
//        make.bottom.equalTo(0 * HeightCoefficient);
//        make.left.equalTo(0 * WidthCoefficient);
//        make.top.equalTo(0 * HeightCoefficient);
//    }];
//
    
    
    //根据正文内容多少，动态确定正文content的frame
    
  
    
    
   
    
    
    
//    self.msgLabel = [[UITextView alloc] init];
//    _msgLabel.textAlignment = NSTextAlignmentLeft;
////    _msgLabel.numberOfLines = 0;
//    _msgLabel.editable = NO;
//    _msgLabel.font = [UIFont fontWithName:FontName size:13];
//    _msgLabel.textColor = [UIColor colorWithHexString:@"#666666"];
//    [whiteV addSubview:_msgLabel];
//    [_msgLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(20 * HeightCoefficient);
//        make.left.equalTo(16 * WidthCoefficient);
//        make.right.equalTo(-16 * WidthCoefficient);
//        make.bottom.equalTo (-10 *HeightCoefficient);
//    }];
}

@end
