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
@interface MineViewController() <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UIButton *setBtn;
@property (nonatomic, strong) UIImageView *img;
@property(nonatomic, strong) NSData *fileData;
@end

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = NSLocalizedString(@"", nil);
    
    _dataArray=@[@[@"coin",@"我的积分 / 优惠券"],@[@"身份证",@"实名认证"],@[@"汽车信息",@"车辆信息"],@[@"合同信息",@"合同信息"],@[@"密码",@"账户密码"],@[@"客服",@"联系客服"],@[@"反馈中心",@"反馈中心"],@[@"常见问题",@"常见问题"],@[@"功能介绍",@"功能介绍"]];
    
    [self initTableView];
    [self setupUI];
}

-(void)initTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabbarHeight) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    adjustsScrollViewInsets_NO(_tableView,self);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithHexString:@"#EEEEEE"];
    [self.view addSubview:_tableView];
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
    
    
    UIImageView *locationImg = [[UIImageView alloc] init];
    locationImg.image = [UIImage imageNamed:@"location"];
    [_headerView addSubview:locationImg];
    [locationImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(namelabel.bottom).offset(10*HeightCoefficient);
        make.left.equalTo(146*WidthCoefficient);
        make.width.height.equalTo(12*WidthCoefficient);
    }];
    
    
    UILabel * locationLabel= [[UILabel alloc] init];
    locationLabel.font=[UIFont fontWithName:FontName size:13];
    locationLabel.textColor=[UIColor whiteColor];
    locationLabel.text=NSLocalizedString(@"湖北 武汉", nil);
    locationLabel.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:locationLabel];
    [locationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(namelabel.bottom).offset(6*HeightCoefficient);
        make.left.equalTo(165*WidthCoefficient);
        make.height.equalTo(18.5 * HeightCoefficient);
        make.width.equalTo(60 * WidthCoefficient);
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
    if (section==0) {
        return 5;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44*HeightCoefficient;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20*HeightCoefficient;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//
//    self.tableView.tableFooterView = [UIView new];
//    UIView *footView = [[UIView alloc]init];
//    return footView;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Tcell = @"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@""];
    if (!cell) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Tcell];
        
    }
    UILabel *lab=[[UILabel alloc] init];
    lab.font=[UIFont fontWithName:FontName size:16];
    [cell addSubview:lab];
    [lab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(11 * HeightCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.width.equalTo(211 * WidthCoefficient);
        make.left.equalTo(59 * WidthCoefficient);
    }];
    
    UIImageView *img = [[UIImageView alloc] init];
    [cell addSubview:img];
    [img makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(11 * HeightCoefficient);
        make.height.equalTo(22 * HeightCoefficient);
        make.width.equalTo(22 * WidthCoefficient);
        make.left.equalTo(16 * WidthCoefficient);
    }];
    
    UIView *whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [cell addSubview:whiteView];
    [whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(44 * HeightCoefficient);
        make.height.equalTo(1 * HeightCoefficient);
        make.width.equalTo(kScreenWidth);
        make.left.equalTo(59*WidthCoefficient);
    }];
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            
            UILabel *lab = [[UILabel alloc] init];
            lab.font = [UIFont fontWithName:FontName size:12];
            lab.textColor = [UIColor colorWithHexString:@"#AC0042"];
            lab.textAlignment = NSTextAlignmentRight;
            lab.text = NSLocalizedString(@"未实名", nil);
            [cell addSubview:lab];
            [lab makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(11 * HeightCoefficient);
                make.height.equalTo(22 * HeightCoefficient);
                make.width.equalTo(90 * WidthCoefficient);
                make.right.equalTo(-40 * WidthCoefficient);
            }];
        }
        NSArray *array=_dataArray[indexPath.row];
        img.image=[UIImage imageNamed:array[0]];
        lab.text=array[1];
        if (indexPath.row == 4) {
            whiteView.hidden = YES;
        }
        return cell;
        
    }else if(indexPath.section == 1)  {
        
        NSArray *array=_dataArray[indexPath.row+5];
        img.image=[UIImage imageNamed:array[0]];
        lab.text=array[1];
        whiteView.hidden = indexPath.row != 0;
        return cell;
        
    }else if(indexPath.section == 2){
        
        NSArray *array=_dataArray[indexPath.row+7];
        img.image=[UIImage imageNamed:array[0]];
        lab.text=array[1];
        whiteView.hidden = indexPath.row != 0;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            
        }else if (indexPath.row == 1)
        {
            RNRViewController *vc=[[RNRViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        
        }else if (indexPath.row == 2)
        {
            
        }else if (indexPath.row == 3)
        {
            
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

