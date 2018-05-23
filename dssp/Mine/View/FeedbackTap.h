//
//  FeedbackTap.h
//  dssp
//
//  Created by dy on 2018/5/23.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 反馈点击图片的手势
 */
@interface FeedbackTap : UITapGestureRecognizer

@property (nonatomic,strong) NSArray *imageArray;

@end
