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
@interface MineViewController() <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray<NSArray *> *dataArray;
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UIButton *setBtn;
@property (nonatomic, strong) UIImageView *img;
@property(nonatomic, strong) NSData *fileData;
@property(nonatomic, copy) NSString *certificationStatus;
@property (nonatomic, strong) YYLabel *locationLabel;
@property(nonatomic,strong) CLLocationManager *mgr;
@property(nonatomic, copy) NSString *locationName;
@end

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = NSLocalizedString(@"", nil);
    
    self.navigationController.navigationBarHidden = YES;
    
    _dataArray=@[@[@[@"coin",@"我的积分 / 优惠券"],@[@"身份证",@"实名认证"],@[@"汽车信息",@"车辆信息"],@[@"合同信息",@"合同信息"],@[@"密码",@"账户密码"]],
  @[@[@"客服",@"联系客服"],@[@"反馈中心",@"反馈中心"]],@[@[@"常见问题",@"常见问题"],@[@"功能介绍",@"功能介绍"]]];
    
    [self RealnameUserName:@""];
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
    
    if (![_locationStr isEqualToString:locationStr]) {
        _locationStr = locationStr;
        NSMutableAttributedString *location = [NSMutableAttributedString new];
        UIFont *locationFont = [UIFont fontWithName:FontName size:13];
        NSMutableAttributedString *attachment = nil;
        UIImage *locationImage = [UIImage imageNamed:@"location"];
        attachment = [NSMutableAttributedString yy_attachmentStringWithContent:locationImage contentMode:UIViewContentModeCenter attachmentSize:locationImage.size alignToFont:locationFont alignment:YYTextVerticalAlignmentCenter];
        [location appendAttributedString:attachment];
        [location yy_appendString:_locationStr];
        location.yy_alignment = NSTextAlignmentCenter;
        [location addAttributes:@{NSFontAttributeName:locationFont,NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [_locationStr rangeOfString:_locationStr].length + 1)];
        _locationLabel.attributedText = location;
        CGSize size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:location];
        [self.headerView addSubview:_locationLabel];
        [_locationLabel updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(layout.textBoundingRect.size.width + 15 * WidthCoefficient);
        }];
        [self.headerView layoutIfNeeded];
    }
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
    _tableView.backgroundColor=[UIColor colorWithHexString:@"#EEEEEE"];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, kTabbarHeight, 0));
    }];
}

-(void)setupUI
{
    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,251*HeightCoefficient+kStatusBarHeight)];
    _headerView.backgroundColor=[UIColor whiteColor];
    _tableView.tableHeaderView=_headerView;
    
    
    UIImageView *bgImgV = [[UIImageView alloc] init];
    bgImgV.image = [UIImage imageNamed:@"个人中心"];
    [_headerView addSubview:bgImgV];
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(190*HeightCoefficient+kStatusBarHeight);
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
        make.top.equalTo(147.5 * HeightCoefficient+kStatusBarHeight);
        make.height.equalTo(83.5 * HeightCoefficient);
        make.width.equalTo(343 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
    }];
    
    
    self.setBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [_setBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_setBtn setContentMode:UIViewContentModeScaleAspectFit];
    _setBtn.titleLabel.font = [UIFont fontWithName:FontName size:13];
    _setBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_setBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [_setBtn setTitleColor:[UIColor colorWithHexString:GeneralColorString] forState:UIControlStateNormal];
    [_headerView addSubview:_setBtn];
    [_setBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10.5 * HeightCoefficient+kStatusBarHeight);
        make.right.equalTo(-16 * WidthCoefficient);
        make.width.equalTo(23 * WidthCoefficient);
        make.height.equalTo(23 * WidthCoefficient);
    }];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];
    //头像
    self.photoBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [_photoBtn setImage:selfPhoto forState:UIControlStateNormal];
    [_photoBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _photoBtn.titleLabel.font = [UIFont fontWithName:FontName size:13];
    _photoBtn.clipsToBounds=YES;
    _photoBtn.layer.cornerRadius=62/2;
    
    
    [_headerView addSubview:_photoBtn];
    [_photoBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_setBtn.bottom).offset(-4 * HeightCoefficient);
        make.centerX.equalTo(_headerView);
        make.width.equalTo(62 * WidthCoefficient);
        make.height.equalTo(62 * WidthCoefficient);
    }];
    
    
    UILabel *namelabel = [[UILabel alloc] init];
    namelabel.font=[UIFont fontWithName:FontName size:16];
    namelabel.textColor=[UIColor colorWithHexString:@"#C4B7A6"];
    namelabel.text=NSLocalizedString(@"秦波", nil);
    namelabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:namelabel];
    [namelabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_photoBtn.bottom).offset(4*HeightCoefficient);
        make.centerX.equalTo(_headerView);
        make.height.equalTo(20 * HeightCoefficient);
        make.width.equalTo(98 * WidthCoefficient);
    }];
    
    
//    UIImageView *locationImg = [[UIImageView alloc] init];
//    locationImg.image = [UIImage imageNamed:@"location"];
//    [_headerView addSubview:locationImg];
//    [locationImg makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(namelabel.bottom).offset(10*HeightCoefficient);
//        make.left.equalTo(146*WidthCoefficient);
//        make.width.height.equalTo(12*WidthCoefficient);
//    }];
//
//
//    UILabel * locationLabel= [[UILabel alloc] init];
//    locationLabel.font=[UIFont fontWithName:FontName size:13];
//    locationLabel.textColor=[UIColor whiteColor];
//    locationLabel.text=NSLocalizedString(@"湖北 武汉", nil);
//    locationLabel.textAlignment = NSTextAlignmentCenter;
//    [_headerView addSubview:locationLabel];
//    [locationLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(namelabel.bottom).offset(6*HeightCoefficient);
//        make.left.equalTo(165*WidthCoefficient);
//        make.height.equalTo(18.5 * HeightCoefficient);
//        make.width.equalTo(60 * WidthCoefficient);
//    }];
    
    self.locationLabel = [[YYLabel alloc] init];
    _locationLabel.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *locationStr = [NSMutableAttributedString new];
    UIFont *locationFont = [UIFont fontWithName:FontName size:13];
    NSMutableAttributedString *attachment = nil;
    UIImage *locationImage = [UIImage imageNamed:@"location"];
    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:locationImage contentMode:UIViewContentModeCenter attachmentSize:locationImage.size alignToFont:locationFont alignment:YYTextVerticalAlignmentCenter];
    [locationStr appendAttributedString:attachment];
    [locationStr yy_appendString:_locationName?_locationName:@"未定位"];
    locationStr.yy_alignment = NSTextAlignmentCenter;
    [locationStr addAttributes:@{NSFontAttributeName:locationFont,NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [_locationName?_locationName:@"未定位" rangeOfString:_locationName?_locationName:@"未定位"].length + 1)];
    _locationLabel.attributedText = locationStr;
    CGSize size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:locationStr];
    [_headerView addSubview:_locationLabel];
    [_locationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(18.5 * HeightCoefficient);
        make.width.equalTo(layout.textBoundingRect.size.width + 15 * WidthCoefficient);
        make.top.equalTo(namelabel.bottom).offset(10 * HeightCoefficient);
    }];
    

    UIImageView *carImg = [[UIImageView alloc] init];
    [carImg setContentMode:UIViewContentModeScaleAspectFit];
    carImg.image = [UIImage imageNamed:@"11"];
    [whiteView addSubview:carImg];
    [carImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(6 * HeightCoefficient);
        make.left.equalTo(7.5 * WidthCoefficient);
        make.width.equalTo(96 * WidthCoefficient);
        make.height.equalTo(72 * WidthCoefficient);
    }];
    
    
    UILabel * plateLabel= [[UILabel alloc] init];
    plateLabel.font=[UIFont fontWithName:FontName size:16];
    plateLabel.font = [UIFont boldSystemFontOfSize:16];
    plateLabel.textColor=[UIColor blackColor];
    plateLabel.text=NSLocalizedString(@"车牌号: 鄂A123456", nil);
    //    plateLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:plateLabel];
    [plateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10 * HeightCoefficient);
        make.left.equalTo(123.5*WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.width.equalTo(155.5 * WidthCoefficient);
    }];
    
    
    UILabel * carStyleLabel= [[UILabel alloc] init];
    carStyleLabel.font=[UIFont fontWithName:FontName size:13];
    carStyleLabel.textColor=[UIColor colorWithHexString:@"#666666"];
    carStyleLabel.text=NSLocalizedString(@"2018款DS 5", nil);
    //    carStyleLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:carStyleLabel];
    [carStyleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(32.5 * HeightCoefficient);
        make.left.equalTo(123.5*WidthCoefficient);
        make.height.equalTo(18.5 * HeightCoefficient);
        make.width.equalTo(155.5 * WidthCoefficient);
    }];
    
    
    UILabel *timeLabel= [[UILabel alloc] init];
    timeLabel.font=[UIFont fontWithName:FontName size:11];
    timeLabel.textColor=[UIColor colorWithHexString:@"#999999"];
    timeLabel.text=NSLocalizedString(@"上次于2017-12-23登录", nil);
    //    carStyleLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:timeLabel];
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(57 * HeightCoefficient);
        make.left.equalTo(123.5*WidthCoefficient);
        make.height.equalTo(15 * HeightCoefficient);
        make.width.equalTo(155.5 * WidthCoefficient);
    }];
    
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
        if (indexPath.row==1) {
            if ([_certificationStatus isEqualToString:@"0"]||[_certificationStatus isEqualToString:@"2"]||[_certificationStatus isEqualToString:@"4"]) {
               cell.realName.text=_certificationStatus?NSLocalizedString(@"待实名", nil):NSLocalizedString(@"未实名", nil);
            }
            else if ([_certificationStatus isEqualToString:@"3"])
            {
                 cell.realName.text=NSLocalizedString(@"", nil);
            }
            else
            {
               cell.realName.text=_certificationStatus?NSLocalizedString(@"已实名", nil):NSLocalizedString(@"未实名", nil);
                
            }
        }
        if (indexPath.row==4) {
            cell.whiteView.hidden=YES;
        }
    }
    
    if (indexPath.section==1) {
        if (indexPath.row==1) {
            cell.whiteView.hidden=YES;
        }
    }
    
    if (indexPath.section==2) {
        if (indexPath.row==1) {
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
            
            
        }else if (indexPath.row == 1)
        {
            if ([_certificationStatus isEqualToString:@"0"]||[_certificationStatus isEqualToString:@"2"]) {
                
                RNRViewController *vc=[[RNRViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if([_certificationStatus isEqualToString:@"1"])
            {
                
            }
            else if([_certificationStatus isEqualToString:@"3"])
            {
                [MBProgressHUD showText:NSLocalizedString(@"非T客户不需要实名", nil)];
            }
            else if([_certificationStatus isEqualToString:@"4"])
            {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPush"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                        message:@"当前用户未绑定车辆,请绑定！"
                    preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    //响应事件
                    VINBindingViewController *vc=[[VINBindingViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }];
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                }];
                [alert addAction:defaultAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
        }else if (indexPath.row == 2)
        {
            VINBindingViewController *vc=[[VINBindingViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 3)
        {
//            CarBindingViewController *vc=[[CarBindingViewController alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 4)
        {
            
        }
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row==0) {
            
            
        }else if (indexPath.row==1)
        {
            
        }
        
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            
            
        }else if (indexPath.row==1)
        {
            
        }
        
        
    }
    
}

- (void)BtnClick:(UIButton *)sender {
    
    if (sender == self.setBtn) {
        
        
    }
    if (sender ==self.photoBtn) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
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
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
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

- (void)RealnameUserName:(NSString *)userName {
    NSDictionary *paras = @{
                          
                            @"userName": userName
                           
                            };
    [CUHTTPRequest POST:queryCustByMobile parameters:paras response:^(id responseData) {
        if (responseData) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                 _certificationStatus=[dic[@"data"] objectForKey:@"certificationStatus"];
            }
          
    }
        
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

