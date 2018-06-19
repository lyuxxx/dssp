//
//  InfoMessageHelpCenterCell.m
//  dssp
//
//  Created by yxliu on 2018/2/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "InfoMessageLeftCell.h"
#import "EllipsePageControl.h"
#import "NSString+Size.h"
#import "NSArray+Sudoku.h"

@interface InfoMessageLeftCell () <UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *contentLabel1;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) EllipsePageControl *pageControl;
@property (nonatomic, strong) UIImageView *bubble;
@property (nonatomic, strong) NSMutableDictionary *result;
@property (nonatomic, strong) NSMutableDictionary *result1;
@property (nonatomic, strong) NSMutableDictionary *result2;
@property (nonatomic, copy) ServiceClickBlock serviceClickBlock;
@property (nonatomic, copy) NSString *ID;
@end

@implementation InfoMessageLeftCell

+ (instancetype)cellWithTableView:(UITableView *)tableView serviceBlock:(void (^)(UIButton *,NSString *,NSString *,NSString *,NSString *))block {
    InfoMessageLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoMessageLeftCell"];
    cell.serviceClickBlock = block;
    return cell;
}

- (void)setMessage:(InfoMessage *)message {
    _message = message;
    
    self.result = [NSMutableDictionary new];
    //    [result setObject:message.infoMessagedatailId forKey:message.serviceName];
    NSArray *array = message.serviceKnowledgeProfileList;
    NSMutableArray *dataArray =[[NSMutableArray alloc] init];
    
    
    for (NSDictionary *dic in array) {
        serviceKnowledgeProfileList *serviceList = [serviceKnowledgeProfileList yy_modelWithDictionary:dic];
        if (serviceList.serviceName) {
            [dataArray addObject:serviceList.serviceName];
        }
        else
        {
            
        }
        [self.result setObject:serviceList.infoMessagedatailId forKey:serviceList.serviceName];
        [self.result1 setObject:serviceList.sourceData forKey:serviceList.serviceName];
        [self.result2 setObject:serviceList.appServiceNum forKey:serviceList.serviceName];
    }
    
    NSLog(@"%@",message);
    
    if (message.type == InfoMessageTypeMe) {
        return;
    }
    else if (message.type == InfoMessageTypeOther)
    {
         return;
    }
    else if (message.type == InfoMessageTypeTwo){
        
        self.ID = @"";
        
        NSMutableArray *dataArray1= [[NSMutableArray alloc] init];
        dataArray1 = [NSMutableArray arrayWithArray:message.choices];
//        [dataArray1 addObject:@"确定"];
//        [dataArray1 addObject:@"关闭"];
        _timeLabel.text = [self stringFromDate:message.time];
        [_timeLabel updateConstraints:^(MASConstraintMaker *make) {
            if (message.showTime) {
                make.height.equalTo(20 * WidthCoefficient);
            } else {
                make.height.equalTo(0 * WidthCoefficient);
            }
        }];
        
    
        _contentLabel.text = message.serviceDetails;
        CGSize size = [message.serviceDetails stringSizeWithContentSize:CGSizeMake(220 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:15]];
        
        //            _contentLabel.backgroundColor =[UIColor redColor];
        [_contentLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(size.height);
        }];

        if (dataArray1.count > 2) {//显示线
            [_line updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(1 * WidthCoefficient);
            }];
        } else {//不显示线
            [_line updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(0);
            }];
        }
        
        NSInteger row = 0;
        row = ceil(dataArray1.count / 2.0f);
        if (row > 4) {
            row = 4;
        }
        CGFloat scrollHeight = 31.5 * WidthCoefficient * row + 10 * WidthCoefficient * (row + 1);
        [_scroll updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(scrollHeight);
        }];
        
        NSInteger page = ceil(dataArray1.count / 8.0f);
        
        [self.scrollContentView removeAllSubviews];
        UIView *lastView;
        for (NSInteger i = 0; i < page; i++) {
            
            NSArray *pageArr = [NSArray array];
            if (i == page -1) {
                pageArr = [dataArray1 subarrayWithRange:NSMakeRange(8 * i, (dataArray1.count % 8 == 0) ? 8 : dataArray1.count % 8)];
            } else {
                pageArr = [dataArray1 subarrayWithRange:NSMakeRange(8 * i, 8)];
            }
            
            UIView *v = [[UIView alloc] init];
            [self.scrollContentView addSubview:v];
            [v makeConstraints:^(MASConstraintMaker *make) {
                make.top.width.equalTo(_scroll);
                if (i == 0) {
                    make.left.equalTo(_scrollContentView);
                } else {
                    make.left.equalTo(lastView.right);
                }
                make.height.equalTo(_scrollContentView);
            }];
            lastView = v;
            
            
            
            ///添加button
            NSMutableArray *btns = [NSMutableArray arrayWithCapacity:pageArr.count];
            for (NSInteger j = 0; j < pageArr.count; j++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:pageArr[j] forState:UIControlStateNormal];
                btn.needNoRepeat = YES;
                btn.titleLabel.font = [UIFont fontWithName:FontName size:12];
                
                if (j==0) {
                    
                    btn.backgroundColor  = [UIColor colorWithHexString:@"#AC0042"];
                    
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    //                        [btn setImage:[UIImage imageNamed:@"用户背景"] forState:UIControlStateNormal];
                }
                else
                {
                    btn.backgroundColor = [UIColor colorWithHexString:@"#413E3D"];
                    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
                }
                
                btn.layer.cornerRadius = 4;
                [v addSubview:btn];
                [btns addObject:btn];
            }
            
            [btns mas_distributeSudokuViewsWithFixedItemWidth:105 * WidthCoefficient fixedItemHeight:31.5 * WidthCoefficient warpCount:2 topSpacing:10 * WidthCoefficient bottomSpacing:10 * WidthCoefficient leadSpacing:5 * WidthCoefficient tailSpacing:5 * WidthCoefficient];
        }
        [lastView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_scrollContentView.right);
        }];
        
        if (page > 1) {
            
            [_bubble updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_scroll).offset(15 * WidthCoefficient);
            }];
            
        } else {
            
            [_bubble updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_scroll).offset(10 * WidthCoefficient);
            }];
            
        }
        
        [self layoutIfNeeded];
        
        if (page > 1) {
            
            _pageControl.frame = CGRectMake(_scroll.frame.origin.x, _scroll.frame.origin.y + _scroll.frame.size.height, _scroll.frame.size.width, 5 * WidthCoefficient);
        } else {
            
            _pageControl.frame = CGRectMake(_scroll.frame.origin.x, _scroll.frame.origin.y + _scroll.frame.size.height, _scroll.frame.size.width, 0);
        }
        _pageControl.currentColor = [UIColor colorWithHexString:GeneralColorString];
        _pageControl.otherColor = [UIColor colorWithHexString:@"#e6e6e6"];
        _pageControl.numberOfPages = page;
        _pageControl.controlSize = 6;
        _pageControl.controlSpacing = 6;
        
        self.message.cellHeight = CGRectGetMaxY(_bubble.frame) + 10 * WidthCoefficient;
        
    }
    
    
    
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f9f8f8"];
      self.contentView.backgroundColor = [UIColor clearColor];
    self.timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _timeLabel.font = [UIFont fontWithName:FontName size:11];
    _timeLabel.preferredMaxLayoutWidth = 150 * WidthCoefficient;
    [self.contentView addSubview:_timeLabel];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(0 * WidthCoefficient);
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(10 * WidthCoefficient);
    }];
    
    self.avatar = [[UIImageView alloc] init];
    _avatar.image = [UIImage imageNamed:@"管家头像"];
    [self.contentView addSubview:_avatar];
    [_avatar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(8 * WidthCoefficient);
        make.height.width.equalTo(40 * WidthCoefficient);
        make.top.equalTo(_timeLabel.bottom).offset(10 * WidthCoefficient);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    _nameLabel.text = NSLocalizedString(@"DS管家", nil);
    _nameLabel.font = [UIFont fontWithName:FontName size:11];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatar.right).offset(10 * WidthCoefficient);
        make.top.equalTo(_avatar);
        make.height.equalTo(20 * WidthCoefficient);
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    _contentLabel.preferredMaxLayoutWidth = 220 * WidthCoefficient;
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.font = [UIFont fontWithName:FontName size:15];
    _contentLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:_contentLabel];
    [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel).offset(10 * WidthCoefficient);
        make.top.equalTo(_nameLabel.bottom).offset(10 * WidthCoefficient);
        make.width.equalTo(220 * WidthCoefficient);
        make.height.equalTo(67 * WidthCoefficient);
    }];
    
    self.line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashLine"]];
    [self.contentView addSubview:_line];
    [_line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentLabel);
        make.width.equalTo(_contentLabel).offset(10 * WidthCoefficient);
        make.height.equalTo(1 * WidthCoefficient);
        make.top.equalTo(_contentLabel.bottom).offset(10 * WidthCoefficient);
    }];
    
    self.scroll = [[UIScrollView alloc] init];
    _scroll.scrollEnabled = NO;
    _scroll.delegate = self;
    _scroll.pagingEnabled = YES;
    _scroll.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:_scroll];
    [_scroll makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_line.bottom);
        make.centerX.equalTo(_contentLabel);
        make.width.equalTo(_contentLabel).offset(10 * WidthCoefficient);
        make.height.equalTo(176 * WidthCoefficient);
    }];
    
    self.scrollContentView = [[UIView alloc] init];
    [self.scroll addSubview:self.scrollContentView];
    [self.scrollContentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scroll);
        make.height.equalTo(self.scroll);
    }];
    
//    self.pageControl = [[EllipsePageControl alloc] init];
//    
//    [self.contentView addSubview:_pageControl];
    
    self.bubble = [[UIImageView alloc] init];
    _bubble.image = [UIImage imageNamed:@"管家背景"];
    [self.contentView addSubview:_bubble];
    [_bubble makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentLabel).offset(-10 * WidthCoefficient);
        make.top.equalTo(_contentLabel).offset(-10 * WidthCoefficient);
        make.right.equalTo(_contentLabel).offset(10 * WidthCoefficient);
        make.bottom.equalTo(_scroll).offset(15 * WidthCoefficient);
    }];
    [self.contentView insertSubview:_bubble belowSubview:_contentLabel];
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    _pageControl.currentPage = targetContentOffset->x / scrollView.frame.size.width;
}

- (void)btnClick:(UIButton *)sender {
    if (self.serviceClickBlock) {
        NSString *Idstr = [_result objectForKey:sender.titleLabel.text];
        NSString *sourceData = [_result1 objectForKey:sender.titleLabel.text];
        NSString *appNum = [_result1 objectForKey:sender.titleLabel.text];
        NSLog(@"2233%@",Idstr);
        self.serviceClickBlock(sender,Idstr,self.ID,sourceData,appNum);
    }
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M月d日 HH:mm";
    return [formatter stringFromDate:date];
}

@end


