//
//  HomeBtn.m
//  dssp
//
//  Created by yxliu on 2018/3/13.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "HomeBtn.h"

@implementation HomeBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, contentRect.size.height * 41 / 59, contentRect.size.width, contentRect.size.height * 18 / 59);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width * 10 / 56, 0, contentRect.size.width * 36 / 56, contentRect.size.height * 36 / 59);
}

@end
