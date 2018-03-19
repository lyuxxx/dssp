//
//  PersonInViewController.m
//  dssp
//
//  Created by qinbo on 2017/12/21.
//  Copyright © 2017年 capsa. All rights reserved.
//

#import "PersonInViewController.h"
#import "PersonInCell.h"
#import <YYCategoriesSub/YYCategories.h>
#import "ModifyPhoneController.h"
#import <TBActionSheet/TBActionSheet.h>
#import <TZImagePickerController.h>
#import "NicknameViewController.h"
#import "AFNetworking.h"
#import "UserModel.h"
@interface PersonInViewController ()<UITableViewDelegate,UITableViewDataSource, TBActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *titles;
@property (nonatomic, strong) UIImageView *selectedImgV;
@property(nonatomic,strong) UserModel *userModel;
@end

@implementation PersonInViewController
- (BOOL)needGradientBg {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"个人信息", nil);
    
    self.titles = @[
                              NSLocalizedString(@"头像", nil),
                              NSLocalizedString(@"用户名", nil),
//                              NSLocalizedString(@"手机号", nil),
                              NSLocalizedString(@"昵称", nil)
          
                              
                              ];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Statistics staticsstayTimeDataWithType:@"1" WithController:@"PersonInViewController"];
    [self initTableView];
    [self requestData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [Statistics staticsvisitTimesDataWithViewControllerType:@"PersonInViewController"];
    [Statistics staticsstayTimeDataWithType:@"2" WithController:@"PersonInViewController"];
}

-(void)requestData
{
    NSDictionary *paras = @{
                            
                            
                            };
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [CUHTTPRequest POST:queryUser parameters:paras success:^(id responseData) {
        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
            [hud hideAnimated:YES];
            NSDictionary *dic1 = dic[@"data"];
            self.userModel = [UserModel yy_modelWithDictionary:dic1];
            
            [self.tableView reloadData];
            
        } else {
            [hud hideAnimated:YES];
            [MBProgressHUD showText:dic[@"msg"]];
        }
    } failure:^(NSInteger code) {
        [hud hideAnimated:YES];
        [MBProgressHUD showText:[NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"请求失败", nil),code]];
    }];
}


-(void)initTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    //    _tableView.tableFooterView = [UIView new];
    //    _tableView.tableHeaderView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    adjustsScrollViewInsets_NO(_tableView,self);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //不回弹
//    _tableView.bounces=NO;
    //滚动条隐藏
//    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
//          make.edges.equalTo(self.view);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 60*HeightCoefficient;
    }
    return 44*HeightCoefficient;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"PersonInCellName";
    PersonInCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[PersonInCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
     cell.lab.text = _titles[indexPath.row] ;

       if (indexPath.row==0) {

            [cell.img sd_setImageWithURL:[NSURL URLWithString:_userModel.headPortrait] placeholderImage:[UIImage imageNamed:@"用户头像"]];
            cell.arrowImg.image=[UIImage imageNamed:@"箭头_icon"];
           
        }
       if (indexPath.row==1) {
           cell.realName.text = _userModel.userName?_userModel.userName:@"xxxxxx";
        }
//        if (indexPath.row==2) {
//            NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
//            NSString *originTel = _userModel.userName?_userModel.userName:username;
//            NSString *tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//            cell.realName.text = tel;
//        }
        if (indexPath.row==2) {
            cell.whiteView.hidden=YES;
            NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
            cell.realName.text = _userModel.nickname?_userModel.nickname:name;
            cell.arrowImg.image=[UIImage imageNamed:@"箭头_icon"];
        }
  cell.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.row == 0) {
       dispatch_async(dispatch_get_main_queue(), ^{
         _selectedImgV = [[UIImageView alloc] init];
           TBActionSheet *sheet = [[TBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照", nil),NSLocalizedString(@"从图库选择", nil), nil];
           sheet.ambientColor = [UIColor whiteColor];
           sheet.cancelButtonColor = [UIColor colorWithHexString:GeneralColorString];
           sheet.tintColor = [UIColor colorWithHexString:GeneralColorString];
           [sheet show];
       });
    }
    if (indexPath.row == 1) {
        
    }
//    if (indexPath.row == 2) {
//        ModifyPhoneController *modifyPhone = [ModifyPhoneController new];
//        [self.navigationController pushViewController:modifyPhone animated:YES];
//    }
    if (indexPath.row == 2) {
        NicknameViewController *nicknameVC = [[NicknameViewController alloc] init];
        [self.navigationController pushViewController:nicknameVC animated:YES];
    }
    
}

- (void)actionSheet:(TBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    //    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
    //        if (!self.imagePickerVC) {
    //           self.imagePickerVC = [[UIImagePickerController alloc] init];
    //        }
    
    //        _imagePickerVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    //        _imagePickerVC.delegate = self;
    //        _imagePickerVC.allowsEditing = YES;
    
    if (buttonIndex == 0) {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        
        imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerVC.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        imagePickerVC.showsCameraControls = YES;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        
    } else if (buttonIndex == 1) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self];
            imagePickerVC.allowPickingOriginalPhoto = NO;
            imagePickerVC.allowPickingVideo = NO;
            imagePickerVC.allowPickingGif = NO;
            imagePickerVC.allowTakePicture = NO;
            imagePickerVC.allowCrop = YES;
            imagePickerVC.cropRect = CGRectMake(0, (kScreenHeight - kScreenWidth) / 2.0f, kScreenWidth, kScreenWidth);
            imagePickerVC.oKButtonTitleColorNormal = [UIColor whiteColor];
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        });
       
    }
}

//相册回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
//    _selectedImgV = [[UIImageView alloc] init];
    _selectedImgV.image = photos[0];
   
     [_selectedImgV removeAllSubviews];
     [self saveImage:photos[0] name:@"photo"];
     [_tableView reloadData];


    NSDictionary *paras = @{

                          };

    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(photos[0], 0.3)];
    NSArray<NSData *> *arr = [NSArray arrayWithObjects:imageData, nil];


    [CUHTTPRequest POSTUpload:updateHeadPortrait parameters:paras uploadType:(UploadDownloadType_Images) dataArray:arr success:^(id responseData) {

         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
         if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
              [self requestData];
             [MBProgressHUD showText:@"图片上传成功"];
         }
        else
        {
             [MBProgressHUD showText:[dic objectForKey:@"msg"]];
        }

    } failure:^(NSInteger code) {

        
    }];

//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    for (NSString *key in dic) {
//        NSString *value = dic[key];
//        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
//    }
////    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(photos[0], 0.3)];
//    //    NSArray<NSData *> *arr = [NSArray arrayWithObjects:imageData, nil];
//    [manager POST:updateHeadPortrait parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
//
//        //把image  转为data , POST上传只能传data
//
//        NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(photos[0], 0.3)];
//
//        //上传的参数(上传图片，以文件流的格式)
//
//        [formData appendPartWithFileData:data
//         name:@"file" fileName:@"gauge.png"
//         mimeType:@"image/png"];
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//
//
//        　　//请求成功的block回调
//
////        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//
//                                                                                                    NSLog(@"上传成功%@",responseObject);
//
//
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        NSLog(@"上传失败%@",error);
//
//    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    //    _imagePickerVC = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^()
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             UIImage* image = info[UIImagePickerControllerEditedImage];
             if (image) {
//                 _selectedImgV = [[UIImageView alloc] init];
                 _selectedImgV.image = image;
                 [_selectedImgV removeAllSubviews];
                  [self saveImage:image name:@"photo"];
                  [_tableView reloadData];;
                 
                 NSDictionary *paras = @{
                                         
                                         };
                 
                 NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.3)];
                 NSArray<NSData *> *arr = [NSArray arrayWithObjects:imageData, nil];
                 [CUHTTPRequest POSTUpload:updateHeadPortrait parameters:paras uploadType:(UploadDownloadType_Images) dataArray:arr success:^(id responseData) {
                     
                     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                     if ([[dic objectForKey:@"code"] isEqualToString:@"200"]) {
                         [self requestData];
//                         [MBProgressHUD showText:@"图片上传成功"];
                     }
                     else
                     {
                         [MBProgressHUD showText:[dic objectForKey:@"msg"]];
                     }
                     
                 } failure:^(NSInteger code) {
                     
                     
                 }];
                 
             } else {
                 _selectedImgV.image = info[UIImagePickerControllerOriginalImage];
                 [_selectedImgV removeAllSubviews];
                  [self saveImage:image name:@"photo"];
                  [_tableView reloadData];
             }
         });
     }];
  
}


- (void)saveImage:(UIImage *)image name:(NSString *)iconName
{
    
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,
                                        YES);
    //写入文件
    NSString *icomImage = iconName;
    NSString *filePath = [[paths
                           objectAtIndex:0]
                          stringByAppendingPathComponent:[NSString
                                                          stringWithFormat:@"%@.png", icomImage]];
    //
//    保存文件的名称
    
    // [[self getDataByImage:image] writeToFile:filePath atomically:YES];
    [UIImagePNGRepresentation(image)writeToFile: filePath
                                     atomically:YES];
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
