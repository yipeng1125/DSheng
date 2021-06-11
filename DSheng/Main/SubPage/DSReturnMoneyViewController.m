//
//  DSReturnMoneyViewController.m
//  DSheng
//
//  Created by works_yip on 2020/4/14.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSReturnMoneyViewController.h"
#import "DSAPIInterface.h"
#import "TRCustomAlert.h"





@interface DSReturnMoneyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@end

@implementation DSReturnMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    _myButton.enabled = NO;

    self.navigationItem.title = @"投注返现";
    [self setupTextView];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getData];
    });
}
- (IBAction)clickaction:(id)sender {
    
    NSLog(@"click");
    __weak typeof(self) weakSelf = self;

    [DSAPIInterface commitReturnMoneyRequest:^(id result) {
        NSLog(@"%@", result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert showMessage:@"返现申请成功" image:nil];
            weakSelf.myButton.enabled = NO;
            [weakSelf.myButton setTitle:@"不能领取" forState:UIControlStateNormal];
            
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert showMessage:error.domain image:nil];
        });
    }];
    
    
    
}



- (void)getData {
    
    [DSAPIInterface getReturnMoneyInfoRequest:^(id result) {
        
        NSLog(@"res : %@", result);
        
        [self parseMessage:result];
        
    } failed:^(NSError *error) {
        NSLog(@"%@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert showMessage:@"服务器异常，请稍后再试" image:nil];
        });
    }];
}

- (void)parseMessage:(NSString *)msg {
    if (!msg || [msg isEqualToString:@""]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
//返回值：error：帐号信息错误。error1：今天已提现。error2，昨日没有投注不能提现。否则返回：可返现金额+分号+返现率
        
        if ([msg isEqualToString:@"error2"]) {
            [TRCustomAlert showMessage:@"昨日没有投注不能提现" image:nil];
        } else if ([msg isEqualToString:@"error1"]) {
            [TRCustomAlert showMessage:@"今天已提现" image:nil];
        } else {
            NSArray *contents = [msg componentsSeparatedByString:@","];
            NSString *total = contents.firstObject;
            NSString *str = contents.lastObject;
            
            weakSelf.label1.text = [NSString stringWithFormat:@"昨日投注%@元", total];
            weakSelf.label2.text = [NSString stringWithFormat:@"返现比例%@%%", str];

            weakSelf.label3.text = [NSString stringWithFormat:@"返现金额%.2f元", total.doubleValue * str.doubleValue * 0.01];
            
            [weakSelf.myButton setTitle:@"申请提现" forState:UIControlStateNormal];
            weakSelf.myButton.enabled = YES;

        }
    });
    
}

- (void)setupTextView {
//    NSString *str = @"提示：当日投注可在次日领取一定比例返现（若次日不能领取，当日的投注返现将自动失效，请注意领取），返现领取后，会直接充值到自己的余额，当日投注返现只能领取一次！";
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:@"提示：当日投注可在次日领取一定比例返现（" attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"若次日不能领取，当日的投注返现将自动失效，请注意领取" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"），返现领取后，会直接充值到自己的余额，当日投注返现只能领取一次！" attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    [mutableString appendAttributedString:str];
    [mutableString appendAttributedString:str2];
    
    _myTextView.attributedText = mutableString;
    
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
