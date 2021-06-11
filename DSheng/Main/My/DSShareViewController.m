//
//  DSShareViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/21.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSShareViewController.h"
#import "DSCacheDataManager.h"
#import "TRCustomAlert.h"



@interface DSShareViewController ()
@property (weak, nonatomic) IBOutlet UIView *fuctionView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation DSShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
    
    self.navigationController.navigationBar.hidden = NO;
}



- (void)setupView {
    
    switch (_type) {
   
        case DS_PageType_Shared:
            _fuctionView.hidden = NO;
            _infoLabel.hidden = YES;
            [_imageView setImage:[UIImage imageNamed:@"1577427494"]];
            self.navigationItem.title = @"分享";
            break;
        case DS_PageType_Agent:
            if (![DSCacheDataManager shareManager].userInfo.isAgency) {
                [TRCustomAlert showMessage:@"您还不是代理，请联系客服" image:nil];
            }
            [_imageView setImage:[UIImage imageNamed:@"kefu"]];
            _fuctionView.hidden = YES;
            _infoLabel.hidden = NO;
            _infoLabel.text = @"申请代理，请用微信扫描以上二维码";
            self.navigationItem.title = @"德胜代理";

            break;
        case DS_PageType_Service:
            [_imageView setImage:[UIImage imageNamed:@"kefu"]];
            _fuctionView.hidden = YES;
            _infoLabel.hidden = NO;
            _infoLabel.text = @"请用微信扫描以上二维码获取更多服务";
            self.navigationItem.title = @"德胜微信客服";

            break;
            
        case DS_PageType_Take:
            [_imageView setImage:[UIImage imageNamed:@"kefu"]];
            _fuctionView.hidden = YES;
            _infoLabel.hidden = NO;
            _infoLabel.text = @"如需提现，请用微信扫描以上二维码";
            self.navigationItem.title = @"德胜微信客服";
            
            break;
            
            
        default:
            break;
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

@end
