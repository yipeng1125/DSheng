//
//  DSHistoryViewController.m
//  DSheng
//
//  Created by works_yip on 2020/4/10.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSHistoryViewController.h"
#import "TRCustomAlert.h"
#import "DSAPIInterface.h"
#import "DSMyRecordCell.h"


@interface DSHistoryViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *firstAry;
    NSMutableArray *secondAry;
}
@property (weak, nonatomic) IBOutlet UITableView *mytableview;

@end

@implementation DSHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self setupData];
    
    _mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)setupData {
    
    switch (_type) {
        case 1:
        {
            self.navigationItem.title = @"充值记录";
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self getRechageHistoryData];
            });
            break;
        }
        case 2:
        {
            self.navigationItem.title = @"投注记录";
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self getPayData];
            });
            break;
        }
        case 3:
        {
            self.navigationItem.title = @"提现记录";
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                 [self getTakeHistoryData];
            });
            break;

        }
        case 4:
        {
            self.navigationItem.title = @"中奖记录";
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self getZhongjiangData];
            });
            break;
        }
        default:
            break;
    }
}


- (BOOL)parseData:(NSString *)msg {
    
    if (!firstAry) {
        firstAry = [NSMutableArray array];
    } else {
        [firstAry removeAllObjects];
    }
    
    if (!secondAry) {
        secondAry = [NSMutableArray array];
    } else {
        [secondAry removeAllObjects];
    }
    
    if (!msg) {
        return NO;
    }
    
    NSArray *contents = [msg componentsSeparatedByString:@"@"];
    
    for (NSString *item in contents) {
        if ([item isEqualToString:@""]) {
            continue;
        }
        
        NSArray *subs = [item componentsSeparatedByString:@";"];
        
        if (subs.count != 2) {
            return NO;
        }
        [firstAry addObject:subs.lastObject];
        [secondAry addObject:subs.firstObject];
    }
    
    
    return YES;
    
}

- (void)getPayData {
    [DSAPIInterface getPayHistoryRequest:^(id result) {
        NSLog(@"%@", result);
    } failed:^(NSError *error) {
        NSLog(@"error : %@", error);
    }];
}

- (void)getZhongjiangData {
    
    [DSAPIInterface getZhongjiangHistoryRequest:^(id result) {
        
    } failed:^(NSError *error) {
        
    }];
}


- (void)getRechageHistoryData {
    
    [DSAPIInterface getRechageHistoryRequest:^(id result) {
        NSLog(@"result : %@", result);
        
        BOOL berr = [self parseData:result];
        if (!berr) {
            [self showError:@"服务器数据格式异常"];
        } else {
            [self reloadTable];
        }
    } failed:^(NSError *error) {
        NSLog(@"error : %@", error);
        [self showError:error.domain];
    }];
}

- (void)reloadTable {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mytableview reloadData];
    });
}

- (void)showError:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [TRCustomAlert showMessage:errorMsg image:nil];
    });
}

- (void)getTakeHistoryData {
    
    [DSAPIInterface getTakeHistoryRequest:^(id result) {
         NSLog(@"result : %@", result);
    } failed:^(NSError *error) {
        NSLog(@"error : %@", error);
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return firstAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = [NSString stringWithFormat:@"%ld-%ld", indexPath.row, indexPath.section];
    
    DSMyRecordCell *cell = [DSMyRecordCell cellWithTableView:tableView withIdentifyid:identifier];
    cell.firstLabel.text = firstAry[indexPath.row];
    cell.secondLabel.text = secondAry[indexPath.row];
    
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    DSMyRecordCell *cell = [DSMyRecordCell cellWithTableView:tableView withIdentifyid:@""];

    if (_type == 1) {
        cell.firstLabel.text = @"充值时间";
        cell.secondLabel.text = @"金额";
    } else {
        cell.firstLabel.text = @"提现时间";
        cell.secondLabel.text = @"金额";
    }
    
    cell.firstLabel.font = [UIFont systemFontOfSize:20];
    cell.secondLabel.font = [UIFont systemFontOfSize:20];


    cell.contentView.height = 80;
    
    return cell.contentView;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}






@end
