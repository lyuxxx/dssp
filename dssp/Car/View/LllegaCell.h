//
//  LllegaCell.h
//  dssp
//
//  Created by qinbo on 2018/1/24.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LllegaModel.h"
@interface LllegaCell : UITableViewCell
@property (nonatomic,strong)UIView *white;
@property (nonatomic,strong)UILabel *topLabel;
@property (nonatomic,strong)UILabel *centerLabel;
@property (nonatomic,strong)UILabel *bottomLabel;
@property (nonatomic,strong)UILabel *rightLabel;
@property (nonatomic,strong)LllegaModel *lllegaModel;
@end
