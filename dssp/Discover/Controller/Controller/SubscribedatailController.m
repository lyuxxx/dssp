//
//  SubscribedatailController.m
//  dssp
//
//  Created by qinbo on 2018/1/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "SubscribedatailController.h"
#import "SubscribeModel.h"
@interface SubscribedatailController ()<UIWebViewDelegate>
@property (nonatomic,strong) SubscribedatailModel *subscribedatail;
@property (nonatomic,strong) UITextView *contentlabel;
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation SubscribedatailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
  
}


-(void)requestData
{
    NSDictionary *paras = @{
                            @"id":_channels.listId,
                            @"vin":kVin
                            };
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:findAppPushContentInfoById parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
          
           _subscribedatail = [SubscribedatailModel yy_modelWithDictionary:dic[@"data"]];
           
            [self setupUI];
            //响应事件
            
        } else {
            [hud hideAnimated:YES];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        hud.label.text = NSLocalizedString(@"网络异常", nil);
        [hud hideAnimated:YES afterDelay:1];
    }];
    
}

-(void)setupUI
{
    //        _webView = [[UIWebView alloc] init]; // 初始化浏览器控件UIWebView
    //        _webView.delegate=self;
    //        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    //
    //       _webView.scalesPageToFit = YES;
    //
    //        [self.view addSubview:self.webView];
    ////         [self.webView loadHTMLString:htmlString baseURL:url];
    //        [_webView makeConstraints:^(MASConstraintMaker *make) {
    ////                    make.right.equalTo(0 * WidthCoefficient);
    //                    make.bottom.equalTo(0 * HeightCoefficient);
    ////                    make.left.equalTo(0 * WidthCoefficient);
    //                    make.width.equalTo(375 * WidthCoefficient);
    //                    make.top.equalTo(0 * HeightCoefficient);;
    //                }];
    
    self.navigationItem.title = NSLocalizedString(_channels.title, nil);
    self.contentlabel =[[UITextView alloc] init];
    _contentlabel.editable = NO;
    NSString *htmlString= _subscribedatail.content;
    
    NSString *newString = [htmlString stringByReplacingOccurrencesOfString:@"<img" withString:[NSString stringWithFormat:@"<img width=\"%f\"",kScreenWidth - 10]];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[newString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _contentlabel.attributedText = attributedString;
    NSLog(@"666%@",attributedString);
    [self.view addSubview:_contentlabel];
    [_contentlabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0 * WidthCoefficient);
        make.bottom.equalTo(0 * HeightCoefficient);
        make.left.equalTo(0 * WidthCoefficient);
        make.top.equalTo(0 * HeightCoefficient);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
