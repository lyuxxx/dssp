//
//  ContractCell.h
//  dssp
//
//  Created by qinbo on 2017/12/14.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractModel.h"
@interface ContractCell : UITableViewCell
@property (nonatomic, strong) ContractModel *contractModel;
@property (nonatomic,strong) UILabel *moneyLabel;
@end
