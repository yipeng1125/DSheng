//
//  DSSettingViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/24.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSSettingViewController.h"
#import "DSModifyPSDViewController.h"
#import "DSDetailAboutViewController.h"

@interface DSSettingViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSArray *titleAry;
}

@end

@implementation DSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"设置";

    _myTableView.scrollEnabled = NO;
    
    [self initParameters];
}


- (void)initParameters {
    
    titleAry = @[@"修改密码", @"修改提现密码", @"服务协议", @"隐私策略", @"关于我们"];
    
}

- (IBAction)logoutAction:(id)sender {
    
    [DSCommonTool removeUserInfo];
    
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *myVc = [story instantiateViewControllerWithIdentifier:@"DSLoginViewController"];
    [self.navigationController pushViewController:myVc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return titleAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identyid = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identyid];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, DSScreenSize.width, 44)];
        cell.textLabel.text = titleAry[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _tableviewConstraintHeight.constant = 44 * titleAry.count;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
        DSModifyPSDViewController *myView = [story instantiateViewControllerWithIdentifier:@"DSModifyPSDViewController"];
        myView.type = 1;
        [self.navigationController pushViewController:myView animated:YES];
        return;
    }
    
    if (indexPath.row == 1) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
        DSModifyPSDViewController *myView = [story instantiateViewControllerWithIdentifier:@"DSModifyPSDViewController"];
        myView.type = 2;
        [self.navigationController pushViewController:myView animated:YES];
        return;
    }
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DSDetailAboutViewController *myViewC = [story instantiateViewControllerWithIdentifier:@"DSDetailAboutViewController"];
    
    if (indexPath.row == 2) {
        
        myViewC.type = 1;
        [self.navigationController pushViewController:myViewC animated:YES];
        return;
    }
    
    if (indexPath.row == 3) {
        myViewC.type = 2;
        [self.navigationController pushViewController:myViewC animated:YES];
        return;
    }
    
    if (indexPath.row == 4) {
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
        UIViewController *aboutvc = [story instantiateViewControllerWithIdentifier:@"DSAboutViewController"];
        [self.navigationController pushViewController:aboutvc animated:YES];
        return;
    }

}

@end
