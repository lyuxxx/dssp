//
//  PrivacypolicyController.h
//  dssp
//
//  Created by qinbo on 2018/1/10.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "StoreBaseViewController.h"


typedef void(^CallBackBlcok) (NSString *text);
@interface PrivacypolicyController : StoreBaseViewController
@property (nonatomic,copy)CallBackBlcok callBackBlock;
@end
