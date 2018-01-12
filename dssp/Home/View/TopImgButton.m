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
    return CGRectMake(0, contentRect.size.height * 84 / 124, contentRect.size.width, contentRect.size.height * 40 / 124);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width * 16.5 / 105, 0, contentRect.size.width * 72 / 105, contentRect.size.height * 72 / 124);
}

@end
