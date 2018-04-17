//
//  LeftButton.m
//  dssp
//
//  Created by qinbo on 2018/4/17.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "LeftButton.h"

@implementation LeftButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width * 36 / 80, contentRect.size.height * 1.5 / 23, contentRect.size.width * 40 /80, contentRect.size.height * 20 / 23);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width * 36 / 80, contentRect.size.height);
}


@end
