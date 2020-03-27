//
//  DSLoginViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/8.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSLoginViewController.h"
#import "TRCustomAlert.h"
#import "DSCommonTool.h"

#import "DSCommonHeader.h"

#import "DSAPIInterface.h"


@interface DSLoginViewController ()<UITextFieldDelegate> {
    
    NSString *_currentPhone;
    NSString *_currentPassword;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextField *passworldTextField;
@end

@implementation DSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"登录";
    
    _phoneTextField.attributedPlaceholder= [[NSAttributedString  alloc]initWithString:@"请输入手机号码"attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _passworldTextField.attributedPlaceholder= [[NSAttributedString  alloc]initWithString:@"请输入密码"attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    _passworldTextField.secureTextEntry = YES;
    
    _passworldTextField.delegate = self;
    _phoneTextField.delegate = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    [_contentView addGestureRecognizer:tapGesture];
    
    
    [self tryAutoLogin];
    
    
}


- (void)tryAutoLogin {
    
    NSDictionary *userinfo = [DSCommonTool getUserInfo];
    
    if (userinfo) {
        [self startLogin:userinfo[DS_USER_KEY] password:userinfo[DS_USER_PSD_KEY]];
    }
}



- (IBAction)regsiterAction:(id)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"DSRegsiterViewController"];
    [self.navigationController pushViewController:myView animated:YES];

}

- (IBAction)forgetPasswordActoin:(id)sender {
}
- (IBAction)loginAction:(id)sender {
    if (![DSCommonTool checkIsPhoneNumber:_phoneTextField.text]) {
        [TRCustomAlert showMessage:@"请输入正确的手机号码" image:nil];
        return;
    }
    
    if (_passworldTextField.text.length <= 6) {
        [TRCustomAlert showMessage:@"密码长度不能低于6位" image:nil];
        return;
    }
    
    [self startLogin:_phoneTextField.text password:_passworldTextField.text];
    
}


- (void)startLogin:(NSString *)phone password:(NSString *)psd{
    
    _currentPhone = phone;
    _currentPassword = psd;
    
    [TRCustomAlert showShadeLoadingWithMessage:@"正在登陆..."];
    
    [DSAPIInterface loginAPIReqeust:phone passWord:psd success:^(id result) {
        
        NSDictionary *userinfo = @{DS_USER_KEY : self->_currentPhone, DS_USER_PSD_KEY : self ->_currentPassword};
        [DSCommonTool saveUserInfo:userinfo];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert dissmis];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"DSTabBarController"];
            [self.navigationController pushViewController:myView animated:YES];
        });
        
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert dissmis];
            [TRCustomAlert showMessage:error.description image:nil];
        });
    }];
}




-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_phoneTextField resignFirstResponder];
    [_passworldTextField resignFirstResponder];
    return NO;
}




- (void)viewClicked:(id)sender {
    [_phoneTextField resignFirstResponder];
    [_passworldTextField resignFirstResponder];
    NSLog(@"%@", sender);
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
