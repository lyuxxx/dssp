//
//  FeedbackChoosePicView.h
//  dssp
//
//  Created by dy on 2018/5/23.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TZImagePickerController;

typedef void(^PickerCallback)(TZImagePickerController *picker);

typedef void(^imageCountCallback)(NSString *imageCount);

/**
 *  选择图片
 */
@interface FeedbackChoosePicView : UIView

/** 用户选择的图片数组 */
@property(nonatomic, strong)NSMutableArray<UIImage *> *imageArray;

/** picker闭包 */
@property (nonatomic, copy) PickerCallback pickerCallback;

@property (nonatomic, copy) imageCountCallback imageCountCallback;

@end

@interface UIImage (ReDraw)

- (UIImage *)reDrawImageWithWidth:(CGFloat)width height:(CGFloat)height;

@end
