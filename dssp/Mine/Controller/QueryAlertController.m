//
//  QueryAlertController.m
//  dssp
//
//  Created by season on 2018/6/15.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "QueryAlertController.h"

@interface QueryAlertController ()

/** 背景图片*/
@property (nonatomic, strong) UIImageView *backgroundView;

/** 顶部图片*/
@property (nonatomic, strong) UIImageView *topView;

/** 知道了按钮*/
@property (nonatomic, strong) UIButton *knownButton;

/** 取消按钮*/
@property (nonatomic, strong) UIButton *cancelButton;

/** 提示Label*/
@property (nonatomic, strong) UILabel *tipLabel;

/** 注意图片*/
@property (nonatomic, strong) UIImageView *attentionView;

@end

@implementation QueryAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
