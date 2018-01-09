//
//  SubscribedatailController.m
//  dssp
//
//  Created by qinbo on 2018/1/8.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "SubscribedatailController.h"
#import "SubscribeModel.h"
@interface SubscribedatailController ()

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
     self.navigationItem.title = NSLocalizedString(_channels.title, nil);
}

-(void)requestData
{
    NSDictionary *paras = @{
                            @"id":_channels.listId,
                            @"vin":@"VF7CAPSA000000101" 
                            };
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:findAppPushContentInfoById parameters:paras success:^(id responseData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            
          SubscribedatailModel *subscribedatail = [SubscribedatailModel yy_modelWithDictionary:dic[@"data"]];
            
           // contract = [ContractModel yy_modelWithDictionary:dic[@"data"]];
            //            [_tableView reloadData];
            
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
