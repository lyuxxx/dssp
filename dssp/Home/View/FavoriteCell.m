//
//  FavoriteCell.m
//  dssp
//
//  Created by yxliu on 2017/12/12.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "FavoriteCell.h"
#import <YYCategories.h>

@interface FavoriteCell ()
@property (nonatomic, strong) UIView *white;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *address;
@end

@implementation FavoriteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        self.multipleSelectionBackgroundView = [UIView new];
        
        self.white = ({
            UIView *whiteV = [[UIView alloc] init];
            whiteV.backgroundColor = [UIColor colorWithHexString:@"#120f0e"];
            whiteV.layer.cornerRadius = 4;
            whiteV.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
            whiteV.layer.shadowOffset = CGSizeMake(0, 5);
            whiteV.layer.shadowRadius = 7;
            whiteV.layer.shadowOpacity = 0.5;
            [self.contentView addSubview:whiteV];
            [whiteV makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(UIEdgeInsetsMake(5 * WidthCoefficient, 16 * WidthCoefficient, 5 * WidthCoefficient, 16 * WidthCoefficient));
                make.height.equalTo(75 * WidthCoefficient);
            }];
            
            whiteV;
        });
        
        self.icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"favlocation_icon"];
        [_white addSubview:_icon];
        [_icon makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(24 * WidthCoefficient);
            make.centerY.equalTo(0);
            make.left.equalTo(10 * WidthCoefficient);
        }];
        
        self.name = [[UILabel alloc] init];
        _name.font = [UIFont fontWithName:FontName size:16];
        _name.textColor = [UIColor colorWithHexString:GeneralColorString];
        [_white addSubview:_name];
        [_name makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(20 * WidthCoefficient);
            make.left.equalTo(_icon.right).offset(15 * WidthCoefficient);
            make.top.equalTo(15 * WidthCoefficient);
        }];
        
        self.address = [[UILabel alloc] init];
        _address.font = [UIFont fontWithName:FontName size:12];
        _address.textColor = [UIColor colorWithHexString:@"#999999"];
        [_white addSubview:_address];
        [_address makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_name.left);
            make.top.equalTo(_name.bottom).offset(5 * WidthCoefficient);
            make.height.equalTo(20 * WidthCoefficient);
        }];
        
        UIImageView *arrow = [[UIImageView alloc] init];
        arrow.image = [UIImage imageNamed:@"箭头1_icon"];
        [_white addSubview:arrow];
        [arrow makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(15 * WidthCoefficient);
            make.centerY.equalTo(0);
            make.right.equalTo(-8 * WidthCoefficient);
        }];
        
    }
    return self;
}

+ (CGFloat)cellHeight {
    return 85 * WidthCoefficient;
}

- (void)configWithModel:(ResultItem *)item {
    self.name.text = item.poiName;
    self.address.text = item.address;
}

//- (void)layoutSubviews {
//    [self changeCellSelectedImage];
//    [super layoutSubviews];
//}
//
//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    [self changeCellSelectedImage];
//}

- (void)resetColor {
    self.white.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self resetColor];
    // Configure the view for the selected state
    if (!self.isEditing) {
        return;
    }
    if (selected) {
        [self changeCellSelectedImage];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self resetColor];
    if (!self.isEditing) {
        return;
    }
    if (highlighted) {
        [self changeCellSelectedImage];
    }
}

- (void)changeCellSelectedImage {
//    for (UIView *view in self.subviews) {
//
//        if ([view isKindOfClass:[UIControl class]])
//        {
//            for (UIView *subview in view.subviews) {
//                if ([subview isKindOfClass:[UIImageView class]]) {
//                    [subview setValue:[UIColor colorWithHexString:@"#ac0042"] forKey:@"tintColor"];
//                }
//            }
//        }
//    }
    for (UIControl *control in self.subviews) {
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]) {
            for (UIView *v in control.subviews) {
                if ([v isKindOfClass:[UIImageView class]]) {
                    UIImageView *imgV = (UIImageView *)v;
                    [imgV setValue:[UIColor colorWithHexString:@"#ac0042"] forKey:@"tintColor"];
//                    //iOS11图片大小不对，舍弃
//                    if (self.selected) {
//                        imgV.image = [UIImage imageNamed:@"selected"];
//                    } else {
//                        imgV.image = [UIImage imageNamed:@"selected_empty"];
//                    }
                }
            }
        }
    }
}

@end
