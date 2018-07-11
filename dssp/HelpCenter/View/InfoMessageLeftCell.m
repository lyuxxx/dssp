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

#pragma mark- 类的初始化方法
+ (instancetype)cellWithTableView:(UITableView *)tableView serviceBlock:(void (^)(UIButton *,NSString *,NSString *,NSString *,NSString *))block {
    InfoMessageLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoMessageLeftCell"];
    if (!cell) {
        cell = [[InfoMessageLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoMessageLeftCell"];
    }
    cell.serviceClickBlock = block;
    return cell;
}

#pragma mark- message的set方法
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
        } else {
            
        }
        
        [self.result setObject:serviceList.infoMessagedatailId forKey:serviceList.serviceName];
        [self.result1 setObject:serviceList.sourceData forKey:serviceList.serviceName];
        [self.result2 setObject:serviceList.appServiceNum forKey:serviceList.serviceName];
    }
    
    NSLog(@"message: %@",message);
    
    if (message.type == InfoMessageTypeMe) {
        return;
    } else if (message.type == InfoMessageTypeOther) {
        return;
    } else if (message.type == InfoMessageTypeTwo){
        
        self.ID = @"";
        
        _timeLabel.text = [self stringFromDate:message.time];
        [_timeLabel updateConstraints:^(MASConstraintMaker *make) {
            if (message.showTime) {
                make.height.equalTo(20 * WidthCoefficient);
            } else {
                make.height.equalTo(0 * WidthCoefficient);
            }
        }];
        
        NSString *noResultStr = @"未查询到相关信息。\n请致电DS CONNECT客服热线400-626-6998咨询";
        _contentLabel.text = noResultStr;//message.serviceDetails;
        
        /*
        CGSize size = [message.serviceDetails stringSizeWithContentSize:CGSizeMake(220 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:15]];
        [_contentLabel updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(size.height);
        }];
        
        
        [_line updateConstraints:^(MASConstraintMaker *make) {
            if (message.choices.count > 2) {
                make.height.equalTo(1 * WidthCoefficient);
            }else {
                make.height.equalTo(0);
            }
            
        }];
        */
        
        [self configNoNodeByAnswerAndUnanswer:message.choices];
    }
}

#pragma mark- 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark- 搭建界面
- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.userInteractionEnabled = YES;
    
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
    
    /* pageControl 在这里实际没有被使用
    self.pageControl = [[EllipsePageControl alloc] init];
    [self.contentView addSubview:_pageControl];
    */
    
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

#pragma mark- 按钮的点击事件
- (void)btnClick:(UIButton *)sender {
    if (self.serviceClickBlock) {
        NSString *Idstr = [_result objectForKey:sender.titleLabel.text];
        NSString *sourceData = [_result1 objectForKey:sender.titleLabel.text];
        NSString *appNum = [_result1 objectForKey:sender.titleLabel.text];
        NSLog(@"2233%@",Idstr);
        self.serviceClickBlock(sender,Idstr,self.ID,sourceData,appNum);
    }
}

#pragma mark- 处理没有子节点 最下方的 已解答与未解答 按钮
- (void)configNoNodeByAnswerAndUnanswer:(NSArray<NSString *>*)titleArray {
    NSInteger row = 0;
    row = ceil(titleArray.count / 2.0f);
    if (row > 4) {
        row = 4;
    }
    CGFloat scrollHeight = 31.5 * WidthCoefficient * row + 10 * WidthCoefficient * (row + 1);
    if (!titleArray.count) {
        scrollHeight = 0;
        [_line updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.bottom);
        }];
    }
    [_scroll updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(scrollHeight);
    }];
    
    NSInteger page = ceil(titleArray.count / 8.0f);
    
    [self.scrollContentView removeAllSubviews];
    UIView *lastView;
    for (NSInteger i = 0; i < page; i++) {
        
        NSArray *pageArr = [NSArray array];
        if (i == page -1) {
            pageArr = [titleArray subarrayWithRange:NSMakeRange(8 * i, (titleArray.count % 8 == 0) ? 8 : titleArray.count % 8)];
        } else {
            pageArr = [titleArray subarrayWithRange:NSMakeRange(8 * i, 8)];
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
                
            } else {
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

#pragma mark- scrollView的代理方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    _pageControl.currentPage = targetContentOffset->x / scrollView.frame.size.width;
}

#pragma mark- date 转 字符串
- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M月d日 HH:mm";
    return [formatter stringFromDate:date];
}

@end


