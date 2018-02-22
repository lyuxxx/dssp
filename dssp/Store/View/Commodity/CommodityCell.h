//
//  CommodityCell.h
//  dssp
//
//  Created by yxliu on 2018/2/7.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoreCommodity;

typedef void(^BuyBtnClick)(UIButton *);

@interface CommodityCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath buyBtnClick:(void (^)(UIButton *))buyBtnBlock;

- (void)configWithCommodity:(StoreCommodity *)commodity;

@end
