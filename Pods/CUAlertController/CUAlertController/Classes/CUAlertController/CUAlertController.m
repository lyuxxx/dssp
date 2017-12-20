//
//  CUAlertController.m
//  CUAlertController
//
//  Created by yxliu on 2017/12/14.
//

#import "CUAlertController.h"
#import "CUAlertView.h"

@interface CUAlertController () <UIViewControllerTransitioningDelegate, CUAlertViewDelegate>

@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSAttributedString *attributedMessage;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) CUAlertView *alertView;
@property (nonatomic, strong) NSMutableArray *buttonItems;

@end

@interface CUDismissAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@end

@implementation CUDismissAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.2;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    CUAlertController *alertController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        alertController.coverView.alpha = 0;
        alertController.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [alertController.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        alertController.alertView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        alertController.alertView.transform = CGAffineTransformIdentity;
    }];
}

@end

@interface CUPresentAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@end

@implementation CUPresentAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    CUAlertController *alertController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:alertController.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    alertController.coverView.alpha = 0;
    alertController.alertView.alpha = 1;
    alertController.alertView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        alertController.coverView.alpha = 0.3;
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        alertController.alertView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end

@implementation CUAlertController

+ (instancetype)alertWithImage:(UIImage *)image attributedMessage:(NSAttributedString *)attributedMessage {
    return [[self alloc] initWithImage:image attributedMessage:attributedMessage];
}

+ (instancetype)alertWithImage:(UIImage *)image message:(NSString *)message {
    return [[self alloc] initWithImage:image message:message];
}

- (instancetype)initWithImage:(UIImage *)image message:(NSString *)message {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        self.image = image;
        self.message = message;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image attributedMessage:(NSAttributedString *)attributedMessage {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        self.image = image;
        self.attributedMessage = attributedMessage;
    }
    return self;
}

- (void)addButtonWithTitle:(NSString *)title type:(CUButtonType)type clicked:(void (^)(void))clicked {
    if (self.buttonItems.count >= 2) {
        [NSException raise:@"You can add 2 buttons at most" format:@"%@: already has %zi buttons", self, self.buttonItems.count];
    }
    CUAlertButtonItem *item = [CUAlertButtonItem new];
    item.title = title;
    item.type = type;
    item.clicked = clicked;
    [self.buttonItems addObject:item];
}

- (NSMutableArray *)buttonItems {
    if (!_buttonItems) {
        _buttonItems = [NSMutableArray arrayWithCapacity:2];
    }
    return _buttonItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupCoverView];
    [self setupAlertView];
}

- (void)setupCoverView {
    self.coverView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.coverView.userInteractionEnabled = YES;
    self.coverView.backgroundColor = [UIColor colorWithRed:5/255.0 green:0 blue:10/255.0 alpha:1.0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.coverView addGestureRecognizer:tap];
    [self.view addSubview:self.coverView];
}

- (void)setupAlertView {
    self.alertView = [CUAlertView new];
    self.alertView.image = self.image;
    self.alertView.attributedMessage = self.attributedMessage;
    self.alertView.message = self.message;
    self.alertView.buttonItems = self.buttonItems;
    self.alertView.delegate = self;
    [self.view addSubview:self.alertView];
}

- (void)didTap:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [CUPresentAnimation new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [CUDismissAnimation new];
}

- (void)alertButtonClicked:(void (^)(void))clicked {
    [self dismissViewControllerAnimated:YES completion:^{
        if (clicked) {
            clicked();
        }
    }];
}

@end
