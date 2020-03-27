//
//  DSModifyPSDViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/24.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSModifyPSDViewController.h"

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
    
    
}

@end
