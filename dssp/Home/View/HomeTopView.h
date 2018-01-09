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
typedef void(^locationClick)(NoResponseYYLabel *);

@interface HomeTopView : UIView

@property (nonatomic, copy) btnClickBlock clickBlock;
@property (nonatomic, copy) locationClick locationClick;
@property (nonatomic, copy) NSString *locationStr;
- (void)didTapWithPoint:(CGPoint)point;
- (void)updateWeatherText:(NSString *)text;

@end
