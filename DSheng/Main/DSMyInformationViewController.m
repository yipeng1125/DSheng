//
//  DSMyInformationViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/7.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSMyInformationViewController.h"
#import "DSCommonHeader.h"


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
@end

@implementation DSMyInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initParameters];
    [self setUpView];
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

}

- (void)initParameters {
    _menuTitleAry = @[@"充值记录", @"投注记录", @"提现记录", @"中奖记录", @"分享", @"代理中心", @"客服", @"更多"];
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
        
        tableViewHeight = cell.height * _menuTitleAry.count + 5;
        
        _myTableViewConstraintHeight.constant = tableViewHeight;
    }
    


    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuTitleAry.count;
}


- (IBAction)payAction:(id)sender {
    
    [_mytableView reloadData];
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
