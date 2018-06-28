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
//@property (nonatomic, strong) UITextView *contentLabel;
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

@property (nonatomic, copy) NSString *URL;

@end

@implementation InfoMessageHelpCenterCell

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

+ (instancetype)cellWithTableView:(UITableView *)tableView serviceBlock:(void (^)(UIButton *,NSString *,NSString *,NSString *,NSString *))block {
    InfoMessageHelpCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoMessageHelpCenterCell"];
    if (!cell) {
        cell = [[InfoMessageHelpCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoMessageHelpCenterCell"];
    }
     cell.backgroundColor = [UIColor clearColor];
    cell.serviceClickBlock = block;
    return cell;
}

- (void)setMessage:(InfoMessage *)message {
    
  
    _message = message;
    
    [self.scrollContentView removeAllSubviews];
    [self.scroll setContentOffset:CGPointMake(0, 0) animated:NO];
    
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
        }
        else
        {
            
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
    }
    else if (message.type == InfoMessageTypeOther)
    {
        _scroll.scrollEnabled = NO;
        NSMutableArray *dataArray1= [[NSMutableArray alloc] init];
        [dataArray1 addObject:@"已解答"];
        [dataArray1 addObject:@"未解答"];
        //没有子节点
        if (array.count == 0) {
            //判断是否有图片
            if (message.serviceImage)
            {
//                self.ID = message.serviceParentId;
                
                _timeLabel.text = [self stringFromDate:message.time];
                [_timeLabel updateConstraints:^(MASConstraintMaker *make) {
                    if (message.showTime) {
                        make.height.equalTo(20 * WidthCoefficient);
                    } else {
                        make.height.equalTo(0 * WidthCoefficient);
                    }
                }];
                
                NSArray *urlArr = [NSArray new];
                NSString *str;
                
                if (message.serviceDetails && message.serviceDetails.isNotBlank) {
                    str = message.serviceDetails;
                }
                else
                {
                    str = message.serviceName;
                }
                [self configLabel:_contentLabel withString:str];
//                if([self isURL:str]) {
//                    _contentLabel.text = str;
////                    _contentLabel.textColor =[UIColor whiteColor];
//                    CGSize size = [str stringSizeWithContentSize:CGSizeMake(220 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:15]];
//                    [_contentLabel updateConstraints:^(MASConstraintMaker *make) {
//                        make.height.equalTo(size.height);
//                    }];
//
//                } else {
//
//                    urlArr = [self getURLFromStr:str];
//
//                    if (urlArr.count==0) {
//                        _URL = @"";
//                    }
//                    else
//                    {
//                        _URL = (NSString *)urlArr[0] ;
//                    }
//
////                    NSString *text = message.serviceDetails;
//                    CGSize size = [message.serviceDetails stringSizeWithContentSize:CGSizeMake(220 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:15]];
//                    [_contentLabel updateConstraints:^(MASConstraintMaker *make) {
//                        make.height.equalTo(size.height+5);
//                    }];
//
//                    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:str];
//
//                    /**
//                     *  设置整段文本size
//                     */
//                    one.yy_font = [UIFont fontWithName:FontName size:15];
//                    one.yy_color = [UIColor whiteColor];
//
//                    NSRange range = [str rangeOfString:_URL];
//                    //                    [_one yy_setTextUnderline:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle] range:range];
//                    [one yy_setFont:[UIFont boldSystemFontOfSize:15] range:range];
//
//                    /**
//                     *  被标记的文字颜色
//                     */
//                    UIColor *textColor = [UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000];
//
//                    [one yy_setTextHighlightRange:range color:textColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//
//                        NSLog(@"1323423");
//
//                    }];
//
//                    _contentLabel.attributedText = one;
//
//                    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
//                    // 2. 将点击事件添加到label上
//                    [_contentLabel addGestureRecognizer:labelTapGestureRecognizer];
//                    _contentLabel.userInteractionEnabled = YES;
//                    // 可以理解为设置label可被点击
//
//                }
                
                if (message.isLeaf) {
                    BOOL fromCache = NO;
                    weakifySelf
                    //先从sd缓存取图片
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
                    if (fromCache == NO) {
                        [self.bgImg sd_setImageWithURL:[NSURL URLWithString:message.serviceImage] placeholderImage:[UIImage imageNamed:@"chatbox_loading"] options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
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
                } else {
                    NSData * imageData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    
                    UIImage *photo = [UIImage imageWithData:imageData];
                    
                    //获取图片宽高
                    UIImageView *tmpImgV = [[UIImageView alloc] initWithImage:photo];
                    
                    self.bgImg.image = photo;
                    [self.bgImg updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(220 * WidthCoefficient * CGRectGetHeight(tmpImgV.frame) / CGRectGetWidth(tmpImgV.frame));
                    }];
                }
                
                _contentLabel1.text = @"是否解答您的问题?";
                CGSize size1 = [_contentLabel1.text stringSizeWithContentSize:CGSizeMake(220 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:15]];
                [_contentLabel1 updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(size1.height);
                }];
                
                //不显示线
                [_line updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(0);
                }];
                
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
                        //                    if (i == page - 1) {//最后一页
                        //                        NSInteger pageRows = ceil(pageArr.count / 2.0f);
                        //                        CGFloat pageHeight = pageRows * 31.5 * WidthCoefficient + (pageRows + 1) * 10 * WidthCoefficient;
                        //                        make.height.equalTo(pageHeight);
                        //                    } else {
                        make.height.equalTo(_scroll);
                        //                    }
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
                
                
                [_bubble updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(_scroll).offset(10 * WidthCoefficient);
                }];
                
                [self layoutIfNeeded];
                
                _pageControl.frame = CGRectMake(_scroll.frame.origin.x, _scroll.frame.origin.y + _scroll.frame.size.height, _scroll.frame.size.width, 0);
                _pageControl.currentColor = [UIColor colorWithHexString:GeneralColorString];
                _pageControl.otherColor = [UIColor colorWithHexString:@"#e6e6e6"];
                self.message.cellHeight = CGRectGetMaxY(_bubble.frame) + 10 * WidthCoefficient;
                
            }
            else
            {
            
//            self.ID = message.serviceParentId;
            _timeLabel.text = [self stringFromDate:message.time];
            [_timeLabel updateConstraints:^(MASConstraintMaker *make) {
                if (message.showTime) {
                    make.height.equalTo(20 * WidthCoefficient);
                } else {
                    make.height.equalTo(0 * WidthCoefficient);
                }
            }];
            
                NSArray *urlArr = [NSArray new];
                NSString *str;

                if (message.serviceDetails && message.serviceDetails.isNotBlank) {
                    str = message.serviceDetails;
                }
                else
                {
                    str = message.serviceName;
                }
                [self configLabel:_contentLabel withString:str];
//                if([self isURL:str]) {
//                _contentLabel.text = str;
////                _contentLabel.textColor =[UIColor whiteColor];
//                CGSize size = [str stringSizeWithContentSize:CGSizeMake(220 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:15]];
//                    [_contentLabel updateConstraints:^(MASConstraintMaker *make) {
//                        make.height.equalTo(size.height+5);
//                    }];
//
//                } else {
//
//                    urlArr = [self getURLFromStr:str];
//
//                    if (urlArr.count==0) {
//                        _URL = @"";
//                    }
//                    else
//                    {
//                        _URL = (NSString *)urlArr[0] ;
//                    }
//
//                    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:str];
//                    CGSize size = [str stringSizeWithContentSize:CGSizeMake(220 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:15]];
//                    [_contentLabel updateConstraints:^(MASConstraintMaker *make) {
//                        make.height.equalTo(size.height+5);
//                    }];
//
//                    // 设置整段文本size
//                    one.yy_font = [UIFont fontWithName:FontName size:15];
//                    one.yy_color = [UIColor whiteColor];
//
//                    //获得range， 只设置标记文字的size、下划线
//                    NSRange range = [str rangeOfString:_URL];
////                    [_one yy_setTextUnderline:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle] range:range];
//                    [one yy_setFont:[UIFont boldSystemFontOfSize:15] range:range];
//
//                //被标记的文字颜色
//                  UIColor *textColor = [UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000];
//
//
//                [one yy_setTextHighlightRange:range color:textColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//
//                        NSLog(@"1323423");
//
//                    }];
//
//
//                    _contentLabel.attributedText = one;
//
//                    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
//                    // 2. 将点击事件添加到label上
//                    [_contentLabel addGestureRecognizer:labelTapGestureRecognizer];
//                    _contentLabel.userInteractionEnabled = YES;
//                    // 可以理解为设置label可被点击
//
//
//                }
                
            [self.bgImg updateConstraints:^(MASConstraintMaker *make) {
                    make.height.height.equalTo(0 * WidthCoefficient);
            }];
            
            _contentLabel1.text = @"是否解答您的问题?";
            CGSize size1 = [_contentLabel1.text stringSizeWithContentSize:CGSizeMake(220 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:15]];
                [_contentLabel1 updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(size1.height);
            }];
            
            //不显示线
            [_line updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(0);
            }];
            
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
//                    if (i == page - 1) {//最后一页
//                        NSInteger pageRows = ceil(pageArr.count / 2.0f);
//                        CGFloat pageHeight = pageRows * 31.5 * WidthCoefficient + (pageRows + 1) * 10 * WidthCoefficient;
//                        make.height.equalTo(pageHeight);
//                    } else {
                        make.height.equalTo(_scroll);
//                    }
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
            
            
            [_bubble updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_scroll).offset(10 * WidthCoefficient);
            }];
            
            [self layoutIfNeeded];
            
            _pageControl.frame = CGRectMake(_scroll.frame.origin.x, _scroll.frame.origin.y + _scroll.frame.size.height, _scroll.frame.size.width, 0);
            _pageControl.currentColor = [UIColor colorWithHexString:GeneralColorString];
            _pageControl.otherColor = [UIColor colorWithHexString:@"#e6e6e6"];
            
            
            self.message.cellHeight = CGRectGetMaxY(_bubble.frame) + 10 * WidthCoefficient;
          }
        }
       //有子节点
        else
        {
            _scroll.scrollEnabled = YES;
            _timeLabel.text = [self stringFromDate:message.time];
            [_timeLabel updateConstraints:^(MASConstraintMaker *make) {
                if (message.showTime) {
                    make.height.equalTo(20 * WidthCoefficient);
                } else {
                    make.height.equalTo(0 * WidthCoefficient);
                }
            }];

            
            NSArray *urlArr = [NSArray new];
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
//            if([self isURL:str]) {
//                _contentLabel.text = str;
//                //_contentLabel.textColor =[UIColor whiteColor];
//                CGSize size = [str stringSizeWithContentSize:CGSizeMake(220 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:15]];
//                [_contentLabel updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.equalTo(size.height);
//                }];
//
//            } else {
//
//                urlArr = [self getURLFromStr:str];
//                if (urlArr.count==0) {
//                    _URL = @"";
//                }
//                else
//                {
//                    _URL = (NSString *)urlArr[0] ;
//                }
//
//                NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:str];
//                CGSize size = [str stringSizeWithContentSize:CGSizeMake(220 * WidthCoefficient, MAXFLOAT) font:[UIFont fontWithName:FontName size:15]];
//                [_contentLabel updateConstraints:^(MASConstraintMaker *make) {
//                    make.height.equalTo(size.height+5);
//                }];
//
//                // 设置整段文本size
//                one.yy_font = [UIFont fontWithName:FontName size:15];
//                one.yy_color = [UIColor whiteColor];
//
//                //获得range， 只设置标记文字的size、下划线
//                NSRange range = [str rangeOfString:_URL];
//                //                    [_one yy_setTextUnderline:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle] range:range];
//                [one yy_setFont:[UIFont boldSystemFontOfSize:15] range:range];
//
//                //被标记的文字颜色
//                UIColor *textColor = [UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000];
//
//                [one yy_setTextHighlightRange:range color:textColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull str, NSRange range, CGRect rect) {
//
//                    NSLog(@"1323423");
//
//                }];
//
//                _contentLabel.attributedText = one;
//
//                UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
//                // 2. 将点击事件添加到label上
//                [_contentLabel addGestureRecognizer:labelTapGestureRecognizer];
//                _contentLabel.userInteractionEnabled = YES;
//                // 可以理解为设置label可被点击
//
//            }
            
            
          
            [self.bgImg updateConstraints:^(MASConstraintMaker *make) {
                make.height.height.equalTo(0 * WidthCoefficient);
            }];
            
            
            _contentLabel1.text = @"";
            [_contentLabel1 updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(0);
            }];
            
            if (dataArray.count > 2) {//显示线
                [_line updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(0 * WidthCoefficient);//make.height.equalTo(1 * WidthCoefficient); 与安卓保持一致都不显示线
                }];
            } else {//不显示线
                [_line updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(0);
                }];
            }
            
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
            
            [self.scrollContentView removeAllSubviews];
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
                }
                else
                {
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
    }
}

//- (void)labelClick {
//
//    if ([_URL isEqualToString:@""] || !_URL) {
//        return;
//    }
//    else
//    {
//        if (self.customDelegate != nil && [self.customDelegate respondsToSelector:@selector(sevenProrocolMethod:)])
//        {
//            [self.customDelegate sevenProrocolMethod:_URL];
//        }
//    }
//}

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    _nameLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatar.right).offset(10 * WidthCoefficient);
        make.top.equalTo(_avatar);
        make.height.equalTo(20 * WidthCoefficient);
    }];
    
  
    self.contentLabel = [[YYLabel alloc] init];
//    _contentLabel.userInteractionEnabled = YES;
    _contentLabel.numberOfLines = 0;  //设置多行显示
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
    
    
//    self.contentLabel = [[UITextView alloc] init];
//    //系统会为其默认设置距UITextView上、下边缘各8的页边距
//    _contentLabel.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    //textContainer中的文段的上、下、左、右又会被填充5的空白
//    _contentLabel.textContainer.lineFragmentPadding = 0;
//    _contentLabel.backgroundColor = [UIColor clearColor];
////    _contentLabel.font = [UIFont systemFontOfSize:14];
//    _contentLabel.font = [UIFont fontWithName:FontName size:15];
//    //    textView.text=label.text;
//    _contentLabel.textColor =[UIColor whiteColor];
//    //禁止编辑
//    _contentLabel.editable = NO;
//    //设置需要识别的类型，这设置的是全部
//    _contentLabel.dataDetectorTypes = UIDataDetectorTypeAll;
//     [self.contentView addSubview:_contentLabel];
//    [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_nameLabel).offset(10 * WidthCoefficient);
//        make.top.equalTo(_nameLabel.bottom).offset(10 * WidthCoefficient);
//        make.width.equalTo(220 * WidthCoefficient);
//        make.height.equalTo(67 * WidthCoefficient);
//    }];
    

    
    self.contentLabel1 = [[UILabel alloc] init];
    _contentLabel1.preferredMaxLayoutWidth = 220 * WidthCoefficient;
    _contentLabel1.numberOfLines = 0;
    _contentLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel1.font = [UIFont fontWithName:FontName size:15];
    _contentLabel1.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:_contentLabel1];
    [_contentLabel1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgImg);
        make.top.equalTo(_bgImg.bottom);
        make.width.equalTo(_bgImg);
        make.height.equalTo(0);
    }];
    
    self.line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashLine"]];
    [self.contentView addSubview:_line];
    [_line makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_contentLabel1);
        make.width.equalTo(_contentLabel1).offset(10 * WidthCoefficient);
        make.height.equalTo(1 * WidthCoefficient);
        make.top.equalTo(_contentLabel1.bottom).offset(10 * WidthCoefficient);
    }];
    
    self.scroll = [[UIScrollView alloc] init];
    _scroll.delegate = self;
    _scroll.pagingEnabled = YES;
    _scroll.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:_scroll];
    [_scroll makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_line.bottom);
        make.centerX.equalTo(_line);
        make.width.equalTo(_line);
        make.height.equalTo(176 * WidthCoefficient);
    }];
    
    self.scrollContentView = [[UIView alloc] init];
     _scrollContentView.userInteractionEnabled = YES;
    [self.scroll addSubview:self.scrollContentView];
    [self.scrollContentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scroll);
        make.height.equalTo(self.scroll);
    }];
    
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



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    _pageControl.currentPage = targetContentOffset->x / scrollView.frame.size.width;
}

- (void)btnClick:(UIButton *)sender {
    if (self.serviceClickBlock) {
        NSString *Idstr = [_result objectForKey:sender.titleLabel.text];
        NSString *sourceData = [_result1 objectForKey:sender.titleLabel.text];
        NSString *appNum = [_result2 objectForKey:sender.titleLabel.text];
        NSLog(@"2233%@",sourceData);
        self.serviceClickBlock(sender,Idstr,_message.serviceParentId,sourceData,appNum);
    }
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M月d日 HH:mm";
    return [formatter stringFromDate:date];
}



//该函数没有用
- (BOOL)isURL:(NSString *)url {
    return NO;
    if(url.length < 1)
        return NO;
    if (url.length>4 && [[url substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",url];
    } else {
        url = url;
    }
    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";

    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];

    return [urlTest evaluateWithObject:url];
}

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
            [attStr yy_setFont:[UIFont fontWithName:FontName size:15] range:range];
            [attStr yy_setColor:[UIColor colorWithHexString:GeneralColorString] range:range];
            
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

- (NSString *)subStringForString:(NSString *)string From:(NSString *)startString to:(NSString *)endString{
    
    NSRange startRange = [string rangeOfString:startString];
    NSRange endRange = [string rangeOfString:endString];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [string substringWithRange:range];
    
}

- (NSArray *)arrayOfCaptureComponentsOfString:(NSString *)data matchedByRegex:(NSString *)regex
{
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

@end

