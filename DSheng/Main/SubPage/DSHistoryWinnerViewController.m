//
//  DSHistoryWinnerViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/17.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSHistoryWinnerViewController.h"
#import "DSHistoryTableViewCell.h"
#import "TRCustomAlert.h"
#import "DSAPIInterface.h"
#import "DSCacheDataManager.h"


@interface DSHistoryWinnerViewController () {
    
    NSMutableArray *titleAry;
    NSMutableArray *subTitleAry;
    
    NSString *currentName;
}
@property (weak, nonatomic) IBOutlet UITableView *mytableView;

@end

@implementation DSHistoryWinnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titleAry = [NSMutableArray array];
    subTitleAry = [NSMutableArray array];
    
    currentName = [DSCacheDataManager getLotteryTicketName:_ltType];
    self.navigationItem.title = @"开奖历史";
    self.navigationController.navigationBar.hidden = NO;

    [TRCustomAlert showLoadingWithMessage:@"加载数据中..."];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self getData];
    });
}


- (void)getData {
    
    __weak typeof(self) weakSelf = self;
    [DSAPIInterface getWinnerInfoAPIRequest:0 success:^(id result) {
        NSString *message = result;
        BOOL bparse = [weakSelf parseMessage:message];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert dissmis];
            if (!bparse) {
                [TRCustomAlert showMessage:[NSString stringWithFormat:@"服务器数据异常"] image:nil];
            } else {
                [weakSelf.mytableView reloadData];
            }
        });
        
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert dissmis];
            [TRCustomAlert showMessage:[NSString stringWithFormat:@"请求服务器数失败，%@",error] image:nil];
        });
    }];
}

- (BOOL)parseMessage:(NSString *)message {
    if (!message) {
        return NO;
    }
    
    NSArray *contents = [message componentsSeparatedByString:@"@"];
    if (contents.count <= 0) {
        return NO;
    }

    for (NSString *item in contents) {
        
        if ([item isEqualToString:@""]) {
            continue;
        }
        
        NSArray *subContents = [item componentsSeparatedByString:@"|"];
        if (contents.count < 3) {
            return NO;
        }
        
        [titleAry addObject:subContents[1]];
        [subTitleAry addObject:subContents.lastObject];
        
    }
    
    if (contents.count < 3) {
        return NO;
    }
    return YES;;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentyfyID = [NSString stringWithFormat:@"%0ld-%0ld", indexPath.section,indexPath.row];
    DSHistoryTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentyfyID];
    if (!cell) {
        cell = [DSHistoryTableViewCell cellWithTableView:tableView withIdentifyid:cellIdentyfyID withParameters:subTitleAry[indexPath.row]];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@", currentName, titleAry[indexPath.row]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = titleAry.count;
    NSLog(@"count : %ld", count);
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 94;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
}




- (IBAction)payAction:(id)sender {
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
