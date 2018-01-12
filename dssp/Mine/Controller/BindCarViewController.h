//
//  BindCarViewController.h
//  dssp
//
//  Created by qinbo on 2018/1/2.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^BindCarBackBlcok) (NSString *text);//1
@interface BindCarViewController : BaseViewController
@property (nonatomic,copy)BindCarBackBlcok BackBlock;//2
@end
