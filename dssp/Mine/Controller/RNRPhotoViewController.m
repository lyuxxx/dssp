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

@interface RNRPhotoViewController () <TBActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *selectedImgV;
@property (nonatomic, strong) UIImageView *pic1ImgV;
@property (nonatomic, strong) UIImageView *pic2ImgV;
@property (nonatomic, strong) UIImageView *facepicImgV;

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
    content.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:content];
    [content makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scroll);
        make.width.equalTo(scroll);
    }];
    
    NSArray *titles = @[NSLocalizedString(@"身份证正面", nil),NSLocalizedString(@"身份证反面", nil),NSLocalizedString(@"手持身份证照片", nil)];
    
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
            make.height.equalTo(188 * HeightCoefficient);
            make.centerX.equalTo(0);
            if (i == 0) {
                make.top.equalTo((20 + 208 * i) * HeightCoefficient);
            } else {
                make.top.equalTo(lastView.bottom).offset(20 * HeightCoefficient);
            }
        }];
        
        lastView = imgV;
        
        UIImageView *camera = [[UIImageView alloc] init];
        camera.image = [UIImage imageNamed:@"shot"];
        [imgV addSubview:camera];
        [camera makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(24 * WidthCoefficient);
            make.height.equalTo(21.5 * HeightCoefficient);
            make.centerX.equalTo(imgV);
            make.top.equalTo(imgV).offset(67.5 * HeightCoefficient);
        }];
        
        UILabel *title = [[UILabel alloc] init];
        title.text = titles[i];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor colorWithHexString:@"#c4b7a6"];
        title.font = [UIFont fontWithName:FontName size:16];
        [imgV addSubview:title];
        [title makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(214.5 * WidthCoefficient);
            make.height.equalTo(22.5 * HeightCoefficient);
            make.centerX.equalTo(0);
            make.top.equalTo(camera.bottom).offset(11.5 * HeightCoefficient);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [imgV addGestureRecognizer:tap];
        
        if (i == 0) {
            self.pic1ImgV = imgV;
        } else if (i == 1) {
            self.pic2ImgV = imgV;
        } else if (i == 2) {
            self.facepicImgV = imgV;
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
    self.rnrInfo.pic1 = [UIImageJPEGRepresentation(self.pic1ImgV.image, 0.1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    self.rnrInfo.pic2 = [UIImageJPEGRepresentation(self.pic2ImgV.image, 0.1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    self.rnrInfo.facepic = [UIImageJPEGRepresentation(self.facepicImgV.image, 0.1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSDictionary *dic = [self.rnrInfo yy_modelToJSONObject];
    
    [CUHTTPRequest POST:receivernrInfo parameters:dic response:^(id responseData) {
        if (responseData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",dic);
            if ([dic[@"code"] isEqualToString:@"200"]) {
                RNRFinishedViewController *vc = [[RNRFinishedViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [MBProgressHUD showText:NSLocalizedString(@"实名认证失败", nil)];
            }
        } else {
            [MBProgressHUD showText:NSLocalizedString(@"连接失败", nil)];
        }
    }];
    
}

- (void)didTap:(UITapGestureRecognizer *)sender
{
    _selectedImgV = (UIImageView *)sender.view;
    TBActionSheet *sheet = [[TBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照", nil),NSLocalizedString(@"从图库选择", nil), nil];
    sheet.ambientColor = [UIColor whiteColor];
    sheet.cancelButtonColor = [UIColor colorWithHexString:GeneralColorString];
    sheet.tintColor = [UIColor colorWithHexString:GeneralColorString];
    [sheet show];
}

- (void)actionSheet:(TBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        if (buttonIndex == 0) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerVC.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            imagePickerVC.showsCameraControls = YES;
        } else if (buttonIndex == 1) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerVC.mediaTypes = @[(NSString *)kUTTypeImage];
        }
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image) {
        _selectedImgV.image = image;
       [_selectedImgV removeAllSubviews];
    } else {
        _selectedImgV.image = info[UIImagePickerControllerOriginalImage];
        [_selectedImgV removeAllSubviews];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
