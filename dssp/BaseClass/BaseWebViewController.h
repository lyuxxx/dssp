//
//  BaseWebViewController.h
//  dssp
//
//  Created by yxliu on 2018/3/21.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "StoreBaseViewController.h"

@interface BaseWebViewController : StoreBaseViewController

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *jsString;
@property (nonatomic, strong) UIColor *loadingProgressColor;
@property (nonatomic, assign) BOOL canDownRefresh;

- (instancetype)initWithURL:(NSString *)str;

@end
