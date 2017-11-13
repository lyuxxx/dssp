//
//  RNRPhotoViewController.m
//  dssp
//
//  Created by yxliu on 2017/11/13.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "RNRPhotoViewController.h"

@interface RNRPhotoViewController ()

@end

@implementation RNRPhotoViewController

- (BOOL)needGradientImg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"上传证件照片", nil);
}



@end
