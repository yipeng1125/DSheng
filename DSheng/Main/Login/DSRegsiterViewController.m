//
//  DSRegsiterViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/8.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSCommonTool.h"
#import "DSRegsiterViewController.h"
#import "TRCustomAlert.h"

#import "DSAPIInterface.h"


@interface DSRegsiterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *tpsdTextField;

@end

@implementation DSRegsiterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _inviteCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _phoneTextField.delegate = self;
    _passwordTextField.delegate = self;
    _inviteCodeTextField.delegate = self;
    _tpsdTextField.delegate = self;
    
    _passwordTextField.secureTextEntry = YES;
    _tpsdTextField.secureTextEntry = YES;
    
    self.navigationItem.title = @"注册";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_phoneTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_inviteCodeTextField resignFirstResponder];
    [_tpsdTextField resignFirstResponder];
    return NO;
}

- (IBAction)registerActoin:(id)sender {
    
    if (![DSCommonTool checkIsPhoneNumber:_phoneTextField.text] ) {
        [TRCustomAlert showMessage:@"请输入正确的手机号码" image:nil];
        return;
    }
    
    if ((_passwordTextField.text.length <= 6) || (_tpsdTextField.text.length <= 6)) {
        [TRCustomAlert showMessage:@"密码长度不能低于6位" image:nil];
        return;
    }
    
    [DSAPIInterface registerAPIReqeust:_phoneTextField.text passWord:_passwordTextField.text serviceCode:_inviteCodeTextField.text takePSD:_tpsdTextField.text success:^(id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert showMessage:@"register successfully" image:nil];
        });
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert showMessage:error.description image:nil];
        });
    }];
    
}
- (IBAction)policy:(id)sender {
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
