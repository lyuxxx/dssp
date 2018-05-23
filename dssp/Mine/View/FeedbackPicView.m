//
//  FeedbackPicView.m
//  dssp
//
//  Created by dy on 2018/5/22.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "FeedbackPicView.h"

#define kMaxImageCount 4

@interface FeedbackPicView()

/** 提示Label*/
@property (nonatomic, weak) UILabel *promptLabel;
/** 图片数量Label*/
@property (nonatomic, weak) UILabel *imageCountLabel;

@end

@implementation FeedbackPicView

#pragma mark - 初始化
- (instancetype)init {
    
    if (self = [super init]) {
        
        [self setupUI];
        
    }
    return self;
}

#pragma mark - 搭建界面
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *promptLabel = [UILabel new];
    promptLabel.textColor = [UIColor lightGrayColor];
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.text = NSLocalizedString(@"图片 (选填,提供问题截图)", nil);
    [self addSubview:promptLabel];
    _promptLabel = promptLabel;
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self);
    }];
    
    UILabel *imageCountLabel = [UILabel new];
    imageCountLabel.textColor = [UIColor lightGrayColor];
    imageCountLabel.font = [UIFont systemFontOfSize:14];
    imageCountLabel.text = [NSString stringWithFormat:@"0/%d", kMaxImageCount];
    [self addSubview:imageCountLabel];
    _imageCountLabel = imageCountLabel;
    [imageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(self);
    }];
}

#pragma mark- 对外方法
-(void)setPromptText:(NSString *)promptText {
    self.promptLabel.text = promptText;
}

- (void)setImageCount:(NSString *)imageCount {
    self.imageCountLabel.text = [NSString stringWithFormat:@"%@/%d", imageCount, kMaxImageCount];
}

@end
