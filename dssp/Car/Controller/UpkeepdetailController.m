//
//  UpkeepdetailController.m
//  dssp
//
//  Created by qinbo on 2018/2/5.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "UpkeepdetailController.h"

@interface UpkeepdetailController ()
@property(nonatomic,strong) UIImageView *Img;
@end

@implementation UpkeepdetailController
- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"DS保养计划", nil);
    [self setupUI];
    [self requestData];
}


-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:[NSString stringWithFormat:@"%@/maintain",queryImgStore] parameters:@{} success:^(id responseData) {
        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            [self setupUI];
            NSArray *dataArray = dic[@"data"][@"images"];
            NSDictionary *ss  =dataArray[0];
            [self.Img sd_setImageWithURL:[NSURL URLWithString:ss[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@""]];
           
        } else {
            [hud hideAnimated:YES];
            [self blankUI];
//            [MBProgressHUD showText:@"暂无数据"];
        }
    } failure:^(NSInteger code) {
        [hud hideAnimated:YES];
        [self blankUI];
//        [MBProgressHUD showText:@"暂无数据"];
        //        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
    }];
}

-(void)setupUI
{
   self.Img = [[UIImageView alloc] init];
//    _Img.image = [UIImage imageNamed:@"DS 保养规则"];
    [self.view addSubview:_Img];
    [_Img makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.bottom.equalTo(0);
        make.right.equalTo(0);
    }];
}

-(void)blankUI{
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"暂无内容"];
    [bgImgV setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top .equalTo(50 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.height.equalTo(175 * HeightCoefficient);
        make.width.equalTo(278 * WidthCoefficient);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
