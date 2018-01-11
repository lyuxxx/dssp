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
    [self setupUI];
}

-(void)setupUI
{
    
    
        _webView = [[UIWebView alloc] init]; // 初始化浏览器控件UIWebView
        _webView.delegate=self;
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"application" ofType:@"html"];
//        NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//        NSString *htmlString= _subscribedatail.content;
//        NSURL *url = [[NSURL alloc] initWithString:filePath];
//        [self.webView loadHTMLString:htmlString baseURL:url];
    
    
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", _webView.frame.size.width];
//    [_webView stringByEvaluatingJavaScriptFromString:meta];
    
       _webView.scalesPageToFit = YES;

        [self.view addSubview:self.webView];
//         [self.webView loadHTMLString:htmlString baseURL:url];
        [_webView makeConstraints:^(MASConstraintMaker *make) {
//                    make.right.equalTo(0 * WidthCoefficient);
                    make.bottom.equalTo(0 * HeightCoefficient);
//                    make.left.equalTo(0 * WidthCoefficient);
                    make.width.equalTo(375 * WidthCoefficient);
                    make.top.equalTo(0 * HeightCoefficient);;
                }];
    
    self.navigationItem.title = NSLocalizedString(_channels.title, nil);
//    self.contentlabel =[[UITextView alloc] init];
//    _contentlabel.editable = NO;
//    [self.view addSubview:_contentlabel];
//    [_contentlabel makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(-10 * WidthCoefficient);
//        make.bottom.equalTo(0 * HeightCoefficient);
//        make.left.equalTo(10 * WidthCoefficient);
//        make.top.equalTo(0 * HeightCoefficient);;
//    }];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    NSString *script = [NSString stringWithFormat:
                        @"var script = document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.text = \"function ResizeImages() { "
                        "var img;"
                        "var maxwidth=%f;"
                        "for(i=0;i <document.images.length;i++){"
                        "img = document.images[i];"
                        "if(img.width > maxwidth){"
                        "img.width = maxwidth;"
                        "}"
                        "}"
                        "}\";"
                        "document.getElementsByTagName('head')[0].appendChild(script);", _webView.frame.size.width-40];
    
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", _webView.frame.size.width];
    
    NSLog(@"666%f",_webView.frame.size.width);
    [webView stringByEvaluatingJavaScriptFromString: script];
//    [_webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
//    [_webView stringByEvaluatingJavaScriptFromString:script];
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
            
            NSString *htmlString= _subscribedatail.content;
            [self.webView loadHTMLString:htmlString baseURL:nil];
            
            
           // contract = [ContractModel yy_modelWithDictionary:dic[@"data"]];
            //            [_tableView reloadData];
//            NSString *htmlString = _subscribedatail.content;
//
//             NSLog(@"55%@",htmlString);
//            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//            _contentlabel.attributedText = attributedString;
//            NSLog(@"666%@",attributedString);
            //响应事件
            
        } else {
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        hud.label.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code];
        [hud hideAnimated:YES afterDelay:1];
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
