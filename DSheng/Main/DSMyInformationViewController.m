//
//  DSMyInformationViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/7.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSMyInformationViewController.h"

@interface DSMyInformationViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    NSArray *_menuTitleAry;
    NSArray *_menuIconAry;
}
@property (weak, nonatomic) IBOutlet UITableView *mytableView;

@end

@implementation DSMyInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initParameters];
}


- (void)initParameters {
    _menuTitleAry = @[@"充值记录", @"投注记录", @"提现记录", @"中奖记录", @"分享", @"代理中心", @"客服", @"更多"];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentyfyID = [NSString stringWithFormat:@"%0ld", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentyfyID];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentyfyID];
        cell.textLabel.text = _menuTitleAry[indexPath.row];
    }
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuTitleAry.count;
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
