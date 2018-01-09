//
//  MineViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/1.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "MineViewController.h"
#import <YYCategoriesSub/YYCategories.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "RNRViewController.h"
#import "CarInfoViewController.h"
#import "VINBindingViewController.h"
#import "MineCell.h"
#import <MBProgressHUD+CU.h>
#import <CUHTTPRequest.h>
#import "CarBindingViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <YYText.h>
#import "RealVinViewcontroller.h"
#import "ContractViewController.h"
#import "ContractdetailViewController.h"
#import "CarUnbindViewController.h"
#import "AccountViewController.h"
#import "LoginViewController.h"
#import <CUAlertController.h>
#import "PersonInViewController.h"
#import "RealnameViewController.h"
#import "InputAlertView.h"
#import "BindCarViewController.h"
@interface MineViewController() <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray<NSArray *> *dataArray;
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UIButton *setBtn;
@property (nonatomic, strong) UIImageView *img;
@property(nonatomic, strong) NSData *fileData;
@property(nonatomic, copy) NSString *certificationStatus;
//@property (nonatomic, strong) YYLabel *locationLabel;
@property(nonatomic,strong) CLLocationManager *mgr;
@property(nonatomic, copy) NSString *locationName;
@property(nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *bindingBtn;
@end

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = NSLocalizedString(@"", nil);
    
    self.navigationController.navigationBarHidden = YES;
    
    _dataArray=@[@[@[@"coin",@"绑定车辆 / 解绑车辆"],@[@"身份证",@"车辆信息"],@[@"汽车信息",@"实名制"],@[@"合同信息",@"服务合同信息"],@[@"密码",@"账户密码管理"]],
  @[@[@"signout",@"退出登录"]]];
    
    
//    [self RealnameUserName];
    [self initTableView];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mgr startUpdatingLocation];
}


- (CLLocationManager *)mgr
{
    if (_mgr == nil) {
        // 实例化位置管理者
        _mgr = [[CLLocationManager alloc] init];
        // 指定代理,代理中获取位置数据
        _mgr.delegate = self;
        // 设置定位所需的精度 枚举值 精确度越高越耗电
        self.mgr.desiredAccuracy = kCLLocationAccuracyBest;
        // 每100米更新一次定位
        self.mgr.distanceFilter = 100;

        // 兼容iOS8之后的方法
        if ([_mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_mgr requestWhenInUseAuthorization];
        }
    }
    return _mgr;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败");
    [_mgr stopUpdatingLocation];//关闭定位
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"定位成功");
    [_mgr stopUpdatingLocation];//关闭定位
    
    CLLocation *newLocation = locations[0];
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude, newLocation.coordinate.longitude]);
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *test = [placemark addressDictionary];
            _locationName=[[test objectForKey:@"State"] stringByAppendingString:[test objectForKey:@"City"]];
             self.locationStr = _locationName;
        }
    }];
}

- (void)setLocationStr:(NSString *)locationStr
{
    _locationLabel.text=NSLocalizedString(locationStr, nil);
}

/// 代理方法中监听授权的改变,被拒绝有两种情况,一是真正被拒绝,二是服务关闭了
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户未决定");
            break;
        }
            // 系统预留字段,暂时还没用到
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"受限制");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 被拒绝有两种情况 1.设备不支持定位服务 2.定位服务被关闭
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"真正被拒绝");
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                               message:@"请在设置中打开定位服务功能！"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    //响应事件
                    // 跳转到设置界面
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        
                        [[UIApplication sharedApplication] openURL:url];
                    }
                    
                }];
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                }];
                [alert addAction:defaultAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            else {
                NSLog(@"没有开启此功能");
            }
            break;
        }
      
        default:
            break;
    }
}


-(void)initTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
//    _tableView.tableFooterView = [UIView new];
//    _tableView.tableHeaderView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    adjustsScrollViewInsets_NO(_tableView,self);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //不回弹
    _tableView.bounces=NO;
    //滚动条隐藏
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor=[UIColor colorWithHexString:@"#F9F8F8"];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, kTabbarHeight, 0));
    }];
}

-(void)setupUI
{
    
   
    
    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,183.5*HeightCoefficient+kStatusBarHeight)];
    _headerView.backgroundColor=[UIColor whiteColor];
    _tableView.tableHeaderView=_headerView;
    
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"backgroud_mine"];
    [_headerView addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(140*HeightCoefficient+kStatusBarHeight);
        make.width.equalTo(kScreenWidth);
        make.left.equalTo(0);
    }];
    
    
    UIView *whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 4;
    whiteView.layer.shadowOpacity = 0.5;// 阴影透明度
    whiteView.layer.shadowOffset = CGSizeMake(0,7.5);
    whiteView.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    whiteView.layer.shadowRadius = 20.5;//阴影半径，默认3
    [_headerView addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(63.5 * HeightCoefficient+kStatusBarHeight);
        make.height.equalTo(100 * HeightCoefficient);
        make.width.equalTo(343 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
    }];
    
    
    self.setBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [_setBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_setBtn setContentMode:UIViewContentModeScaleAspectFit];
    _setBtn.titleLabel.font = [UIFont fontWithName:FontName size:13];
    _setBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_setBtn setImage:[UIImage imageNamed:@"robot"] forState:UIControlStateNormal];
    [_setBtn setTitleColor:[UIColor colorWithHexString:GeneralColorString] forState:UIControlStateNormal];
    [_headerView addSubview:_setBtn];
    [_setBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10.5 * HeightCoefficient+kStatusBarHeight);
        make.right.equalTo(-16 * WidthCoefficient);
        make.width.equalTo(24 * WidthCoefficient);
        make.height.equalTo(24 * WidthCoefficient);
    }];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];
    
    //头像
    self.photoBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [_photoBtn setImage:selfPhoto?selfPhoto:[UIImage imageNamed:@"avatar"] forState:UIControlStateNormal];
    [_photoBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _photoBtn.titleLabel.font = [UIFont fontWithName:FontName size:13];
    _photoBtn.clipsToBounds=YES;
    _photoBtn.layer.cornerRadius=60 * HeightCoefficient/2;


    [whiteView addSubview:_photoBtn];
    [_photoBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20 * HeightCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
        make.width.equalTo(60 * HeightCoefficient);
        make.height.equalTo(60 * HeightCoefficient);
    }];

    
    UILabel *namelabel = [[UILabel alloc] init];
    namelabel.font=[UIFont fontWithName:FontName size:16];
    namelabel.textColor=[UIColor colorWithHexString:@"#333333"];
    namelabel.text=NSLocalizedString(@"xxxxxx", nil);
    namelabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:namelabel];
    [namelabel makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(26*HeightCoefficient);
        make.height.equalTo(20 * HeightCoefficient);
          make.left.equalTo(_photoBtn.right).offset(10 * WidthCoefficient);
        make.width.equalTo(98 * WidthCoefficient);
    }];

    
    UIImageView *locationImg = [[UIImageView alloc] init];
    locationImg.contentMode = UIViewContentModeScaleAspectFit;
    locationImg.image = [UIImage imageNamed:@"location_mine"];
    [whiteView addSubview:locationImg];
    [locationImg makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(namelabel.bottom).offset(11.5*HeightCoefficient);
        make.left.equalTo(_photoBtn.right).offset(10 * WidthCoefficient);
        make.width.equalTo(12 * WidthCoefficient);
         make.height.equalTo(12 * HeightCoefficient);
    }];

    self.locationLabel= [[UILabel alloc] init];
    _locationLabel.font=[UIFont fontWithName:FontName size:11];
    _locationLabel.textColor=[UIColor colorWithHexString:@"#666666"];
    _locationLabel.text=NSLocalizedString(_locationName?_locationName:@"未获取到当前位置", nil);
    _locationLabel.textAlignment = NSTextAlignmentLeft;
    [whiteView addSubview:_locationLabel];
    [_locationLabel makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(namelabel.bottom).offset(10*HeightCoefficient);
        make.left.equalTo(_photoBtn.right).offset(22 * WidthCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.width.equalTo(150 * WidthCoefficient);
    }];
    
    
    self.bindingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bindingBtn.frame=CGRectMake(283 * WidthCoefficient, 20*HeightCoefficient, 60 * WidthCoefficient, 24 *HeightCoefficient);
//    _bindingBtn.layer.cornerRadius = 24 * HeightCoefficient/2;
    [_bindingBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bindingBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [_bindingBtn setTitle:NSLocalizedString(@"未绑定", nil) forState:UIControlStateNormal];
    [_bindingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _bindingBtn.titleLabel.font = [UIFont fontWithName:FontName size:14];
    [whiteView addSubview:_bindingBtn];
//    [_bindingBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(60 * WidthCoefficient);
//        make.height.equalTo(24 * HeightCoefficient);
//        make.right.equalTo(0 *WidthCoefficient);
//        make.top.equalTo(20 * HeightCoefficient);
//    }];
   
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bindingBtn.bounds   byRoundingCorners:UIRectCornerBottomLeft |    UIRectCornerTopLeft   cornerRadii:CGSizeMake(24 * HeightCoefficient/2, 24 * HeightCoefficient/2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _bindingBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    _bindingBtn.layer.mask = maskLayer;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray[section].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*HeightCoefficient;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20*HeightCoefficient;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *viewss=[UIView new];
//    viewss.frame=CGRectMake(0, 0,375 , 0.0001);
//    viewss.backgroundColor=[UIColor redColor];
//
//   return viewss;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHFooterInSection:(NSInteger)section
//{
//
//    UIView *views=[UIView new];
//    views.frame=CGRectMake(0, 0,375 , 20*HeightCoefficient);
//    views.backgroundColor=[UIColor redColor];
//    return views;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MineCellName";
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.img.image = [UIImage imageNamed:_dataArray[indexPath.section][indexPath.row][0]];
    cell.lab.text =_dataArray[indexPath.section][indexPath.row][1];
    cell.arrowImg.image=[UIImage imageNamed:@"arrownext"];
    if (indexPath.section==0) {
//        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//        NSString *isCodeName = [defaults objectForKey:@"isCodeName"];
        if (indexPath.row==0) {
            
            
//            NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
//            NSString *vin = [defaults1 objectForKey:@"vin"];
            cell.lab.text = [kVin isEqualToString:@"0"]?NSLocalizedString(@"车辆绑定", nil):NSLocalizedString(@"解绑车辆", nil);
            
            
//            [cell.lab updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(19 * HeightCoefficient);
//                make.height.equalTo(22 * HeightCoefficient);
//                make.width.equalTo(211 * WidthCoefficient);
//                make.left.equalTo(59 * WidthCoefficient);
//
//            }];
            
        }
        if (indexPath.row==1) {
//            if ([_certificationStatus isEqualToString:@"0"]||[_certificationStatus isEqualToString:@"2"]||[_certificationStatus isEqualToString:@"4"]) {
//               cell.realName.text=_certificationStatus?NSLocalizedString(@"待实名", nil):NSLocalizedString(@"未实名", nil);
//            }
//            else if ([_certificationStatus isEqualToString:@"3"])
//            {
//                 cell.realName.text=NSLocalizedString(@"", nil);
//            }
//            else if (isCodeName)
//            {
//                //如果实名认证成功，code返回200，就显示已实名
//                cell.realName.text=NSLocalizedString(@"已实名", nil);
//            }
//            else
//            {
//               cell.realName.text=_certificationStatus?NSLocalizedString(@"已实名", nil):NSLocalizedString(@"未实名", nil);
//            }
        }
        if (indexPath.row==4) {
            cell.whiteView.hidden=YES;
        }
    }
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.whiteView.hidden=YES;
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
//            NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
//            NSString *vin = [defaults1 objectForKey:@"vin"];
//            
            if ([kVin isEqualToString:@"0"]) {
                
                VINBindingViewController *vc=[[VINBindingViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            else
            {
                BindCarViewController *vc =[[BindCarViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
               
            }
        }else if (indexPath.row == 1)
        {
            CarUnbindViewController *vc=[[CarUnbindViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
           
            
//            if ([_certificationStatus isEqualToString:@"0"]||[_certificationStatus isEqualToString:@"2"]) {
//
//                RNRViewController *vc=[[RNRViewController alloc] init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//            else if([_certificationStatus isEqualToString:@"1"])
//            {
//
//            }
//            else if([_certificationStatus isEqualToString:@"3"])
//            {
//                [MBProgressHUD showText:NSLocalizedString(@"非T客户不需要实名", nil)];
//            }
//            else if([_certificationStatus isEqualToString:@"4"])
//            {
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
//                        message:@"当前用户未绑定车辆,请绑定！"
//                    preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                    //响应事件
//                    VINBindingViewController *vc=[[VINBindingViewController alloc] init];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:vc animated:YES];
//
//                }];
//                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//
//                }];
//                [alert addAction:defaultAction];
//                [alert addAction:cancelAction];
//                [self presentViewController:alert animated:YES completion:nil];
//
//            }
        }else if (indexPath.row == 2)
        {
            
            RealnameViewController *vc=[[RealnameViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            

        
        }else if (indexPath.row == 3)
        {
            ContractViewController *vc=[[ContractViewController                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else if (indexPath.row == 4)
        {
            AccountViewController *vc=[[AccountViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row==0) {
            
            InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            [InputalertView initWithTitle:@"是否退出登录?" img:@"警告" type:10 btnNum:2 btntitleArr:[NSArray arrayWithObjects:@"是",@"否", nil] ];
//            InputalertView.delegate = self;
            UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
            [keywindow addSubview: InputalertView];
            
            InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
                if (btn.tag == 100) {//左边按钮
                   
                    NSDictionary *paras = @{
                                            
                                        };
                    
                MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
                [CUHTTPRequest POST:loginout parameters:paras success:^(id responseData) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                                if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                                    [hud hideAnimated:YES];
                                    //响应事件
                                    LoginViewController *vc=[[LoginViewController alloc] init];
                                    vc.hidesBottomBarWhenPushed = YES;
                                    [self.navigationController pushViewController:vc animated:YES];
                                    } else {
                                    [MBProgressHUD showText:dic[@"msg"]];
                                    }
                                    } failure:^(NSInteger code) {
                                                                hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
                                                                [hud hideAnimated:YES afterDelay:1];
                                                            }];
                    
                    
                }
                if(btn.tag ==101)
                {
                    //右边按钮
                    NSLog(@"666%@",str);
                    
                   
                
                    
                    
                }
                
            };
            
//            NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"是否退出登录?" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]}];
//
//            CUAlertController *alert = [CUAlertController alertWithImage:[UIImage imageNamed:@"警告"] attributedMessage:message];
//            [alert addButtonWithTitle:@"是" type:CUButtonTypeCancel clicked:^{
//
//
//                NSDictionary *paras = @{
//
//                                        };
//
//                MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
//                [CUHTTPRequest POST:loginout parameters:paras success:^(id responseData) {
//                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//                    if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
//                        [hud hideAnimated:YES];
//                        //响应事件
//                        LoginViewController *vc=[[LoginViewController alloc] init];
//                        vc.hidesBottomBarWhenPushed = YES;
//                        [self.navigationController pushViewController:vc animated:YES];
//                    } else {
//                        [MBProgressHUD showText:dic[@"msg"]];
//                    }
//                } failure:^(NSInteger code) {
//                    hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
//                    [hud hideAnimated:YES afterDelay:1];
//                }];
//
//
//            }];
//            [alert addButtonWithTitle:@"否" type:CUButtonTypeNormal clicked:^{
//
//            }];
//            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }
    
}

- (void)BtnClick:(UIButton *)sender {
    
    if (sender == self.setBtn) {
        
        
    }
    if (sender ==self.photoBtn) {
        
        PersonInViewController *vc=[[PersonInViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        
//        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//            NSLog(@"点击取消");
//            
//        }]];
//        
//        [alertController addAction:[UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.delegate = self;
//            imagePicker.allowsEditing = YES;
//            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            [self presentViewController:imagePicker animated:YES completion:nil];
//            
//        }]];
//        
//        [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.delegate = self;
//            imagePicker.allowsEditing = YES;
//            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            [self presentViewController:imagePicker animated:YES completion:nil];
//            
//        }]];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
    }
    if (sender==self.bindingBtn) {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
   
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
//        UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(80, 80)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    [_photoBtn setImage:selfPhoto forState:UIControlStateNormal];
  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



//保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

- (void)RealnameUserName {
    NSDictionary *paras = @{
                            @"userName": @"",
                            @"Vin": @""
                            };
    [CUHTTPRequest POST:queryCustByMobile parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            _certificationStatus=[dic[@"data"] objectForKey:@"certificationStatus"];
        }
    } failure:^(NSInteger code) {
        
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
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    UIViewController *vc = [[NSClassFromString(@"VINBindingViewController") alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
@end

