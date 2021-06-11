//
//  DSModifyPSDViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/24.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSModifyPSDViewController.h"
#import "TRCustomAlert.h"
#import "DSAPIInterface.h"



@interface DSModifyPSDViewController ()

@property (weak, nonatomic) IBOutlet UILabel *oldLabel;
@property (weak, nonatomic) IBOutlet UILabel *myNewLabel;

@property (weak, nonatomic) IBOutlet UITextField *oldTextfield;
@property (weak, nonatomic) IBOutlet UITextField *mynewTextfield;

@end

@implementation DSModifyPSDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.navigationController.navigationBar.hidden = NO;

    [self setupviews];
}


- (void)setupviews {
    
    if (_type == 1) {
        
        self.navigationItem.title = @"修改登陆密码";

        _oldLabel.text = @"旧密码";
        _myNewLabel.text = @"新密码";
    } else {
        self.navigationItem.title = @"修改提现密码";

        _oldLabel.text = @"原提现密码";
        _myNewLabel.text = @"新提现密码";
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)modifyAction:(id)sender {
    
    if (_oldTextfield.text.length <= 0 || _mynewTextfield.text.length <= 0) {
        [TRCustomAlert showMessage:@"密码不能为空" image:nil];
        return;
    }
    
    
    
    NSString *phoneNumber = [[DSCommonTool getUserInfo] objectForKey:DS_USER_KEY];
    NSString *npsd = _mynewTextfield.text;
    if (_type == 1) {
        [DSAPIInterface sendModifyPasswordReqeust:phoneNumber oldPassword:_oldTextfield.text andNew:npsd success:^(id result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [TRCustomAlert showMessage:@"修改成功" image:nil];
                NSDictionary *userinfo = @{DS_USER_KEY : phoneNumber, DS_USER_PSD_KEY : npsd};

                [DSCommonTool saveUserInfo:userinfo];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.navigationController popViewControllerAnimated:YES];
                });
               
            });
            
        } failed:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [TRCustomAlert showMessage:error.description image:nil];
            });
        }];
    } else {
        NSString *psd = [[DSCommonTool getUserInfo] objectForKey:DS_USER_PSD_KEY];
        [DSAPIInterface sendModifyTakePasswordReqeust:phoneNumber psd:psd oldPassword:_oldTextfield.text andNew:_mynewTextfield.text success:^(id result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [TRCustomAlert showMessage:@"修改成功" image:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
            
        } failed:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [TRCustomAlert showMessage:error.description image:nil];
            });
        }];
    }

    
    
}

@end
