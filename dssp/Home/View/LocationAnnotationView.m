//
//  LocationAnnotationView.m
//  dssp
//
//  Created by yxliu on 2017/11/3.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "LocationAnnotationView.h"

@implementation LocationAnnotationView

- (UIImageView *)contentImageView
{
    if (_contentImageView == nil) {
        _contentImageView = [[UIImageView alloc] init];
        [self addSubview:_contentImageView];
    }
    
    return _contentImageView;
}

- (void)setRotateDegree:(CGFloat)rotateDegree
{
    self.contentImageView.transform = CGAffineTransformMakeRotation(rotateDegree * M_PI / 180.f );
}

- (void)updateImage:(UIImage *)image
{
    self.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    self.contentImageView.image = image;
    [self.contentImageView sizeToFit];
}

@end
