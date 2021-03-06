//
//  RNRPhotoViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "RNRPhotoViewController.h"
#import <TBActionSheet/TBActionSheet.h>
#import <YYCategoriesSub/YYCategories.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImagePickerController+StatusBar.h"
#import "RNRFinishedViewController.h"
#import <YYModel/YYModel.h>
#import <CUHTTPRequest.h>
#import <MBProgressHUD+CU.h>
#import "InputAlertView.h"
#import "QueryViewController.h"
#import "TZImagePickerController.h"
@interface RNRPhotoViewController () <TBActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIImageView *selectedImgV;
@property (nonatomic, strong) UIImageView *pic1ImgV;
@property (nonatomic, strong) UIImageView *pic2ImgV;
@property (nonatomic, strong) UIImageView *facepicImgV;
@property (nonatomic, strong) UIImagePickerController *imagePickerVC;

@end

@implementation RNRPhotoViewController

- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = NSLocalizedString(@"上传证件照片", nil);
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scroll];
    [scroll makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(0, 0, kBottomHeight + 60 *HeightCoefficient, 0));
    }];
    
    UIView *content = [[UIView alloc] init];
    content.backgroundColor = [UIColor clearColor];
    [scroll addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroll);
        make.width.equalTo(scroll);
    }];
    
    NSArray *titles = @[NSLocalizedString(@"证件正面", nil),NSLocalizedString(@"证件反面", nil),NSLocalizedString(@"手持证件照", nil)];
    
     NSArray *imgs = @[NSLocalizedString(@"身份证1", nil),NSLocalizedString(@"身份证背面", nil),NSLocalizedString(@"手持身份证", nil)];
    
    
    
    UIImageView *lastView;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        imgV.userInteractionEnabled = YES;
        imgV.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
        imgV.layer.cornerRadius = 2;
//        imgV.layer.shadowOffset = CGSizeMake(0, 4);
//        imgV.layer.shadowRadius = 7;
//        imgV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
//        imgV.layer.shadowOpacity = 0.2;
        [content addSubview:imgV];
        [imgV makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(343 * WidthCoefficient);
            make.height.equalTo(120 * HeightCoefficient);
            make.centerX.equalTo(0);
            if (i == 0) {
                make.top.equalTo((20 + 208 * i) * HeightCoefficient);
            } else {
                make.top.equalTo(lastView.bottom).offset(20 * HeightCoefficient);
            }
        }];
        

        
        lastView = imgV;
        UIImageView *reverseside = [[UIImageView alloc] init];
        reverseside.image = [UIImage imageNamed:imgs[i]];
        reverseside.contentMode = UIViewContentModeScaleAspectFit;
        [imgV addSubview:reverseside];
        
        if (i==2) {
        [reverseside makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(73 * WidthCoefficient);
            make.height.equalTo(96 * HeightCoefficient);
            make.right.equalTo(-15*WidthCoefficient);
            make.bottom.equalTo(0 * HeightCoefficient);
             }];
        }
        else
        {
        [reverseside makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(36 * WidthCoefficient);
            make.height.equalTo(36 * HeightCoefficient);
            make.centerY.equalTo(imgV);
            make.right.equalTo(-15 * WidthCoefficient);
        }];
        }
        
        UIImageView *camera = [[UIImageView alloc] init];
        camera.image = [UIImage imageNamed:@"shot"];
        [imgV addSubview:camera];
        [camera makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(24 * WidthCoefficient);
            make.height.equalTo(24 * HeightCoefficient);
            make.centerY.equalTo(imgV);
            make.left.equalTo(15 * HeightCoefficient);
        }];
        
        UILabel *title = [[UILabel alloc] init];
        title.text = titles[i];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = [UIColor colorWithHexString:@"#c4b7a6"];
        title.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [imgV addSubview:title];
        [title makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(214.5 * WidthCoefficient);
            make.height.equalTo(22.5 * HeightCoefficient);
            make.centerY.equalTo(0);
            make.left.equalTo(camera.right).offset(10 * WidthCoefficient);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [imgV addGestureRecognizer:tap];
        
        if (i == 0) {
            self.pic1ImgV = imgV;
        } else if (i == 1) {
            self.pic2ImgV = imgV;
        } else if (i == 2) {
            self.facepicImgV = imgV;
            
//        [reverseside makeConstraints:^(MASConstraintMaker *make) {
//                make.width.equalTo(119 * WidthCoefficient);
//                make.height.equalTo(96 * HeightCoefficient);
//                make.right.equalTo(-15*WidthCoefficient);
//                make.top.equalTo(10 * HeightCoefficient);
//               make.bottom.equalTo(0 * HeightCoefficient);
//            }];
        }
    }
    
    [lastView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(content.bottom).offset(-28 * HeightCoefficient);
    }];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn addTarget:self action:@selector(sumitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 2;
    submitBtn.needNoRepeat = YES;
    [submitBtn setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    submitBtn.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    [self.view addSubview:submitBtn];
    [submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(lastView.bottom).offset(30* HeightCoefficient);
    }];
    
}

- (void)sumitBtnClick:(UIButton *)sender {
    if (!self.pic1ImgV.image) {
        [MBProgressHUD showText:NSLocalizedString(@"身份证正面未上传!", nil)];
        return;
    } else if (!self.pic2ImgV.image) {
        [MBProgressHUD showText:NSLocalizedString(@"身份证背面未上传!", nil)];
        return;
    } else if (!self.facepicImgV.image) {
        [MBProgressHUD showText:NSLocalizedString(@"手持身份证照片未上传", nil)];
        return;
    }
    
    self.rnrInfo.pic1 = [UIImageJPEGRepresentation(self.pic1ImgV.image, 0.2) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    self.rnrInfo.pic2 = [UIImageJPEGRepresentation(self.pic2ImgV.image, 0.2) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    self.rnrInfo.facepic = [UIImageJPEGRepresentation(self.facepicImgV.image, 0.2) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];


    NSDictionary *dic1 = [self.rnrInfo yy_modelToJSONObject];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    
   NSLog(@"656%@",dic1[@"vin"]);
    [CUHTTPRequest POST:rnrVhlWithAtb parameters:dic1 success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"666%@",dic);
        if ([dic[@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            
//            InputAlertView *InputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//            [InputalertView initWithTitle:@"实名制认证信息提交成功" img:@"账号警告" type:10 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"返回首页", nil] ];
//            UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
//            [keywindow addSubview: InputalertView];
//
//            InputalertView.clickBlock = ^(UIButton *btn,NSString *str) {
//                if (btn.tag == 100) {//左边按钮
//
//            [self.navigationController popToRootViewControllerAnimated:YES];
//
//             }

//        };
            
            InputAlertView *inputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            inputalertView.tag = 101; //  第二步 车辆激活 这个没有使用宏 注意
            [inputalertView initWithTitle:@"请将车开至信号好的地方，并启动车辆10分钟，\n以完成激活" img:@"car" type:9 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"知道了",nil] ];
            UIView *keywindow = [[UIApplication sharedApplication] keyWindow];
            [keywindow addSubview: inputalertView];

            
            inputalertView.clickBlock = ^(UIButton *btn, NSString *str) {
                QueryViewController *vc = [[QueryViewController alloc] init];
                vc.vin = dic1[@"vin"];
                vc.types = @"2";
                NSLog(@"666%@",dic1[@"vin"]);
                [self.navigationController pushViewController:vc animated:YES];
            };
        }
      else
        {
            [hud hideAnimated:YES];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
          [hud hideAnimated:YES];
        [MBProgressHUD showText:NSLocalizedString(@"网络异常", nil)];
    }];
    
}

- (void)didTap:(UITapGestureRecognizer *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _selectedImgV = (UIImageView *)sender.view;
        TBActionSheet *sheet = [[TBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照", nil),NSLocalizedString(@"从图库选择", nil), nil];
        sheet.ambientColor = [UIColor whiteColor];
        sheet.cancelButtonColor = [UIColor colorWithHexString:GeneralColorString];
        sheet.tintColor = [UIColor colorWithHexString:GeneralColorString];
        [sheet show];
    });
    
}

- (void)actionSheet:(TBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//        if (!self.imagePickerVC) {
//           self.imagePickerVC = [[UIImagePickerController alloc] init];
//        }

//        _imagePickerVC.modalPresentationStyle = UIModalPresentationCurrentContext;
//        _imagePickerVC.delegate = self;
//        _imagePickerVC.allowsEditing = YES;

        if (buttonIndex == 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
             
                self.imagePickerVC = [[UIImagePickerController alloc] init];
                _imagePickerVC.modalPresentationStyle = UIModalPresentationCurrentContext;
                _imagePickerVC.delegate = self;
                _imagePickerVC.allowsEditing = YES;
                
                _imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
                _imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                _imagePickerVC.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                _imagePickerVC.showsCameraControls = YES;
                [self presentViewController:_imagePickerVC animated:YES completion:nil];
            });
            
        } else if (buttonIndex == 1) {
            TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self];
            imagePickerVC.allowPickingOriginalPhoto = NO;
            imagePickerVC.allowPickingVideo = NO;
            imagePickerVC.allowPickingGif = NO;
            imagePickerVC.allowTakePicture = NO;
            imagePickerVC.allowCrop = YES;
            imagePickerVC.cropRect = CGRectMake(0, (kScreenHeight - kScreenWidth) / 2.0f, kScreenWidth, kScreenWidth);
            imagePickerVC.oKButtonTitleColorNormal = [UIColor whiteColor];
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _selectedImgV.image = photos[0];
    [_selectedImgV removeAllSubviews];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
//    _imagePickerVC = nil;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^()
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             _imagePickerVC = nil;
             UIImage* image = info[UIImagePickerControllerEditedImage];
             if (image) {
                 _selectedImgV.image = image;
                 [_selectedImgV removeAllSubviews];
             } else {
                 _selectedImgV.image = info[UIImagePickerControllerOriginalImage];
                 [_selectedImgV removeAllSubviews];
             }
         });
     }];




//    UIImage *image = info[UIImagePickerControllerEditedImage];
//    if (image) {
//        _selectedImgV.image = image;
//       [_selectedImgV removeAllSubviews];
//    } else {
//        _selectedImgV.image = info[UIImagePickerControllerOriginalImage];
//        [_selectedImgV removeAllSubviews];
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [picker dismissViewControllerAnimated:YES completion:nil];
//    });
    

}

#pragma mark- 提交成功的Hub
- (void)showSuccessHub {
    InputAlertView *inputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [inputalertView initWithTitle:@"请将车开至移动信号好的地方，并启动车辆10分钟，以完成激活" img:@"car" type:9 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"我知道了",nil] ];
    UIView *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: inputalertView];
    
    inputalertView.clickBlock = ^(UIButton *btn, NSString *str) {
        //[self.navigationController popViewControllerAnimated:YES];
    };
}

@end
