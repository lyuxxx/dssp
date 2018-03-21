//
//  AgreementViewController.h
//  dssp
//
//  Created by qinbo on 2018/3/21.
//  Copyright © 2018年 capsa. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void(^CallBackBlcok) (NSString *text);
@interface AgreementViewController : BaseViewController
@property (nonatomic,copy)CallBackBlcok callBackBlocks;
@end
