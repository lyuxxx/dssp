//
//  HomeBtnsHeader.h
//  dssp
//
//  Created by yxliu on 2018/3/13.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const HomeBtnsHeaderIdentifier;

@interface HomeBtnsHeader : UITableViewHeaderFooterView

+ (CGFloat)HeaderHeight;
- (void)configWithBtnClick:(void(^)(UIButton *))btnClick;

@end
