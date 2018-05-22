//
//  FeedbackPicView.h
//  dssp
//
//  Created by dy on 2018/5/22.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 意见反馈图片区域
 */
@interface FeedbackPicView : UIView
/** 提示Label*/
@property (nonatomic, weak) UILabel *promptLabel;
/** 图片数量Label*/
@property (nonatomic, weak) UILabel *imageCountLabel;
@end
