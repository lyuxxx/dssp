//
//  LeftImgButton.m
//  dssp
//
//  Created by yxliu on 2017/11/22.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "LeftImgButton.h"

@implementation LeftImgButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width * 28.5 / 68.5, contentRect.size.height * 1.5 / 23, contentRect.size.width * 40 /68.5, contentRect.size.height * 20 / 23);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width * 23 / 68.5, contentRect.size.height);
}

@end
