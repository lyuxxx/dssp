//
//  SubscribedatailController.m
//  dssp
//
//  Created by qinbo on 2018/1/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "SubscribedatailController.h"
#import "SubscribeModel.h"
#import <WebKit/WebKit.h>
@interface SubscribedatailController ()<UIWebViewDelegate,WKNavigationDelegate, WKUIDelegate>

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) SubscribedatailModel *subscribedatail;
@property (nonatomic,strong) UITextView *contentlabel;
@property (nonatomic,assign) NSInteger webfont;
//@property (nonatomic,strong) UIWebView *webView;
@end

@implementation SubscribedatailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
      self.webfont = 3;/// 1：小号字体，2：中号字体，3：大号字体
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
    
     self.navigationItem.title = NSLocalizedString(_channels.title, nil);
//    将str转换成标准的html数据
//    NSString  * str = [self htmlEntityDecode:_subscribedatail.content];
    NSLog(@"666%@",_subscribedatail.content);
    NSString *string = [_subscribedatail.content stringByReplacingOccurrencesOfString:@"tp=webp" withString:@""];
//    NSString *newString = [string stringByReplacingOccurrencesOfString:@"<p" withString:[NSString stringWithFormat:@"<p style='font-size:28px;'"]];
    

    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>"
                            "<script type='text/javascript'>"
                            "window.onload = function(){\n"
                            "var $img = document.getElementsByTagName('img');\n"
                            "for(var p in  $img){\n"
                            "$img[p].style.width = '100%%';\n"
                            "$img[p].style.height ='auto'\n"
                            "}\n"
                            "}"
                            "</script>%@"
                            "</body>"
                            "</html>",string];
    
        self.webView = [[WKWebView alloc] init];
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    
     self.webView.allowsBackForwardNavigationGestures = YES;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [self.webView loadHTMLString:htmlString baseURL:nil];


   
//    self.contentlabel =[[UITextView alloc] init];
//    _contentlabel.editable = NO;
//    NSString *htmlString = [_subscribedatail.content stringByReplacingOccurrencesOfString:@"tp=webp" withString:@""];
//    NSString *newString = [htmlString stringByReplacingOccurrencesOfString:@"<img" withString:[NSString stringWithFormat:@"<img width=\"%f\"",kScreenWidth - 10]];
//
//    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[newString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    _contentlabel.attributedText = attributedString;
//    NSLog(@"666%@",attributedString);
//    [self.view addSubview:_contentlabel];
//    [_contentlabel makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(0 * WidthCoefficient);
//        make.bottom.equalTo(0 * HeightCoefficient);
//        make.left.equalTo(0 * WidthCoefficient);
//        make.top.equalTo(0 * HeightCoefficient);
//    }];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    /// 网页加载完成后，，设置字体大小
    
    if (self.webfont == 1) {
        
        [self.webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'" completionHandler:nil];
        
    }else if (self.webfont == 2){
        
        [self.webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'" completionHandler:nil];
        
    }else{
        
        [self.webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '190%'" completionHandler:nil];
        
    }
    
}

- (NSString *)filterHtmlString:(NSString *)htmlString{
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:htmlString];
    [theScanner scanUpToString:@"<div id=\"fex-account\">" intoString:NULL];
    [theScanner scanUpToString:@"</form>" intoString:&text];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:text withString:@""];
    return htmlString;
}

-(NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
        
    }
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
