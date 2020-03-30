//
//  DSIntroductionViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/30.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSIntroductionViewController.h"

@interface DSIntroductionViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSArray *titleAry;
    NSArray *contentAry;
    
    BOOL close[30];
}

@property (weak, nonatomic) IBOutlet UITableView *myTableview;

@end

@implementation DSIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = NO;

    [self initParameters];
}


- (void)initParameters {
    
    titleAry = @[@"1.充值问题", @"2.帐号冻结", @"3.投注记录和中奖记录", @"4.充值记录", @"5.提现记录", @"6.活动赠送金额", @"7.提现通知", @"8.投注冻结", @"9.彩种规范", @"10.忘记密码", @"11.忘记提现密码"];
    
    contentAry = @[@"充值出现未到账问题请资讯客服。线下充值，请先打款，再提交打款记录。不然怕出现后台审核打款记录时，用户银行打款记录还未到账。",\
                   @"发现帐号作弊行为，会进行帐号冻结。若被冻结，请咨询客服人员", \
                   @"投注记录和中奖记录会在“我的”界面记录选项中显示最新及过往记录", \
                   @"充值记录和中奖记录会在“我的”界面记录选项中显示最新及过往记录", \
                   @"提现记录和中奖记录会在“我的”界面记录选项中显示最新及过往记录", \
                   @"活动赠送金额只能用于购买彩票，若中奖，才可以提现", \
                   @"只有当用户的流水总额大于提现金额，才可以提现。用户提现需要等后台审核完成，才可以提现下一笔。", \
                   @"发现投注异常，异常资金投注行为，会进行投注冻结，若被冻结，请咨询客服人员。", \
                   @"每个彩种的玩法规则，在每个彩种的投注页面的右上角“规则说明”", \
                   @"已注册用户忘记密码，请在登录页面点击下方的找回密码", \
                   @"通过点击头像修改提现密码"];
    
    
    self.myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    

}



//数据源方法的实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return titleAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!close[section]) {
        return 0;
    }

    return 1;
}


//组头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSInteger index = indexPath.section;
    cell.textLabel.text = contentAry[index];
    CGRect rect = cell.textLabel.frame;
    rect.size.width = DSScreenSize.width - 30;
    rect.size.height = 70;
    cell.textLabel.frame = rect;
    cell.textLabel.numberOfLines = 5;
    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

//创建组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIControl *view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, DSScreenSize.width, 40)];
    view.tag = 1000 + section;
//    view.backgroundColor = [UIColor colorWithRed:0.849 green:0.195 blue:0.258 alpha:0.7];;
    [view addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, DSScreenSize.width, 30)];
//    label.textColor = [UIColor colorWithRed:1.000 green:0.985 blue:0.996 alpha:1.000];
    label.textColor = UIColor.blackColor;
    label.font = [UIFont systemFontOfSize:16];
    label.text = titleAry[section];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DSScreenSize.width, 1)];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DSScreenSize.width, 1)];
    line2.backgroundColor = UIColor.lightGrayColor;
    line.backgroundColor = UIColor.lightGrayColor;
    line.y = 40 -1;
    
    [view addSubview:label];
    [view addSubview:line2];

    if (section == titleAry.count - 1) {
        [view addSubview:line];

    }
    
    return view;
    
}

-(void)sectionClick:(UIControl *)view{
    
    //获取点击的组
    NSInteger i = view.tag - 1000;
    //取反
    close[i] = !close[i];
    //刷新列表
    NSIndexSet * index = [NSIndexSet indexSetWithIndex:i];
    [_myTableview reloadSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
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
