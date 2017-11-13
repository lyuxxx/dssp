//
//  TopImgButton.m
//  dssp
//
//  Created by yxliu on 2017/11/10.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "TopImgButton.h"

@implementation TopImgButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, contentRect.size.height * 42 / 60, contentRect.size.width, contentRect.size.height * 18 / 60);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width * 10 / 56, 0, contentRect.size.width * 36 / 56, contentRect.size.height * 36 / 60);
}

@end
