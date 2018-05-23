//
//  FeedbackShowImageView.h
//  dssp
//
//  Created by dy on 2018/5/23.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^didRemoveImage)(void);

@interface FeedbackShowImageView : UIView
{
    UIImageView *showImage;
}

@property (nonatomic,copy) didRemoveImage removeImg;

- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock;

- (instancetype)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray;
@end
