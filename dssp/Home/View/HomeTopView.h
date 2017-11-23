//
//  HomeTopView.h
//  dssp
//
//  Created by yxliu on 2017/11/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText.h>

@interface NoResponseView : UIView

@end

@interface NoResponseImgView : UIImageView

@end

@interface NoResponseYYLabel : YYLabel

@end

typedef void(^btnClickBlock)(UIButton *);

@interface HomeTopView : UIView

@property (nonatomic, copy) btnClickBlock clickBlock;

- (void)didTapWithPoint:(CGPoint)point;

@end
