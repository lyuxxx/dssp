//
//  FeedbackController.m
//  dssp
//
//  Created by dy on 2018/5/22.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "FeedbackController.h"
#import "PlaceholderTextView.h"
#import "FeedbackPicView.h"
#import "FeedbackChoosePicView.h"
#import "CUHTTPRequestCallback.h"

//  定义宏
#define kActivityQuestion 100
#define kCarQuestion 101
#define kAppQuestion 102
#define kOtherQuestion 103
#define kFeedbackButtonWidth 82 * WidthCoefficient
#define kFeedbackButtonHeight 24 * HeightCoefficient
#define kMaxInputCount 200

@interface FeedbackController () <UITextViewDelegate>
/** 第一个竖线*/
@property (nonatomic, strong) UIView *firstLine;
/** 发生场景的说明文字*/
@property (nonatomic, strong) UILabel *happenLabel;
/** 激活问题按钮*/
@property (nonatomic, strong) UIButton *activityQuestionButton;
/** 车辆问题按钮*/
@property (nonatomic, strong) UIButton *carQuestionButton;
/** app问题按钮*/
@property (nonatomic, strong) UIButton *appQuestionButton;
/** 其他问题按钮*/
@property (nonatomic, strong) UIButton *otherQuestionButton;
/** 按钮数组*/
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
/** 第二根线*/
@property (nonatomic, strong) UIView *secondLine;
/** 意见反馈区域*/
@property (nonatomic, strong) UIView *feedbackArea;
/** 意见和反馈*/
@property (nonatomic, strong) UILabel *feedbackLabel;
/** 意见反馈输入框*/
@property (nonatomic, strong) PlaceholderTextView *textView;
/** 输入文字字数展示*/
@property (nonatomic, strong) UILabel *inputCountLabel;
/** 意见反馈的警告图片*/
@property (nonatomic, strong) UIImageView *feedbackWarnIcon;
/** 意见反馈的警告文字*/
@property (nonatomic, strong) UILabel *feedbackWarnLabel;
/** 图片区域*/
@property (nonatomic, strong) FeedbackPicView *picView;
/** 图片选择区域*/
@property (nonatomic, strong) FeedbackChoosePicView *choosePicView;
/** 提交按钮*/
@property (nonatomic, strong) UIButton *commintButton;

@end

@implementation FeedbackController

#pragma mark- 方法重写
- (BOOL)needGradientBg {
    return YES;
}

#pragma mark- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self onInitEvent];
}

#pragma mark- 搭建界面
- (void)setUpUI {
    self.navigationItem.title = NSLocalizedString(@"意见反馈", nil);
    
    CGFloat margin = (kScreenWidth - 16 * 2 - 4 * kFeedbackButtonWidth) / 3;
    
    [self.view addSubview:self.firstLine];
    [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(3 * WidthCoefficient);
        make.height.mas_equalTo(15 * HeightCoefficient);
        make.top.mas_equalTo(self.view).offset(20 * HeightCoefficient);
        make.leading.mas_equalTo(self.view).offset(16 * WidthCoefficient);
    }];
    
    [self.view addSubview:self.happenLabel];
    [self.happenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.firstLine.mas_trailing).offset(5 * WidthCoefficient);
        make.centerY.mas_equalTo(self.firstLine);
    }];
    
    [self.view addSubview:self.activityQuestionButton];
    [self.buttons addObject:self.activityQuestionButton];
    [self.activityQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.firstLine);
        make.width.mas_equalTo(kFeedbackButtonWidth);
        make.height.mas_equalTo(kFeedbackButtonHeight);
        make.top.mas_equalTo(self.happenLabel.mas_bottom).offset(15 * HeightCoefficient);
    }];
    
    [self.view addSubview:self.carQuestionButton];
    [self.buttons addObject:self.carQuestionButton];
    [self.carQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.activityQuestionButton.mas_trailing).offset(margin);
        make.width.mas_equalTo(kFeedbackButtonWidth);
        make.height.mas_equalTo(kFeedbackButtonHeight);
        make.top.mas_equalTo(self.activityQuestionButton);
    }];
    
    [self.view addSubview:self.appQuestionButton];
    [self.buttons addObject:self.appQuestionButton];
    [self.appQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.carQuestionButton.mas_trailing).offset(margin);
        make.width.mas_equalTo(kFeedbackButtonWidth);
        make.height.mas_equalTo(kFeedbackButtonHeight);
        make.top.mas_equalTo(self.activityQuestionButton);
    }];
    
    [self.view addSubview:self.otherQuestionButton];
    [self.buttons addObject:self.otherQuestionButton];
    [self.otherQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.appQuestionButton.mas_trailing).offset(margin);
        make.width.mas_equalTo(kFeedbackButtonWidth);
        make.height.mas_equalTo(kFeedbackButtonHeight);
        make.top.mas_equalTo(self.activityQuestionButton);
    }];
    
    [self.view addSubview:self.secondLine];
    [self.secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(3 * WidthCoefficient);
        make.height.mas_equalTo(15 * HeightCoefficient);
        make.top.mas_equalTo(self.activityQuestionButton.mas_bottom).offset(20 * HeightCoefficient);
        make.leading.mas_equalTo(self.view).offset(16 * WidthCoefficient);
    }];
    
    [self.view addSubview:self.feedbackLabel];
    [self.feedbackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.secondLine.mas_trailing).offset(5 * WidthCoefficient);
        make.centerY.mas_equalTo(self.secondLine);
    }];
    
    [self.view addSubview:self.feedbackArea];
    [self.feedbackArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(16 * WidthCoefficient);
        make.trailing.mas_equalTo(self.view).offset(-16 * WidthCoefficient);
        make.top.mas_equalTo(self.feedbackLabel.mas_bottom).offset(15 * HeightCoefficient);
        make.height.mas_equalTo(140 * HeightCoefficient);
    }];
    
    [self.feedbackArea addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.feedbackArea);
        make.height.mas_equalTo(116 * HeightCoefficient);
    }];
    
    [self.feedbackArea addSubview:self.inputCountLabel];
    [self.inputCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.feedbackArea).offset(-10 * WidthCoefficient);
        //make.bottom.mas_equalTo(self.feedbackArea).offset(-10 * HeightCoefficient);
        make.top.mas_equalTo(self.textView.mas_bottom);
        make.width.mas_equalTo(100 * WidthCoefficient);
    }];
    
    [self.view addSubview:self.feedbackWarnIcon];
    [self.feedbackWarnIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16 * WidthCoefficient);
        make.leading.mas_equalTo(self.feedbackArea);
        make.top.mas_equalTo(self.feedbackArea.mas_bottom).offset(10 * HeightCoefficient);
    }];
    
    [self.view addSubview:self.feedbackWarnLabel];
    [self.feedbackWarnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.feedbackWarnIcon);
        make.leading.mas_equalTo(self.feedbackWarnIcon.mas_trailing).offset(5 * WidthCoefficient);
    }];
    
    [self.view addSubview:self.picView];
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.feedbackWarnLabel.mas_bottom).offset(15 * HeightCoefficient);
        make.leading.trailing.mas_equalTo(self.feedbackArea);
        make.height.mas_equalTo(114 * HeightCoefficient);
    }];
    
    [self.picView addSubview:self.choosePicView];
    [self.choosePicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.picView).offset(10 * WidthCoefficient);
        make.bottom.mas_equalTo(self.picView);//.offset(-5 * HeightCoefficient);
        make.trailing.equalTo(self.picView);
        make.top.mas_equalTo(self.picView).offset(40 * HeightCoefficient - 3 * WidthCoefficient);
    }];
    
    [self.view addSubview:self.commintButton];
    [self.commintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(52 * WidthCoefficient);
        make.trailing.mas_equalTo(self.view).offset(-52 * WidthCoefficient);
        make.top.mas_equalTo(self.picView.mas_bottom).offset(30 * HeightCoefficient);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark- 回调事件
- (void)onInitEvent {
    __weak typeof(self)weakSelf = self;
    self.choosePicView.pickerCallback = ^(TZImagePickerController *picker){
        [weakSelf presentViewController:picker animated:YES completion:nil];
    };
    
    self.choosePicView.imageCountCallback = ^(NSString *imageCount) {
        [weakSelf.picView setImageCount:imageCount];
    };
}

#pragma mark- 按钮的点击事件
- (void)buttonAction:(UIButton *) button {
    NSLog("点击了反馈按钮");
    
    //  如果已经被选中,那么返回
    if (button.selected) { return; }
    
    //  否则进行遍历
    for (UIButton *feedbackButton in self.buttons) {
        if (feedbackButton == button) {
            button.selected = YES;
            [self setButtonBackgroundColor:button];
        }else {
            feedbackButton.selected = NO;
            [self setButtonBackgroundColor:feedbackButton];
        }
    }
}

- (void)commitButtonAction:(UIButton *) button {
    NSLog("点击了提交按钮")
    
    if (self.textView.text.length == 0) {
        [MBProgressHUD showText:@"输入内容不能为空!"];
        return;
    }
    
    if (self.textView.text.length < 5) {
        [MBProgressHUD showText:@"输入内容不能少于5个字!"];
        return;
    }
    
    CUHTTPRequestCallback * callback = [CUHTTPRequestCallback new];
    
    callback.success = ^(id value) {
        [self showSuccessHub];
    };
    
    callback.failure = ^(NSInteger code) {
        
    };
    
    [self feedbackRequest:callback];
}

#pragma mark- 多图上传的网络请求
- (void)feedbackRequest:(CUHTTPRequestCallback *)callback {
    //  userId
    NSNumber *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    //  vin
    NSString *vin = kVin;
    
    //  question
    NSString *question = self.textView.text;
    
    //  scene
    NSString * scene = nil;
    for (UIButton *feedbackButton in self.buttons) {
        if (feedbackButton.selected) {
            scene = [feedbackButton titleForState:UIControlStateSelected];
        }
    }
    
    //  imageDatas
    NSMutableArray<NSData *> *imageDatas = [NSMutableArray array];
    if ([self.choosePicView.imageArray count] > 1) {
        
        NSArray<UIImage *> *images = self.choosePicView.imageArray;
        
        for (UIImage *image in images) {
            NSData *data = UIImageJPEGRepresentation(image, 0.5);
            if (data) {
                [imageDatas addObject:data];
            }
        }
        
        [imageDatas removeLastObject];
    }
    
    NSDictionary *paras = @{
                            @"vin": vin,
                            @"userId": userId,
                            @"question": question,
                            @"scene": scene
                            };
    NSString *testUrl = @"http://172.23.105.209:12005/appQuestion/commit"; feedback; //@"http://172.23.102.73:12005/appQuestion/commit"//http://172.23.105.209:10095/appQuestion/commit
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POSTUpload:feedback parameters:paras uploadType:(UploadDownloadType_Images) dataArray:imageDatas success:^(id responseData) {
        [hud hideAnimated:true afterDelay:1];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];

        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            callback.success(dic[@"msg"]);
        } else {
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        [hud hideAnimated:true afterDelay:1];
        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
        callback.failure(code);
    }];

}

#pragma mark- 设置按钮在选择与非选择的情况下的样式
- (void)setButtonBackgroundColor:(UIButton *)button {
    button.backgroundColor = button.isSelected ? [UIColor colorWithHexString:@"AC0042"] : [UIColor colorWithHexString:@"#353535"];
}

#pragma mark- 提交成功的Hub
- (void)showSuccessHub {
    InputAlertView *inputalertView = [[InputAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [inputalertView initWithTitle:@"提交成功,谢谢您的反馈" img:@"feedback_success" type:9 btnNum:1 btntitleArr:[NSArray arrayWithObjects:@"关闭",nil] ];
    UIView *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview: inputalertView];
    
    inputalertView.clickBlock = ^(UIButton *btn, NSString *str) {
        [self.navigationController popViewControllerAnimated:YES];
    };
}

#pragma mark- UITextView的代理
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger count = textView.text.length;
    if (count <= kMaxInputCount) {
        self.inputCountLabel.text = [NSString stringWithFormat:@"%d/%d", count,kMaxInputCount];
    }else {
        self.inputCountLabel.text = @"200/200";
        textView.text = [textView.text substringWithRange:NSMakeRange(0, kMaxInputCount)];
        [MBProgressHUD showText:@"至多输入200个字符"];
    }
    
}

#pragma mark- 懒加载
- (UIView *)firstLine {
    if (!_firstLine) {
        _firstLine = [UIView new];
        _firstLine.backgroundColor = [UIColor colorWithHexString:@"#AC0042 "];
        _firstLine.layer.cornerRadius = 1.5;
        _firstLine.layer.masksToBounds = YES;
    }
    return _firstLine;
}

- (UILabel *)happenLabel {
    if (!_happenLabel) {
        _happenLabel = [UILabel new];
        _happenLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _happenLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _happenLabel.text = NSLocalizedString(@"请选择问题发生的场景", nil);
    }
    return _happenLabel;
}

- (UIView *)secondLine {
    if (!_secondLine) {
        _secondLine = [UIView new];
        _secondLine.backgroundColor = [UIColor colorWithHexString:@"#AC0042 "];
        _secondLine.layer.cornerRadius = 1.5;
        _secondLine.layer.masksToBounds = YES;
    }
    return _secondLine;
}

- (UILabel *)feedbackLabel {
    if (!_feedbackLabel) {
        _feedbackLabel = [UILabel new];
        _feedbackLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _feedbackLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _feedbackLabel.text = NSLocalizedString(@"意见和反馈", nil);
    }
    return _feedbackLabel;
}

- (UIButton *)activityQuestionButton {
    if (!_activityQuestionButton) {
        _activityQuestionButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_activityQuestionButton setTitle:NSLocalizedString(@"激活问题", nil) forState:UIControlStateNormal];
        [_activityQuestionButton setTitleColor: [UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_activityQuestionButton setTitleColor: [UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
        _activityQuestionButton.layer.cornerRadius = 4;
        _activityQuestionButton.layer.masksToBounds = YES;
        _activityQuestionButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _activityQuestionButton.backgroundColor = [UIColor colorWithHexString:@"#353535"];
        _activityQuestionButton.tag = kActivityQuestion;
        [_activityQuestionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _activityQuestionButton;
}

- (UIButton *)carQuestionButton {
    if (!_carQuestionButton) {
        _carQuestionButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_carQuestionButton setTitle:NSLocalizedString(@"车辆问题", nil) forState:UIControlStateNormal];
        [_carQuestionButton setTitleColor: [UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_carQuestionButton setTitleColor: [UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
        _carQuestionButton.layer.cornerRadius = 4;
        _carQuestionButton.layer.masksToBounds = YES;
        _carQuestionButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _carQuestionButton.backgroundColor = [UIColor colorWithHexString:@"#353535"];
        _carQuestionButton.tag = kCarQuestion;
        [_carQuestionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _carQuestionButton;
}


- (UIButton *)appQuestionButton {
    if (!_appQuestionButton) {
        _appQuestionButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_appQuestionButton setTitle:NSLocalizedString(@"App问题", nil) forState:UIControlStateNormal];
        [_appQuestionButton setTitleColor: [UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_appQuestionButton setTitleColor: [UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
        _appQuestionButton.layer.cornerRadius = 4;
        _appQuestionButton.layer.masksToBounds = YES;
        _appQuestionButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _appQuestionButton.backgroundColor = [UIColor colorWithHexString:@"#353535"];
        _appQuestionButton.tag = kAppQuestion;
        [_appQuestionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _appQuestionButton;
}

- (UIButton *)otherQuestionButton {
    if (!_otherQuestionButton) {
        _otherQuestionButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_otherQuestionButton setTitle:NSLocalizedString(@"其他问题", nil) forState:UIControlStateNormal];
        [_otherQuestionButton setTitleColor: [UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_otherQuestionButton setTitleColor: [UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
        _otherQuestionButton.layer.cornerRadius = 4;
        _otherQuestionButton.layer.masksToBounds = YES;
        _otherQuestionButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _otherQuestionButton.backgroundColor = [UIColor colorWithHexString:@"#353535"];
        _otherQuestionButton.tag = kOtherQuestion;
        [_otherQuestionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _otherQuestionButton;
}

- (NSMutableArray<UIButton *> *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (UIButton *)commintButton {
    if (!_commintButton) {
        _commintButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_commintButton setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
        [_commintButton setTitleColor: [UIColor whiteColor] forState:UIControlStateSelected];
        [_commintButton setTitleColor: [UIColor whiteColor] forState:UIControlStateHighlighted];
        _commintButton.backgroundColor = [UIColor colorWithHexString:@"#AC0042"];
        _commintButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_commintButton addTarget:self action:@selector(commitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _commintButton.layer.cornerRadius = 4;
        _commintButton.layer.masksToBounds = YES;
        
    }
    return _commintButton;
}

- (UIView *)feedbackArea {
    if (!_feedbackArea) {
        _feedbackArea = [UIView new];
        _feedbackArea.layer.cornerRadius = 4;
        _feedbackArea.layer.masksToBounds = YES;
        _feedbackArea.backgroundColor = [UIColor whiteColor];
    }
    return _feedbackArea;
}

- (PlaceholderTextView *)textView {
    if (!_textView) {
        _textView = [PlaceholderTextView new];
        _textView.placeHolderLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _textView.placeHolderLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _textView.delegate = self;
        _textView.textContainerInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.layer.cornerRadius = 4;
        _textView.layer.masksToBounds = YES;
    }
    return _textView;
}

- (UILabel *)inputCountLabel {
    if (!_inputCountLabel) {
        _inputCountLabel = [UILabel new];
        _inputCountLabel.text = [NSString stringWithFormat:@"0/%d", kMaxInputCount];
        _inputCountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _inputCountLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _inputCountLabel.backgroundColor = [UIColor whiteColor];
        _inputCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _inputCountLabel;
}

- (UIImageView *)feedbackWarnIcon {
    if (!_feedbackWarnIcon) {
        _feedbackWarnIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_attention"]];
    }
    
    return _feedbackWarnIcon;
}

- (UILabel *)feedbackWarnLabel {
    if (!_feedbackWarnLabel) {
        _feedbackWarnLabel = [UILabel new];
        _feedbackWarnLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _feedbackWarnLabel.textColor = [UIColor colorWithHexString:@"#AC0042"];
        _feedbackWarnLabel.text = NSLocalizedString(@"请填写不低于5个字的问题描述", nil);
    }
    return  _feedbackWarnLabel;
}

- (FeedbackPicView *)picView {
    if (!_picView) {
        _picView = [FeedbackPicView new];
        _picView.layer.cornerRadius = 4;
        _picView.layer.masksToBounds = YES;
    }
    return  _picView;
}

- (FeedbackChoosePicView *)choosePicView {
    if (!_choosePicView) {
        _choosePicView = [FeedbackChoosePicView new];
    }
    return _choosePicView;
}

@end
