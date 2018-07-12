//
//  InfoMessageHelpCenterCell.m
//  dssp
//
//  Created by yxliu on 2018/2/1.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "InfoMessageHelpCenterCell.h"
#import "EllipsePageControl.h"
#import "NSString+Size.h"
#import "NSArray+Sudoku.h"
#import <UIImageView+SDWebImage.h>
#import "UIImageView+WebCache.h"
#import "YYText.h"
@interface InfoMessageHelpCenterCell () <UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) UILabel *tipLaebel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) EllipsePageControl *pageControl;
@property (nonatomic, strong) UIImageView *bubble;
@property (nonatomic, strong) NSMutableDictionary *result;
@property (nonatomic, strong) NSMutableDictionary *result1;
@property (nonatomic, strong) NSMutableDictionary *result2;
@property (nonatomic, copy) ServiceClickBlock serviceClickBlock;

@property (nonatomic, copy) NSString *URL;

@end

@implementation InfoMessageHelpCenterCell

#pragma mark- 构造类方法
+ (instancetype)cellWithTableView:(UITableView *)tableView serviceBlock:(void (^)(UIButton *,NSString *,NSString *,NSString *,NSString *))block {
    InfoMessageHelpCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoMessageHelpCenterCell"];
    if (!cell) {
        cell = [[InfoMessageHelpCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoMessageHelpCenterCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.serviceClickBlock = block;
    return cell;
}

#pragma mark- message的set方法
- (void)setMessage:(InfoMessage *)message {
    
  
    _message = message;
    
    //  重置scrollView 与 上面的内容view
    [self.scrollContentView removeAllSubviews];
    [self.scroll setContentOffset:CGPointMake(0, 0) animated:NO];
    
    //  重置pageControl
    if (self.pageControl) {
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
    }
    self.pageControl = [[EllipsePageControl alloc] init];
    [self.contentView addSubview:_pageControl];
    
    self.result = [NSMutableDictionary new];
    self.result1 = [NSMutableDictionary new];
    self.result2 = [NSMutableDictionary new];
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
    
    CONF_SET(@"resultId",self.result);
    CONF_SET(@"resultsourceData",self.result1);
    CONF_SET(@"appServiceNum",self.result2);
    
    NSString *Idstr = [_result objectForKey:message.serviceName];
    
    if (message.type == InfoMessageTypeMe) {
        return;
    } else if (message.type == InfoMessageTypeOther) {
        
        _scroll.scrollEnabled = NO;
        
        //没有子节点
        if (array.count == 0) {
            
            //self.ID = message.serviceParentId;
            
            //  处理是否显示时间
            [self configTimeLabelWithMessage:message];
            
            //  处理正文的label的文字
            [self configContentLabelWithMessage:message];
            
            //  处理图片
            if (message.serviceImage && [message.serviceImage isNotBlank]) {
                [self configBgViewWithMessage:message];
            }else {
                [self.bgImg updateConstraints:^(MASConstraintMaker *make) {
                    make.height.height.equalTo(0 * WidthCoefficient);
                }];
            }
            
            //  处理提示语
            [self configTipLabelAndLineWithText:@"是否解答您的问题?"];
            
            //  处理无子节点的已解答与未解答
            [self configNoNodeByAnswerAndUnanswer:@[@"已解答", @"未解答"]];
            
        }
        //有子节点
        else {
            _scroll.scrollEnabled = YES;
            
            [self configTimeLabelWithMessage:message];

            /*
            NSString *str;
            str = message.serviceName;
//            if (message.serviceDetails && message.serviceDetails.isNotBlank) {
//                str = message.serviceDetails;
//            }
//            else
//            {
//                str = message.serviceName;
//            }
            [self configLabel:_contentLabel withString:str];
             */
            
            [self configLabel:self.contentLabel withString:message.serviceName];
            
            //  有子节点 没有图片显示
            [self.bgImg updateConstraints:^(MASConstraintMaker *make) {
                make.height.height.equalTo(0 * WidthCoefficient);
            }];
            
            //  有子节点 没有提示语 与 分割线
            _tipLaebel.text = @"";
            [_tipLaebel updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(0);
            }];
            
            [_line updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(0 * WidthCoefficient);
                //make.height.equalTo(1 * WidthCoefficient); 与安卓保持一致都不显示线
            }];
            
            /*
            if (dataArray.count > 2) {//显示线
                [_line updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(0 * WidthCoefficient);
                    //make.height.equalTo(1 * WidthCoefficient); 与安卓保持一致都不显示线
                }];
            } else {//不显示线
                [_line updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(0);
                    //make.height.equalTo(1 * WidthCoefficient);
                }];
            }
            */
            
            //  有子节点 各个功能按钮的跳转处理
            [self configNodeByFunctionJump:dataArray];
        }
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
    
    //  cell无分割线风格
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    //  显示时间的label
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
    
    //  头像
    self.avatar = [[UIImageView alloc] init];
    _avatar.image = [UIImage imageNamed:@"管家头像"];
    [self.contentView addSubview:_avatar];
    [_avatar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(8 * WidthCoefficient);
        make.height.width.equalTo(40 * WidthCoefficient);
        make.top.equalTo(_timeLabel.bottom).offset(10 * WidthCoefficient);
    }];
    
    //  昵称
    self.nameLabel = [[UILabel alloc] init];
    _nameLabel.text = NSLocalizedString(@"DS管家", nil);
    _nameLabel.font = [UIFont fontWithName:FontName size:11];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatar.right).offset(10 * WidthCoefficient);
        make.top.equalTo(_avatar);
        make.height.equalTo(20 * WidthCoefficient);
    }];
    
    //  标题 与 正文
    self.contentLabel = [[YYLabel alloc] init];
    _contentLabel.numberOfLines = 0;
    _contentLabel.preferredMaxLayoutWidth = 220 * WidthCoefficient;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_contentLabel];
    [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel).offset(10 * WidthCoefficient);
        make.top.equalTo(_nameLabel.bottom).offset(10 * WidthCoefficient);
        make.width.equalTo(220 * WidthCoefficient);
        make.height.equalTo(90 * WidthCoefficient);
    }];
    
    //  图片
    self.bgImg = [[UIImageView alloc] init];
    _bgImg.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bgImg];
    [self.bgImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentLabel);
        make.top.equalTo(_contentLabel.bottom).offset(10 * WidthCoefficient);
        make.width.equalTo(220 * WidthCoefficient);
        make.height.equalTo(165 * WidthCoefficient);
    }];
    //  为图片添加手势
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgImageTapAction)];
    [self.bgImg addGestureRecognizer:imageTap];

    //  提示语
    self.tipLaebel = [[UILabel alloc] init];
    _tipLaebel.preferredMaxLayoutWidth = 220 * WidthCoefficient;
    _tipLaebel.numberOfLines = 0;
    _tipLaebel.lineBreakMode = NSLineBreakByWordWrapping;
    _tipLaebel.font = [UIFont fontWithName:FontName size:15];
    _tipLaebel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:_tipLaebel];
    [_tipLaebel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgImg);
        make.top.equalTo(_bgImg.bottom).offset(10 * HeightCoefficient);
        make.width.equalTo(_bgImg);
        make.height.equalTo(0);
    }];
    
    //  提示语上方的分割线
    self.line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor colorWithHexString: @"#A18E79"];
    [self.contentView addSubview:_line];
    [_line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tipLaebel);
        make.leading.trailing.equalTo(_tipLaebel);
        make.height.equalTo(1 * WidthCoefficient);
        make.top.equalTo(_tipLaebel.top).offset(-2.5);
    }];
    
    //  索引用的scrollView 有节点的时候 显示 功能 没有的时候显示 "已解答" "未解答" 两个按钮
    self.scroll = [[UIScrollView alloc] init];
    _scroll.delegate = self;
    _scroll.pagingEnabled = YES;
    _scroll.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:_scroll];
    [_scroll makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tipLaebel.bottom).offset(10 * WidthCoefficient);
        make.centerX.equalTo(_line);
        make.width.equalTo(_tipLaebel).offset(10 * WidthCoefficient);
        make.height.equalTo(176 * WidthCoefficient);
    }];
    
    //  承载scrollView的内容View
    self.scrollContentView = [[UIView alloc] init];
     _scrollContentView.userInteractionEnabled = YES;
    [self.scroll addSubview:self.scrollContentView];
    [self.scrollContentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scroll);
        make.height.equalTo(self.scroll);
    }];
    
    //  对话框的背景图 并将其放在最下面
    self.bubble = [[UIImageView alloc] init];
    _bubble.image = [UIImage imageNamed:@"管家背景"];
    _bubble.userInteractionEnabled = YES;
    [self.contentView addSubview:_bubble];
    [_bubble makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentLabel).offset(-10 * WidthCoefficient);
        make.top.equalTo(_contentLabel).offset(-10 * WidthCoefficient);
        make.right.equalTo(_contentLabel).offset(10 * WidthCoefficient);
        make.bottom.equalTo(_scroll).offset(15 * WidthCoefficient);
    }];
    [self.contentView insertSubview:_bubble belowSubview:_contentLabel];
    
}

#pragma mark- 图片的点击事件
- (void)bgImageTapAction {
    //  如果图片为空就直接返回
    if (self.bgImg.image == nil) {
        return;
    }else {
        if (self.customDelegate != nil && [self.customDelegate respondsToSelector:@selector(sevenProrocolMethod:)]) {
            [self.customDelegate showPic:self.bgImg.image];
        }
    }
}

#pragma mark- 按钮的点击事件
- (void)btnClick:(UIButton *)sender {
    if (self.serviceClickBlock) {
        NSString *Idstr = [_result objectForKey:sender.titleLabel.text];
        NSString *sourceData = [_result1 objectForKey:sender.titleLabel.text];
        NSString *appNum = [_result2 objectForKey:sender.titleLabel.text];
        NSLog(@"sourceData: %@",sourceData);
        self.serviceClickBlock(sender,Idstr,_message.serviceParentId,sourceData,appNum);
    }
}

#pragma mark- scrollView的代理方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    _pageControl.currentPage = targetContentOffset->x / scrollView.frame.size.width;
}

#pragma mark- 处理timeLabel
- (void)configTimeLabelWithMessage:(InfoMessage *)message {
    _timeLabel.text = [self stringFromDate:message.time];
    [_timeLabel updateConstraints:^(MASConstraintMaker *make) {
        if (message.showTime) {
            make.height.equalTo(20 * WidthCoefficient);
        } else {
            make.height.equalTo(0 * WidthCoefficient);
        }
    }];
}

#pragma mark- 处理contentLabel
- (void)configContentLabelWithMessage:(InfoMessage *)message {
    NSString *str;
    if (message.serviceDetails && message.serviceDetails.isNotBlank) {
        str = message.serviceDetails;
    } else {
        str = message.serviceName;
    }
    [self configLabel:_contentLabel withString:str];
}

#pragma mark- 处理bgView
- (void)configBgViewWithMessage:(InfoMessage *)message {
    //  isLeaf 说明 传过来的图片是是url形式的 那么就使用SDWebImage进行图片处理
    
    BOOL fromCache = NO;
    weakifySelf
    //  先从sd缓存取图片
    NSString *cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:message.serviceImage]];
    if (cacheKey) {
        UIImage *cacheImg = [[SDImageCache sharedImageCache] imageFromCacheForKey:cacheKey];
        if (cacheImg) {
            //获取图片宽高
            UIImageView *tmpImgV = [[UIImageView alloc] initWithImage:cacheImg];
            
            self.bgImg.image = cacheImg;
            [self.bgImg updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(220 * WidthCoefficient * CGRectGetHeight(tmpImgV.frame) / CGRectGetWidth(tmpImgV.frame));
            }];
            fromCache = YES;
            [self.customDelegate removeStoredHeightWithCell:self];
        }
    }
    
    //  缓存读不到 通过SD进行网络读取
    if (fromCache == NO) {
        [self.bgImg sd_setImageWithURL:[NSURL URLWithString:message.serviceImage] placeholderImage:[UIImage imageNamed:@"chatbox_loading"] options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            //  图片存在 就使用图片 否则使用占坑图片
            if (image) {
                //获取图片宽高
                UIImageView *tmpImgV = [[UIImageView alloc] initWithImage:image];
                CGFloat showHeight = 220 * WidthCoefficient * CGRectGetHeight(tmpImgV.frame) / CGRectGetWidth(tmpImgV.frame);
                strongifySelf
                
                [self.bgImg updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(showHeight);
                }];
                
                [self layoutIfNeeded];
                
                _pageControl.frame = CGRectMake(_scroll.frame.origin.x, _scroll.frame.origin.y + _scroll.frame.size.height, _scroll.frame.size.width, 0);
                self.message.cellHeight = CGRectGetMaxY(_bubble.frame) + 10 * WidthCoefficient;
                
                NSLog(@"!!!%@",NSStringFromCGRect(_bubble.bounds));
                
                [self.customDelegate updateTableViewWithCell:self CellHeight:self.message.cellHeight DownloadSuccess:YES];
            } else {
                strongifySelf
                [self.bgImg updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(165 * WidthCoefficient);
                }];
                
                self.bgImg.image = [UIImage imageNamed:@"chatbox_fail"];
                
                [self layoutIfNeeded];
                
                _pageControl.frame = CGRectMake(_scroll.frame.origin.x, _scroll.frame.origin.y + _scroll.frame.size.height, _scroll.frame.size.width, 0);
                self.message.cellHeight = CGRectGetMaxY(_bubble.frame) + 10 * WidthCoefficient;
                
                NSLog(@"!!!%@",NSStringFromCGRect(_bubble.bounds));
                
                [self.customDelegate updateTableViewWithCell:self CellHeight:self.message.cellHeight DownloadSuccess:NO];
            }
        }];
    }
}

#pragma mark- 处理tipLabel
- (void)configTipLabelAndLineWithText:(NSString *)text {
    _tipLaebel.text = text;
    CGSize size1 = [_tipLaebel.text stringSizeWithContentSize:CGSizeMake(220 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:15]];
    [_tipLaebel updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(size1.height + 5);
    }];
    
    //显示线
    [_line updateConstraints:^(MASConstraintMaker *make) {
        //make.height.equalTo(0);
        make.height.equalTo(1 * WidthCoefficient);
    }];
}

#pragma mark- 处理没有子节点 最下方的 已解答与未解答 按钮
- (void)configNoNodeByAnswerAndUnanswer:(NSArray<NSString *>*)titleArray {
    NSInteger row = 0;
    row = ceil(titleArray.count / 2.0f);
    if (row > 4) {
        row = 4;
    }
    CGFloat scrollHeight = 31.5 * WidthCoefficient * row + 10 * WidthCoefficient * (row + 1);
    [_scroll updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(scrollHeight);
    }];
    
    NSInteger page = ceil(titleArray.count / 8.0f);
    
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
            make.height.equalTo(_scroll);
        }];
        lastView = v;
        
        
        
        ///添加button
        NSMutableArray *btns = [NSMutableArray arrayWithCapacity:pageArr.count];
        for (NSInteger j = 0; j < pageArr.count; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.needNoRepeat = YES;
            btn.titleLabel.numberOfLines = 0;
            [btn setTitle:pageArr[j] forState:UIControlStateNormal];
            
            btn.titleLabel.font = [UIFont fontWithName:FontName size:12];
            
            if (j==0) {
                //  已解答 按钮
                btn.backgroundColor  = [UIColor colorWithHexString:@"#AC0042"];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else {
                
                //  未解答 按钮
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
    
    
    [_bubble updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_scroll).offset(10 * WidthCoefficient);
    }];
    
    [self layoutIfNeeded];
    
    _pageControl.frame = CGRectMake(_scroll.frame.origin.x, _scroll.frame.origin.y + _scroll.frame.size.height, _scroll.frame.size.width, 0);
    _pageControl.currentColor = [UIColor colorWithHexString:GeneralColorString];
    _pageControl.otherColor = [UIColor colorWithHexString:@"#e6e6e6"];
    self.message.cellHeight = CGRectGetMaxY(_bubble.frame) + 10 * WidthCoefficient;
}

#pragma mark- 处理有子节点 各个功能按钮的跳转
- (void)configNodeByFunctionJump:(NSMutableArray<NSString *>*)dataArray {
    NSInteger row = 0;
    row = ceil(dataArray.count / 2.0f);
    if (row > 4) {
        row = 4;
    }
    CGFloat scrollHeight = 31.5 * WidthCoefficient * row + 10 * WidthCoefficient * (row + 1);
    [_scroll updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(scrollHeight);
    }];
    
    NSInteger page = ceil(dataArray.count / 8.0f);
    
    UIView *lastView;
    for (NSInteger i = 0; i < page; i++) {
        
        NSArray *pageArr = [NSArray array];
        if (i == page -1) {
            pageArr = [dataArray subarrayWithRange:NSMakeRange(8 * i, (dataArray.count % 8 == 0) ? 8 : dataArray.count % 8)];
        } else {
            pageArr = [dataArray subarrayWithRange:NSMakeRange(8 * i, 8)];
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
            if (i == page - 1) {//最后一页
                NSInteger pageRows = ceil(pageArr.count / 2.0f);
                CGFloat pageHeight = pageRows * 31.5 * WidthCoefficient + (pageRows + 1) * 10 * WidthCoefficient;
                make.height.equalTo(pageHeight);
            } else {
                make.height.equalTo(_scroll);
            }
        }];
        lastView = v;
        
        ///添加button
        NSMutableArray *btns = [NSMutableArray arrayWithCapacity:pageArr.count];
        for (NSInteger j = 0; j < pageArr.count; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.numberOfLines = 0;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.needNoRepeat = YES;
            [btn setTitle:pageArr[j] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:FontName size:12];
            btn.backgroundColor = [UIColor colorWithHexString:@"#413E3D"];
            btn.layer.cornerRadius = 4;
            [v addSubview:btn];
            [btns addObject:btn];
        }
        
        if (btns.count==1) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.numberOfLines = 0;
            [btn setTitle:pageArr[0] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:FontName size:12];
            btn.backgroundColor = [UIColor colorWithHexString:@"#413E3D"];
            btn.layer.cornerRadius = 4;
            btn.needNoRepeat = YES;
            [v addSubview:btn];
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(10 * WidthCoefficient);
                make.width.equalTo(105 * WidthCoefficient);
                make.height.equalTo(31.5 * WidthCoefficient);
                make.left.equalTo(5 * WidthCoefficient);
            }];
        } else {
            
            [btns mas_distributeSudokuViewsWithFixedItemWidth:105 * WidthCoefficient fixedItemHeight:31.5 * WidthCoefficient warpCount:2 topSpacing:10 * WidthCoefficient bottomSpacing:10 * WidthCoefficient leadSpacing:5 * WidthCoefficient tailSpacing:5 * WidthCoefficient];
        }
        
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
    _pageControl.numberOfPages = page==1?0:page;
    _pageControl.controlSize = 6;
    _pageControl.controlSpacing = 6;
    
    self.message.cellHeight = CGRectGetMaxY(_bubble.frame) + 10 * WidthCoefficient;
}

#pragma mark- 工具类方法

#pragma mark- date 转 字符串
- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M月d日 HH:mm";
    return [formatter stringFromDate:date];
}

#pragma mark- 从字符串中获取url数组
- (NSArray*)getURLFromStr:(NSString *)string {
    NSError *error;
    /**
    //可以识别url的正则表达式
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
         options:NSRegularExpressionCaseInsensitive error:&error];
     NSArray *arrayOfAllMatches = [regex matchesInString:string options:0
     range:NSMakeRange(0, [string length])];
    **/
    NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSArray *arrayOfAllMatches = [dataDetector matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    
    //NSString *subStr;
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        if (match.resultType != NSTextCheckingTypeLink) {
            continue;
        }
        NSString* substringForMatch = [string substringWithRange:match.range];
        [arr addObject:substringForMatch];
    }
    return arr;
}

- (void)configLabel:(YYLabel *)label withString:(NSString *)text {
    
    NSMutableAttributedString *oriAttStr = [[NSMutableAttributedString alloc] initWithString:text];
    oriAttStr.yy_font = [UIFont fontWithName:FontName size:15];
    oriAttStr.yy_color = [UIColor whiteColor];
    label.attributedText = oriAttStr;
    
    //a标签正则
    NSString *regex_alabel = @"<a href=(?:.*?)>(.*?)<\\/a>";
    
    //匹配多个a标签
    NSArray *array_alabel = [self arrayOfCaptureComponentsOfString:text matchedByRegex:regex_alabel];
    
    if (array_alabel.count) {
        //先把html a标签去掉
        NSString *labelText = [text stringByReplacingOccurrencesOfString:@"<a href=(.*?)>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, text.length)];
        labelText = [labelText stringByReplacingOccurrencesOfString:@"<\\/a>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, labelText.length)];
        
        //样式文本
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:labelText];
        attStr.yy_font = [UIFont fontWithName:FontName size:15];
        attStr.yy_color = [UIColor whiteColor];
        
        for (NSArray *array in array_alabel) {
            //获得链接显示文字的range,高亮颜色
            NSRange range = [labelText rangeOfString:array[1]];
            [attStr yy_setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] range:range];
            [attStr yy_setColor:[UIColor colorWithHexString:@"e2cd8d"] range:range];
            
            //高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            //数据信息存储,用于稍后点击获取url
            NSString *origin = array[0];
            NSString *linkStr = [self subStringForString:origin From:@"href=" to:@">"];
            linkStr = [self getURLFromString:linkStr];
            highlight.userInfo = @{@"linkUrl": linkStr};
            [attStr yy_setTextHighlight:highlight range:range];
        }
        label.attributedText = attStr;
    }
    
    weakifySelf
    label.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:range.location effectiveRange:NULL];
        NSDictionary *userInfo = highlight.userInfo;
        NSString *linkText = userInfo[@"linkUrl"];
        if (linkText) {
            strongifySelf
            //跳转网页
            if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(sevenProrocolMethod:)]) {
                [self.customDelegate sevenProrocolMethod:linkText];
            };
        }
    };
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(220 * WidthCoefficient, MAXFLOAT) text:label.attributedText];
    [label updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(layout.textBoundingSize.height);
    }];
}

- (NSString *)getURLFromString:(NSString *)string {
    NSError *error;
    NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSArray *arrayOfAllMatches = [dataDetector matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *match in arrayOfAllMatches) {
        if (match.resultType != NSTextCheckingTypeLink) {
            continue;
        }
        NSString *substringForMatch = [string substringWithRange:match.range];
        return substringForMatch;
    }
    return nil;
}

- (NSString *)subStringForString:(NSString *)string From:(NSString *)startString to:(NSString *)endString {
    
    NSRange startRange = [string rangeOfString:startString];
    NSRange endRange = [string rangeOfString:endString];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [string substringWithRange:range];
    
}

- (NSArray *)arrayOfCaptureComponentsOfString:(NSString *)data matchedByRegex:(NSString *)regex {
    NSError *error;
    NSRegularExpression *regExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSMutableArray *test = [NSMutableArray array];
    
    NSArray *matches = [regExpression matchesInString:data options:NSMatchingReportProgress range:NSMakeRange(0, data.length)];
    
    for(NSTextCheckingResult *match in matches) {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:match.numberOfRanges];
        for(NSInteger i=0; i<match.numberOfRanges; i++) {
            NSRange matchRange = [match rangeAtIndex:i];
            NSString *matchStr = nil;
            if(matchRange.location != NSNotFound) {
                matchStr = [data substringWithRange:matchRange];
            } else {
                matchStr = @"";
            }
            [result addObject:matchStr];
        }
        [test addObject:result];
    }
    return test;
}

#pragma mark- dealloc
- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end

