//
//  DSRechargeViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/23.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSRechargeViewController.h"
#import "DSScanPayViewController.h"

@interface DSRechargeViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    NSArray *titleAry;
    NSArray *imgAry;
    NSArray *sessionTitleAry;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation DSRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"充值";
    [self initParameters];
}


- (void)initParameters {
    
    titleAry = @[@"支付宝", @"QQ钱包-快捷支付", @"微信扫码支付", @"支付宝扫码支付"];
    imgAry = @[@"zhifubao", @"QQ", @"erweima", @"erweima"];
    
    sessionTitleAry = @[@"线上支付", @"线下支付"];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sessionTitleAry.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DSScreenSize.width, 44)];
    [view setBackgroundColor:UIColor.whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.centerX = DSScreenSize.width / 2;
    label.centerY = 22;
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = sessionTitleAry[section];
    
    [view addSubview:label];
    
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identify = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
    NSLog(@"%@", identify);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    NSInteger index = indexPath.section * 2 + indexPath.row;
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = titleAry[index];
        [cell.imageView setImage:[UIImage imageNamed:imgAry[index]]];
        UIView *linev = [UIView new];
        linev.frame = cell.bounds;
        linev.height = 1;
        linev.width = DSScreenSize.width;
        linev.y = cell.height - 1;
        [linev setBackgroundColor:UIColor.lightGrayColor];
        linev.alpha = 0.6;
        [cell addSubview:linev];
        
        if (indexPath.row == 0) {
            UIView *linev = [UIView new];
            linev.frame = cell.bounds;
            linev.height = 1;
            linev.width = DSScreenSize.width;
            linev.y = 0;
            [linev setBackgroundColor:UIColor.lightGrayColor];
            linev.alpha = 0.6;
            [cell addSubview:linev];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]];
        DSScanPayViewController *myView = [story instantiateViewControllerWithIdentifier:@"DSScanPayViewController"];
        if (indexPath.row == 0) {
            myView.type = 1;
            [self.navigationController pushViewController:myView animated:YES];
        } else {
            myView.type = 2;
            [self.navigationController pushViewController:myView animated:YES];
        }
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
