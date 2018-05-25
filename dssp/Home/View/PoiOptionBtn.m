//
//  PoiOptionBtn.m
//  dssp
//
//  Created by yxliu on 2018/5/25.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "PoiOptionBtn.h"

@implementation PoiOptionBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width * 21 / 73, contentRect.size.height * 1.5 / 16, contentRect.size.width * 52 /73, contentRect.size.height * 13 / 16);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width * 16 / 73, contentRect.size.height);
}

@end
