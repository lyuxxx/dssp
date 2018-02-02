//
//  CarTrackViewController.m
//  dssp
//
//  Created by qinbo on 2018/1/3.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "CarTrackViewController.h"
#import "CarTrackModel.h"
#import "NSObject+YYModel.h"
#import "QGLocationTransform.h"
#import <CoreLocation/CoreLocation.h>
#import <MapSearchManager.h>
@interface CarTrackViewController ()
{
    UIButton *trackBtn;
    UIButton *callpoliceBtn;
    
}
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIImageView *rightImg;

@property (nonatomic,strong) UILabel *positionLabel;

@property (nonatomic, copy)  NSString *latitudeString;
@property (nonatomic, copy)  NSString *longitudeString;
@property (nonatomic,strong) CarTrackModel *carTrack;
@end

@implementation CarTrackViewController

- (NSMutableArray *)dataSource {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self requestData];
    [self setupUI];
}

-(void)requestData
{
//    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
//    NSString *vin = [defaults1 objectForKey:@"vin"];
    NSDictionary *paras = @{
                            
                            
                        };
    NSString *numberByVin = [NSString stringWithFormat:@"%@/%@", getSvnResponseDataByVin,kVin];
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:numberByVin parameters:paras success:^(id responseData) {
        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
          _carTrack =[CarTrackModel yy_modelWithDictionary:dic[@"data"]];
           self.carTrack=_carTrack;
//           [self.dataArray addObject:_carTrack];
           
        } else {
        [hud hideAnimated:YES];
        self.carTrack=_carTrack;
        [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
         [hud hideAnimated:YES];
        self.carTrack=_carTrack;
        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
        
    }];
}


-(void)setCarTrack:(CarTrackModel *)carTrack
{
    if (carTrack.previousPosition || carTrack.createTime) {
      
        NSString *JSONString =_carTrack.previousPosition;
        NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
        // 将流转换为字典
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        
        self.latitudeString = dataDict[@"latitude"];
        double latitudeNumber = [self.latitudeString doubleValue];
        
        self.longitudeString = dataDict[@"longitude"];
        double longitudeNumber = [self.longitudeString doubleValue];
        
        
        QGLocationTransform *beforeLocation = [[QGLocationTransform alloc] initWithLatitude:latitudeNumber andLongitude:longitudeNumber];
        //gps化为高德
        QGLocationTransform *afterLocation = [beforeLocation transformFromGPSToGD];
        NSLog(@"转化后:%f, %f", afterLocation.latitude, afterLocation.longitude);
        
        //坐标转地址
//        weakifySelf
        [[MapSearchManager sharedManager] reGeoInfo:CLLocationCoordinate2DMake(latitudeNumber, longitudeNumber) returnBlock:^(MapReGeoInfo *regeoInfo) {
//            strongifySelf
            NSString *city1 = [NSString stringWithFormat:@"位置:%@",regeoInfo.formattedAddress];
            NSLog(@"321%@",regeoInfo);
            _positionLabel.text =city1 ;
        
        }];
        NSString *time = [self setWithTimeString:_carTrack.createTime];
        NSString *maintenanceDay = [[NSString stringWithFormat:@"您的车辆在%@",time] stringByAppendingString:@"发生异常移动"];
        _rightImg.image = [UIImage imageNamed:@"盗车提醒bg"];
        _msgLabel.text = NSLocalizedString(maintenanceDay,nil);
        _msgLabel.textColor = [UIColor colorWithHexString:@"#AC0042"];
        
        
    }else
    {
        
        _rightImg.image = [UIImage imageNamed:@"盗车提醒安全bg"];
        _msgLabel.text = NSLocalizedString(@"安全保护中，请保持",nil);
        _msgLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _positionLabel.text = NSLocalizedString(@"位置:xxxxxx",nil);
       
    }
    
    
}

-(NSString *)latitudeStr:(NSString *)Latitude LongitudeStr:(NSString *)Longitude
{
    static NSString * addstroing;
    NSString * A = Latitude;
    NSString * B = Longitude;
    double a = [A doubleValue];
    double b = [B doubleValue];
    
    CLLocation * location = [[CLLocation alloc] initWithLatitude:23.137126 longitude:60.301096];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            //CLPlacemark 地标
            //            NSLog(@"位置:%@", placemark.name);
            //            NSLog(@"街道:%@", placemark.thoroughfare);
            //            NSLog(@"子街道:%@", placemark.subThoroughfare);
            //            NSLog(@"市:%@", placemark.locality);
            //            NSLog(@"区\\县:%@", placemark.subLocality);
            //            NSLog(@"行政区:%@", placemark.administrativeArea);
            //            NSLog(@"国家:%@", placemark.country);
            
            addstroing = [NSString stringWithFormat:@"%@",placemark.locality];
            
            NSLog(@"%",addstroing);
//            addressLabel.text = placemark.name;
            
        }
    }];

    
    return addstroing;
}


- (void)setupUI {

//    NSString *latitudeNumber =@"30.606726";
//    NSString *longitudeNumber =@"114.424348";
//
//    
//    //坐标转地址
//    [[MapSearchManager sharedManager] reGeoInfo:CLLocationCoordinate2DMake([latitudeNumber doubleValue], [longitudeNumber doubleValue]) returnBlock:^(MapReGeoInfo *regeoInfo) {
//        
//        NSString *city1 = [NSString stringWithFormat:@"位置%@",regeoInfo.city];
//        
//        NSLog(@"321%@",city1);
//        
//    }];
   
    
    self.view.backgroundColor=[UIColor colorWithHexString:@"#F9F8F8"];
    self.navigationItem.title = NSLocalizedString (@"车辆追踪",nil);
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
        make.top.equalTo(20 * HeightCoefficient);
        make.centerX.equalTo(0);
    }];
    
    
    self.rightImg = [[UIImageView alloc] init];
//    rightImg.image = [UIImage imageNamed:@"盗车提醒bg"];
//    [_eyeBtn setImage:[UIImage imageNamed:@"see off"] forState:UIControlStateNormal];
//    [_eyeBtn setImage:[UIImage imageNamed:@"see on"] forState:UIControlStateSelected];
    [whiteV addSubview:_rightImg];
    [_rightImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(130*HeightCoefficient);
        make.width.equalTo(123.5 *WidthCoefficient);
        make.right.equalTo(0);
    }];

    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#040000"];
    _titleLabel.text = NSLocalizedString(@"盗车提醒",nil);
    [whiteV addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10 * WidthCoefficient);
        make.height.equalTo(22.5 * HeightCoefficient);
        make.width.equalTo(70 * HeightCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
    }];
    
    
    self.msgLabel = [[UILabel alloc] init];
    _msgLabel.textAlignment = NSTextAlignmentLeft;
    _msgLabel.numberOfLines = 0;
    _msgLabel.font = [UIFont fontWithName:FontName size:13];
//    _msgLabel.textColor = [UIColor colorWithHexString:@"#AC0042"];
    [whiteV addSubview:_msgLabel];
    [_msgLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.bottom).offset(5 * HeightCoefficient);
        make.width.equalTo(214 * WidthCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
       
    }];
    
    
    self.positionLabel = [[UILabel alloc] init];
    _positionLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    _positionLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//    _positionLabel.text = NSLocalizedString(@"位置:江汉路",nil);
    [whiteV addSubview:_positionLabel];
    [_positionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-14.5 * WidthCoefficient);
        make.height.equalTo(18.5 * HeightCoefficient);
        make.width.equalTo(200 * WidthCoefficient);
        make.left.equalTo(10 * WidthCoefficient);
    }];
    
    
    UILabel *centerLabel = [[UILabel alloc] init];
    centerLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    centerLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    centerLabel.text = NSLocalizedString(@"请按如下步骤开启车辆追踪",nil);
    [self.view addSubview:centerLabel];
    [centerLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteV.bottom).offset(20 * HeightCoefficient);
        make.height.equalTo(18.5 * HeightCoefficient);
        make.width.equalTo(170 * HeightCoefficient);
        make.centerX.equalTo(0);
    }];
    
    
    UILabel *title1 = [[UILabel alloc] init];
    title1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    title1.textColor = [UIColor colorWithHexString:@"#AC0042"];
    title1.text = NSLocalizedString(@"拨打110",nil);
    [self.view addSubview:title1];
    [title1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerLabel.bottom).offset(20 * HeightCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.width.equalTo(70 * HeightCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
    }];
    
    
    UILabel *msgLabel1 = [[UILabel alloc] init];
    msgLabel1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    msgLabel1.numberOfLines = 0;
    msgLabel1.textColor = [UIColor colorWithHexString:@"#999999"];
    msgLabel1.text = NSLocalizedString(@"当您的车辆发生异常移动，请第一时间自行拨打110报警，并记住报警号",nil);
    [self.view addSubview:msgLabel1];
    [msgLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title1.bottom).offset(5 * HeightCoefficient);
        make.height.equalTo(37 * HeightCoefficient);
        make.right.equalTo(-16 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
    }];
        
    
    UILabel *title2 = [[UILabel alloc] init];
    title2.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    title2.textColor = [UIColor colorWithHexString:@"#AC0042"];
    title2.text = NSLocalizedString(@"拨打呼叫中心",nil);
    [self.view addSubview:title2];
    [title2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(msgLabel1.bottom).offset(20 * HeightCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.width.equalTo(100 * HeightCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
    }];
    
    
    UILabel *msgLabel2 = [[UILabel alloc] init];
    msgLabel2.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    msgLabel2.numberOfLines = 0;
    msgLabel2.textColor = [UIColor colorWithHexString:@"#999999"];
    msgLabel2.text = NSLocalizedString(@"您报警完毕后，请及时拨打呼叫中心车辆追踪电话，并向客服人员提供报警号，客服人员会为您核实信息",nil);
    [self.view addSubview:msgLabel2];
    [msgLabel2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title2.bottom).offset(5 * HeightCoefficient);
        make.height.equalTo(37 * HeightCoefficient);
        make.right.equalTo(-16 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
    }];
    
    
    UILabel *title3 = [[UILabel alloc] init];
    title3.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    title3.textColor = [UIColor colorWithHexString:@"#AC0042"];
    title3.text = NSLocalizedString(@"开启车辆追踪",nil);
    [self.view addSubview:title3];
    [title3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(msgLabel2.bottom).offset(20 * HeightCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.width.equalTo(100 * HeightCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
    }];
    
    
    UILabel *msgLabel3 = [[UILabel alloc] init];
    msgLabel3.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    msgLabel3.numberOfLines = 0;
    msgLabel3.textColor = [UIColor colorWithHexString:@"#999999"];
    msgLabel3.text = NSLocalizedString(@"客服人员经您确认后，会为您开启车辆追踪",nil);
    [self.view addSubview:msgLabel3];
    [msgLabel3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title3.bottom).offset(5 * HeightCoefficient);
        make.height.equalTo(18 * HeightCoefficient);
        make.right.equalTo(-16 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        
    }];
    
  
    
    UILabel *title4 = [[UILabel alloc] init];
    title4.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    title4.textColor = [UIColor colorWithHexString:@"#AC0042"];
    title4.text = NSLocalizedString(@"车辆找回",nil);
    [self.view addSubview:title4];
    [title4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(msgLabel3.bottom).offset(20 * HeightCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.width.equalTo(70 * HeightCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
    }];
    
    
    UILabel *msgLabel4 = [[UILabel alloc] init];
    msgLabel4.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    msgLabel4.textColor = [UIColor colorWithHexString:@"#999999"];
    msgLabel4.numberOfLines = 0;
    msgLabel4.text = NSLocalizedString(@"车辆追踪到位置后，成功找回车辆",nil);
    [self.view addSubview:msgLabel4];
    [msgLabel4 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title4.bottom).offset(5 * HeightCoefficient);
        make.height.equalTo(18 * HeightCoefficient);
        make.right.equalTo(-16 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
        
    }];
        
    callpoliceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callpoliceBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    callpoliceBtn.layer.cornerRadius = 2;
    [callpoliceBtn setTitle:NSLocalizedString(@"盗车追踪", nil) forState:UIControlStateNormal];
    [callpoliceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    callpoliceBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [callpoliceBtn setBackgroundColor:[UIColor colorWithHexString:@"#AC0042"]];
    [self.view addSubview:callpoliceBtn];
    [callpoliceBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.bottom.equalTo(-(kBottomHeight+10));
    }];
    
    
//    trackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [trackBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    trackBtn.layer.cornerRadius = 2;
//    [trackBtn setTitle:NSLocalizedString(@"追踪历史", nil) forState:UIControlStateNormal];
//    [trackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    trackBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
//    [trackBtn setBackgroundColor:[UIColor colorWithHexString:@"#A18E79"]];
//    [self.view addSubview:trackBtn];
//    [trackBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(271 * WidthCoefficient);
//        make.height.equalTo(44 * HeightCoefficient);
//        make.centerX.equalTo(0);
//        make.bottom.equalTo(-(kBottomHeight+16));
//    }];
    
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    CLLocation *location = [locations lastObject];
//    CLLocationDegrees latitude = location.coordinate.latitude;
//    CLLocationDegrees longitude = location.coordinate.longitude;
//    //some code
//}

-(void)BtnClick:(UIButton *)btn
{
    if (callpoliceBtn ==btn) {
        
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"82208136"];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
    if (trackBtn ==btn) {
        
    }
    
    
}

-(NSString *)setWithTimeString:(NSInteger)time
{
    if (time) {
        
        NSString *dueDateStr = [NSString stringWithFormat: @"%ld", time];
        NSTimeInterval times=[dueDateStr doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:times/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSString *dateString = [formatter stringFromDate: date];
        
        return dateString;
        
    }else
    {
        return nil;
        
    }
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
