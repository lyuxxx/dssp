//
//  POISendBtn.m
//  dssp
//
//  Created by yxliu on 2017/12/11.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "POISendBtn.h"

@implementation POISendBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width * 43.5 / 120, contentRect.size.height * 22 / 120, contentRect.size.width * 33 / 120, contentRect.size.height * 33 / 120);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width * 14 / 120, contentRect.size.height * 61 / 120, contentRect.size.width * 92 / 120, contentRect.size.height * 37 / 120);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self point:point inCircleRect:self.bounds];
}

- (BOOL)point:(CGPoint)point inCircleRect:(CGRect)rect {
    CGFloat radius = rect.size.width/2.0;
    CGPoint center = CGPointMake(rect.origin.x + radius, rect.origin.y + radius);
    double dx = fabs(point.x - center.x);
    double dy = fabs(point.y - center.y);
    double dis = hypot(dx, dy);
    return dis <= radius;
}

@end
