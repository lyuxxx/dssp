//
//  LocationAnnotationView.h
//  dssp
//
//  Created by yxliu on 2017/11/3.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface LocationAnnotationView : MAAnnotationView
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, assign) CGFloat rotateDegree;

- (void)updateImage:(UIImage *)image;
@end
