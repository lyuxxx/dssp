//
//  PopupView.h
//  dssp
//
//  Created by qinbo on 2018/3/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InputAlertviewDelegate<NSObject>
@optional
- (void)successPassword;
@end

typedef void(^btntagClickBlock)(UIButton *btn,NSString *str);

@interface PopupView : UIView
@property (nonatomic,strong) UIView *blackView;
@property (strong,nonatomic) UIView * alertview;
@property (nonatomic, copy)  NSAttributedString * title;
@property (nonatomic, copy)  NSString * titleStr;
@property (nonatomic,copy)   NSString *imgStr;
@property (nonatomic,strong) UILabel *tipLable;
@property (weak,nonatomic)   id<InputAlertviewDelegate> delegate;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger numBtn;
@property (nonatomic,copy)   NSString *password;
@property (nonatomic,retain) NSArray *btnTitleArr;
@property (nonatomic,retain) UITextField *textF;
@property (nonatomic,retain) UITextField *pinField;
-(void)initWithTitle:(NSString *) title img:(NSString *)img type:(NSInteger)type btnNum:(NSInteger)btnNum btntitleArr:(NSArray *)btnTitleArr;

-(void)initWithTitles:(NSAttributedString *) titles img:(NSString *)img type:(NSInteger)type btnNum:(NSInteger)btnNum btntitleArr:(NSArray *)btnTitleArr;
@property (nonatomic, copy) btntagClickBlock clickBlock;
@end
