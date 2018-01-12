//
//  AppDelegate.h
//  dssp
//
//  Created by yxliu on 2017/10/24.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//ApplicationBadgeNumber相关
- (void)setBadgeNumber:(NSInteger)number;
- (void)decreaseBadgeNumber;
- (void)increaseBadgeNumber;

@end

