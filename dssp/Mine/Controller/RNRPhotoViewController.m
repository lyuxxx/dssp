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
#import "ABImagePicker.h"
@interface RNRPhotoViewController () <TBActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *selectedImgV;
@property (nonatomic, strong) UIImageView *pic1ImgV;
@property (nonatomic, strong) UIImageView *pic2ImgV;
@property (nonatomic, strong) UIImageView *facepicImgV;
@property (nonatomic, strong) UIImagePickerController *imagePickerVC;

@end

@implementation RNRPhotoViewController

- (BOOL)needGradientImg {
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
    
    NSArray *titles = @[NSLocalizedString(@"身份证正面", nil),NSLocalizedString(@"身份证反面", nil),NSLocalizedString(@"手持身份证照片", nil)];
    
     NSArray *imgs = @[NSLocalizedString(@"身份证icon", nil),NSLocalizedString(@"身份证国徽", nil),NSLocalizedString(@"faceID_background_IMG", nil)];
    
    
    
    UIImageView *lastView;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        imgV.userInteractionEnabled = YES;
        imgV.backgroundColor = [UIColor whiteColor];
        imgV.layer.cornerRadius = 4;
        imgV.layer.shadowOffset = CGSizeMake(0, 4);
        imgV.layer.shadowRadius = 7;
        imgV.layer.shadowColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
        imgV.layer.shadowOpacity = 0.2;
        [content addSubview:imgV];
        [imgV makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(343 * WidthCoefficient);
            make.height.equalTo(170 * HeightCoefficient);
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
        [reverseside makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(244 * WidthCoefficient);
            make.height.equalTo(77.5 * HeightCoefficient);
            make.centerX.equalTo(imgV);
            make.top.equalTo(imgV).offset(46 * HeightCoefficient);
        }];
        
        
        UIImageView *camera = [[UIImageView alloc] init];
        camera.image = [UIImage imageNamed:@"shot"];
        [imgV addSubview:camera];
        [camera makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(24 * WidthCoefficient);
            make.height.equalTo(21.5 * HeightCoefficient);
            make.centerY.equalTo(imgV);
            make.left.equalTo(122.5 * HeightCoefficient);
        }];
        
        UILabel *title = [[UILabel alloc] init];
        title.text = titles[i];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = [UIColor colorWithHexString:@"#c4b7a6"];
        title.font = [UIFont fontWithName:FontName size:16];
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
            
        [reverseside makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(119 * WidthCoefficient);
//                make.height.equalTo(156 * HeightCoefficient);
                make.centerX.equalTo(imgV);
                make.top.equalTo(14 * HeightCoefficient);
               make.bottom.equalTo(0 * HeightCoefficient);
            }];
        }
    }
    
    [lastView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(content.bottom).offset(-28 * HeightCoefficient);
    }];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn addTarget:self action:@selector(sumitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 2;
    [submitBtn setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    submitBtn.backgroundColor = [UIColor colorWithHexString:GeneralColorString];
    [self.view addSubview:submitBtn];
    [submitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.bottom.equalTo(self.view.bottom).offset(-8 * HeightCoefficient - kBottomHeight);
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
    self.rnrInfo.pic1 = [UIImageJPEGRepresentation(self.pic1ImgV.image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    self.rnrInfo.pic2 = [UIImageJPEGRepresentation(self.pic2ImgV.image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    self.rnrInfo.facepic = [UIImageJPEGRepresentation(self.facepicImgV.image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    NSDictionary *dic = [self.rnrInfo yy_modelToJSONObject];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:rnrVhlWithAtb parameters:dic success:^(id responseData) {
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
//
//        };
            
            QueryViewController *vc = [[QueryViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
      else
        {
            [hud hideAnimated:YES];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
          [hud hideAnimated:YES];
        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"连接失败", nil),code]];
    }];
    
}

- (void)didTap:(UITapGestureRecognizer *)sender
{
    
//    ABImagePicker * picker = [ABImagePicker shared];
//    [picker startWithVC:self];
//    [picker setPickerCompletion:^(ABImagePicker * picker, NSError *error, UIImage *image) {
//        if (!error) {
//
//        }else{
//
//        }
//    }];
    
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
             self.imagePickerVC = [[UIImagePickerController alloc] init];
            _imagePickerVC.modalPresentationStyle = UIModalPresentationCurrentContext;
            _imagePickerVC.delegate = self;
            _imagePickerVC.allowsEditing = YES;

            _imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
            _imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePickerVC.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            _imagePickerVC.showsCameraControls = YES;
             [self presentViewController:_imagePickerVC animated:YES completion:nil];
            
        } else if (buttonIndex == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    UIImagePickerController *imagePicker = [UIImagePickerController new];
                    //imagePicker.allowsImageEditing = YES;
//                    imagePicker.allowsEditing = YES;
                    imagePicker.delegate = self;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    //                NSPhotoLibraryAddUsageDescription
                    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
            });
            
//            _imagePickerVC.modalPresentationStyle = UIModalPresentationPopover ;
//           _imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            _imagePickerVC.mediaTypes = @[(NSString *)kUTTypeImage];
        }
//    [self presentViewController:_imagePickerVC animated:YES completion:nil];
    
//    }
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:nil];
    });
    

}



@end
