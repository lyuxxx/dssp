//
//  CUAlertView.h
//  CUAlertController
//
//  Created by yxliu on 2017/12/14.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CUButtonType) {
    CUButtonTypeNormal = 0,
    CUButtonTypeCancel,
    CUButtonTypeWarning
};

@protocol CUAlertViewDelegate <NSObject>

- (void)alertButtonClicked:(void(^)(void))clicked;

@end

@interface CUAlertButtonItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^clicked)(void);
@property (nonatomic, assign) CUButtonType type;

@end

@interface CUAlertView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSAttributedString *attributedMessage;
@property (nonatomic, strong) NSArray<CUAlertButtonItem *> *buttonItems;
@property (nonatomic, weak) id<CUAlertViewDelegate> delegate;

@end
