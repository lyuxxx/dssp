//
//  FeedbackChoosePicView.m
//  dssp
//
//  Created by dy on 2018/5/23.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "FeedbackChoosePicView.h"
#import "FeedbackTap.h"
#import "FeedbackShowImageView.h"
#import "TZImagePickerController.h"
#import <Photos/Photos.h>

//  作为控件的imageView的tag值基数
#define kImageTag 9999

//  意见反馈选择图片
#define kMargin 10 * WidthCoefficient //  choosePicView的通用间距
#define kImageViewWH 60 * WidthCoefficient

@interface FeedbackChoosePicView()<TZImagePickerControllerDelegate>

/** 是否删除照片 */
@property(nonatomic, assign) BOOL isRemovePic;

@end


@implementation FeedbackChoosePicView

#pragma mark- 初始化#import "TZImagePickerController.h"
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setImage];
    }
    
    return self;
}

/** 加载照片*/
- (void)setImage {
    /** 如果是通过删除照片的方法进到加载照片就不添加加号图片进去*/
    if (!self.isRemovePic) {
        UIImage *addImage = [UIImage imageNamed:@"feedback_addPic"];
        if (addImage) {
            [self.imageArray addObject:addImage];
        }
    }
    
    self.isRemovePic = NO;

    for (NSInteger i = 0; i < [self.imageArray count]; i++) {
        // 4张正方形图片,5个间距
        CGFloat margin = (kScreenWidth - 52 * WidthCoefficient - 4 * kImageViewWH) / 3;
        CGFloat imageViewX = i * (kImageViewWH + margin);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, 0, kImageViewWH, kImageViewWH)];
        imageView.userInteractionEnabled = YES;
        imageView.image = self.imageArray[i];
        imageView.tag = kImageTag + i;
        /** 因为最后一个一定是添加的图片，所以给最后一个添加一个点击添加手势*/
        if (i == [self.imageArray count] - 1) {
            if (i == 4) {
                imageView.image = nil;
                imageView.hidden = YES;
            }
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPhoto)];
            [imageView addGestureRecognizer:tapGes];
        } else {
            /** 为图片添加一个右上角的删除按钮并且添加一个点击显示大图的手势*/
            UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat removeX = kImageViewWH * 4 / 5;
            CGFloat removeW = kImageViewWH / 5;
            removeBtn.frame = CGRectMake(removeX, 0, removeW, removeW);
            [removeBtn setImage:[UIImage imageNamed:@"out"] forState:UIControlStateNormal];
            [removeBtn addTarget:self action:@selector(removeImage:) forControlEvents:UIControlEventTouchUpInside];
            removeBtn.tag = i;
            [imageView addSubview:removeBtn];
            
            
            FeedbackTap *tapGes = [[FeedbackTap alloc] initWithTarget:self action:@selector(tapImage:)];
            tapGes.imageArray = self.imageArray;
            [imageView addGestureRecognizer:tapGes];
        }
        [self addSubview:imageView];
    }
}

/** 打开相册*/
- (void)openPhoto {
    NSLog(@"点击了打开相册");
    /** 判断当前授权状态*/
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusRestricted:    /** 系统级别的控制(如家长控制)*/
                break;
            case PHAuthorizationStatusDenied:    /** 用户选择了取消*/
                if (oldStatus != PHAuthorizationStatusNotDetermined) {
                    break;
                }
                break;
            case PHAuthorizationStatusAuthorized:    /** 当前用户允许app访问相册*/
                [self choosePhotos];
            default:
                break;
        }
    }];
}

/** 选择图片*/
- (void)choosePhotos {
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //  self.imageArray数组中本来就有一张"+"号图片,不是从0开始的
        TZImagePickerController *picker = [weakSelf getTZImagePickerControllerWithMaxImagesCount:5 - self.imageArray.count
                                                                                        delegate:weakSelf
                                                                                    barTintColor:[UIColor redColor]
                                                                                       tintColor:[UIColor colorWithHexString:GeneralColorString]
                                                                                  titleTextColor:[UIColor colorWithHexString:GeneralColorString]];
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            picker.modalPresentationStyle = UIModalPresentationFormSheet;
        }
        
        if (self.pickerCallback) {
            self.pickerCallback(picker);
        }
        
    });
}

/** 重新加载照片*/
- (void)reload {
    /** 首先把当前显示的所有控件都移除*/
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    /** 再将数组中的图片重新排列出来*/
    [self setImage];
    
    /** 重新加载的时候 回调图片个数*/
    if ([self.imageArray count] > 0) {
        NSString *imageCount = [NSString stringWithFormat:@"%lu", [self.imageArray count] - 1];
        self.imageCountCallback(imageCount);
    }
}

/** 移除某一张照片*/
- (void)removeImage:(UIButton *)button {
    self.isRemovePic = YES;
    [self.imageArray removeObjectAtIndex:button.tag];
    [self reload];
}

/** 点击图片的手势*/
- (void)tapImage:(FeedbackTap *)tapGes{
    NSLog("手势的点击事件");
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *maskview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [window addSubview:maskview];
    
    FeedbackShowImageView *fbImageV = [[FeedbackShowImageView alloc] initWithFrame:[UIScreen mainScreen].bounds byClick:tapGes.view.tag appendArray:tapGes.imageArray];
    [fbImageV show:maskview didFinish:^(){
        [UIView animateWithDuration:0.5f animations:^{
            fbImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [fbImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
        
    }];
}

#pragma mark - 对TZImagePickerController初始化的方法
/**
 *  TZImagePickerController与系统统一的方法
 *
 *  @param maxImagesCount 允许选择最大的照片数量
 *  @param delegate       代理对象
 *  @param barTintColor   导航栏的背景颜色
 *  @param tintColor      导航栏除了title外的其他颜色
 *  @param titleTextColor 导航栏的title文字颜色
 *
 *  @return TZImagePickerController
 */
- (TZImagePickerController *)getTZImagePickerControllerWithMaxImagesCount:(NSInteger)maxImagesCount
                                                                 delegate:(id<TZImagePickerControllerDelegate>)delegate
                                                             barTintColor:(UIColor *)barTintColor
                                                                tintColor:(UIColor *)tintColor
                                                           titleTextColor:(UIColor *)titleTextColor {
    //  初始化
    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImagesCount
                                                                                     delegate:delegate];
    //  设置导航栏的背景色
    picker.navigationBar.barTintColor = barTintColor;
    //  设置导航栏的左右按钮的文字与附件颜色
    picker.navigationBar.tintColor = tintColor;
    picker.barItemTextColor = tintColor;
    //  设置返回按钮不显示文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-60, 0) forBarMetrics:UIBarMetricsDefault];
    
    //  设置导航栏中间文字title的文字颜色
    [picker.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleTextColor,NSForegroundColorAttributeName, nil]];
    //  一直保持有右上角的勾选框
    picker.showSelectBtn = YES;
    return picker;
    
}


#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    __weak typeof(self)weakSelf = self;
    
    /** 遍历选择的所有图片*/
    for (NSInteger i = 0; i < photos.count; i++) {
        PHAsset *asset = assets[i];
        CGSize size = CGSizeMake(asset.pixelWidth / scale, asset.pixelHeight / scale);
        
        /** 获取图片*/
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:size
                                                  contentMode:PHImageContentModeDefault
                                                      options:options
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    
                                                    //  非空才进行操作 注意_Nullable,Swift中即为nil,注意判断
                                                    if (result) {
                                                        [weakSelf.imageArray removeLastObject];
                                                        [weakSelf.imageArray addObject:result];
                                                        /** 刷新*/
                                                        [weakSelf reload];
                                                    }
                                                }];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

@end

