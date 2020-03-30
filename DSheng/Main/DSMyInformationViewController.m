//
//  DSMyInformationViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/7.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSMyInformationViewController.h"
#import "DSCommonHeader.h"
#import "DSCacheDataManager.h"
#import "DSShareViewController.h"



@interface DSMyInformationViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    NSArray *_menuTitleAry;
    NSArray *_menuIconAry;
    
    double tableViewHeight;
}
@property (weak, nonatomic) IBOutlet UITableView *mytableView;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *takeBtn;

@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTableViewConstraintHeight;

@property (weak, nonatomic) IBOutlet UILabel *avaibleMoney;

@property (weak, nonatomic) IBOutlet UILabel *alreadyTakeMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *winMoneyLabel;

@end

@implementation DSMyInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTableBarItem];
    [self initParameters];
    [self setUpView];
}


- (void)setupTableBarItem {
    
    self.tabBarItem.image = [UIImage imageNamed:@"tabbar_profile"];
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_profile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = UIColor.lightGrayColor;
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = DS_MainColor;
    [self.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [self.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
}


- (void)setUpView {
    _mainImageV.layer.cornerRadius = _mainImageV.height * 0.5;
    [_payBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_takeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    
    [_payBtn setImage:[UIImage imageNamed:@"chongzhi-1"] forState:UIControlStateNormal];
    [_payBtn setImage:[UIImage imageNamed:@"chongzhi-1"] forState:UIControlStateHighlighted];

    [_takeBtn setImage:[UIImage imageNamed:@"tixian-1"] forState:UIControlStateNormal];
    [_takeBtn setImage:[UIImage imageNamed:@"tixian-1"] forState:UIControlStateHighlighted];

    _payBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _payBtn.imageView.height = 32;
    _payBtn.imageView.width = 32;

    [_payBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_payBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    
    _mytableView.bounces = NO;
    
    
    
    _idLabel.text = [DSCacheDataManager shareManager].userInfo.userID;
    NSString *phoneNumber = [[DSCommonTool getUserInfo] objectForKey:DS_USER_KEY];
    NSRange range;
    range.location = 3;
    range.length = 5;
    _phoneLabel.text = [phoneNumber stringByReplacingCharactersInRange:range withString:@"*****"];
    
    _avaibleMoney.text = [DSCacheDataManager shareManager].userInfo.balanceMoney;

}

- (void)initParameters {
    _menuTitleAry = @[@"充值记录", @"投注记录", @"提现记录", @"中奖记录", @"分享", @"代理中心", @"客服", @"更多"];
    _menuIconAry = @[@"chongzhijilu-2", @"chongzhi-2", @"tixian-3", @"zhongjiangjilu-2", @"fenxiang-2", @"dailishang-2", @"kefu-my", @"gengduo"];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentyfyID = [NSString stringWithFormat:@"%0ld-%0ld", indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentyfyID];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentyfyID];
        cell.textLabel.text = _menuTitleAry[indexPath.row];
        [cell.imageView setImage:[UIImage imageNamed:_menuIconAry[indexPath.row]]];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.imageView.width = 16;
        cell.imageView.height = 16;
        tableViewHeight = cell.height * _menuTitleAry.count + 5;
        
        _myTableViewConstraintHeight.constant = tableViewHeight;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    


    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuTitleAry.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == 1) {
        
    } else if (indexPath.row == 2) {
        
    } else if (indexPath.row == 3) {
        
    } else if (indexPath.row == 4) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
        DSShareViewController *myView = [story instantiateViewControllerWithIdentifier:@"DSShareViewController"];
        myView.type = DS_PageType_Shared;
        
        [self.navigationController pushViewController:myView animated:YES];
    } else if (indexPath.row == 5) {
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
        DSShareViewController *myView = [story instantiateViewControllerWithIdentifier:@"DSShareViewController"];
        myView.type = DS_PageType_Agent;
        
        [self.navigationController pushViewController:myView animated:YES];
    } else if (indexPath.row == 6) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
        DSShareViewController *myView = [story instantiateViewControllerWithIdentifier:@"DSShareViewController"];
        myView.type = DS_PageType_Service;
        
        [self.navigationController pushViewController:myView animated:YES];
    } else if (indexPath.row == 7) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
        UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"DSSettingViewController"];
        [self.navigationController pushViewController:myView animated:YES];

    } else {
        
    }
    
}




- (IBAction)payAction:(id)sender {
    
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
    UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"DSRechargeViewController"];
    [self.navigationController pushViewController:myView animated:YES];
    
}

- (IBAction)takeAction:(id)sender {
    
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
