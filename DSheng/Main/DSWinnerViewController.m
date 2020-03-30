//
//  DSWinnerViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/7.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSWinnerViewController.h"
#import "DSKaiJianglTableViewCell.h"
#import "DSAPIInterface.h"
#import "DSCommonHeader.h"
#import "TRCustomAlert.h"
#import "DSCacheDataManager.h"
#import "DSHistoryWinnerViewController.h"
#import "MJRefresh.h"



@interface DSWinnerViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *titleArys;
    
    NSMutableArray *winnerNumbersAry;
    NSMutableArray *orderAry;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTableViewConstraitHeight;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTableViewConstraintHeight;
@end

@implementation DSWinnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titleArys = [NSMutableArray array];
    winnerNumbersAry = [NSMutableArray array];
    orderAry = [NSMutableArray array];
    
    [self setupTableBarItem];    
    
    _myTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [TRCustomAlert showLoadingWithMessage:@"数据加载中..."];
    [self refreshData];
}

- (void)setupTableBarItem {
    
    self.tabBarItem.image = [UIImage imageNamed:@"tablebar_kaijaing"];
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tablebar_kaijaing_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = UIColor.lightGrayColor;
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = DS_MainColor;
    [self.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [self.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
}



- (void)refreshData {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getData];
    });
}


- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    [DSAPIInterface getAllWinnerInfoReqeust:^(id result) {
        NSString *message = result;
        BOOL bparse = [weakSelf parseData:message];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert dissmis];
            if (!bparse) {
                [TRCustomAlert showMessage:[NSString stringWithFormat:@"服务器数据异常"] image:nil];
            } else {
                
                [weakSelf.myTableView reloadData];
            }
            [weakSelf.myTableView.mj_header endRefreshing];
        });
        
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [TRCustomAlert dissmis];
            [TRCustomAlert showMessage:[NSString stringWithFormat:@"请求服务器数失败，%@",error] image:nil];
            [weakSelf.myTableView.mj_header endRefreshing];
        });
    }];
}


- (BOOL)parseData:(NSString *)message {
    if (!message) {
        return NO;
    }
    
    NSArray *contents = [message componentsSeparatedByString:@"@"];
    
    if (contents.count <= 0) {
        return NO;
    }
    
    for (NSString *str in contents) {
        if ([str isEqualToString:@""]) {
            continue;
        }
        NSArray *subAry = [str componentsSeparatedByString:@"|"];
        if (subAry.count < 3) {
            return NO;
        }
        [titleArys addObject:subAry.firstObject];
        [orderAry addObject:subAry[1]];
        [winnerNumbersAry addObject:subAry.lastObject];
        
    }
    
    return YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     NSString *cellIdentyfyID = [NSString stringWithFormat:@"%0ld-%0ld", indexPath.section,indexPath.row];
    DSKaiJianglTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentyfyID];
    if (!cell) {
        cell = [DSKaiJianglTableViewCell cellWithTableView:tableView withIdentifyid:cellIdentyfyID withParameters:winnerNumbersAry[indexPath.row]];
        NSString *titleIndex = titleArys[indexPath.row];
        DSLotteryTicketType type = titleIndex.intValue + 1;
        cell.title.text = [DSCacheDataManager getLotteryTicketName:type];
        cell.subTitle.text = [NSString stringWithFormat:@"第%@期", [orderAry objectAtIndex:indexPath.row]];
    }
    


    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = titleArys.count;
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _myTableViewConstraintHeight.constant = 64.0 * titleArys.count;
    return 64;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DSHistoryWinnerViewController *myView = [story instantiateViewControllerWithIdentifier:@"DSHistoryWinnerViewController"];
    [self.navigationController pushViewController:myView animated:YES];
    myView.ltType = indexPath.row + 1;
    
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
