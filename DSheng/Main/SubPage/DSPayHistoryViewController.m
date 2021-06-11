//
//  DSPayHistoryViewController.m
//  DSheng
//
//  Created by works_yip on 2020/4/14.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSPayHistoryViewController.h"
#import "TRCustomAlert.h"
#import "DSAPIInterface.h"
#import "DSCacheDataManager.h"


#define BUTTON_Height 48
#define ROW_Height (BUTTON_Height + 12 + 2)


@interface DSPayHistoryViewController (){
    
    NSArray *titlesArrarys;
    NSArray *rowsAry;
    
    NSString *oddstring;
    
    
    NSMutableArray *contentData;

    
}
@property (weak, nonatomic) IBOutlet UITableView *myTableview;



@end

@implementation DSPayHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;

    
    [self setupData];
    
}


- (void)reloadContentView {
    
    UIView *cv = [self makeContentView];
    _myScrollview.contentSize = CGSizeMake(DSScreenSize.width, cv.height);
    [_myScrollview addSubview:cv];

}

- (void)initParameters:(DSLotteryTicketType)type withDetailType:(DSLTType)dtype {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LottryticketData" ofType:@"plist"];
    NSDictionary *dictData = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"dict data: %@", dictData);
    
    NSDictionary *ltdict = [dictData objectForKey:[self getLotteryTicketKey:type]];
    
    
    NSDictionary *detailDict = [ltdict objectForKey:[self getCurrentLotteryticket:dtype]];
    
    NSString *titlestrs = [detailDict objectForKey:kDS_TitleAry_Key];
    titlesArrarys = [titlestrs componentsSeparatedByString:@","];
    rowsAry = [detailDict objectForKey:kDS_RowsData_Key];
    
    oddstring = [self getOddsLotteryticket:dtype];

}


- (NSString *)getCurrentLotteryticket:(DSLTType)type {
    
    NSString *key = @"";
    
    switch (type) {
        case DSLTType_sanfencai_lm:
        case DSLTType_sanfenPKcai_lm:
        case DSLTType_beijingPKcai_lm:
        case DSLTType_PCdandan_lm:
        case DSLTType_cqsscai_lm:
        case DSLTType_tjsscai_lm:
            key = kDS_LiangMianPan_Key;
            break;
            
        case DSLTType_sanfencai_1_5:
        case DSLTType_cqsscai_1_5:
        case DSLTType_tjsscai_1_5:
            key = kDS_1_5Qiu_key;
            break;
            
        case DSLTType_sanfenPKcai_1_10:
        case DSLTType_beijingPKcai_1_10:
            key = kDS_1_10Ming_key;
            break;
            
        case DSLTType_sanfenPKcai_gy:
        case DSLTType_beijingPKcai_gy:
            key = kDS_GuanYaJun_key;
            break;
            
        case DSLTType_PCdandan_tm:
        case DSLTType_jslhcai_tm:
        case DSLTType_lhcai_tm:
            key = kDS_TeMa_Key;
            break;
            
        case DSLTType_jslhcai_tm_tws:
            key = kDS_TeMa_TWS_Key;
            break;
        case DSLTType_jslhcai_tm_bs:
            key = kDS_TeMaBoSe_Key;
            break;
        case DSLTType_jslhcai_tm_sx:
            key = kDS_TeMaShengXiao_Key;
            break;
        case DSLTType_jslhcai_tm_lm:
            key = kDS_TeMa_LM_Key;
            break;
            
        default:
            break;
            
    }
    
    return key;
}

- (NSString *)getLotteryTicketKey:(DSLotteryTicketType)type {
    
    
    NSString *key = @"";
    switch (type) {
        case DSLotteryTicketType_sanfencai:
            key = kDS_SanfenCai_Key;
            break;
        case DSLotteryTicketType_sanfenPKcai:
            key = kDS_SanfenPK_Key;
            break;
        case DSLotteryTicketType_beijingPKcai:
            key = kDS_BeijingPK_Key;
            break;
        case DSLotteryTicketType_PCdandan:
            key = kDS_PCDandan_Key;
            break;
        case DSLotteryTicketType_cqsscai:
            key = kDS_CQShishi_key;
            break;
        case DSLotteryTicketType_tjsscai:
            key = kDS_TJShishi_Key;
            break;
        case DSLotteryTicketType_jslhcai:
            key = KDS_JSLHCai_Key;
            break;
        case DSLotteryTicketType_lhcai:
            key = KDS_LHCai_Key;
            break;
            
        default:
            break;
    }
    return key;
}


- (NSString *)getOddsLotteryticket:(DSLTType)type {
    
    NSString *key = @"";
    
    NSArray * oddslist =[DSCacheDataManager shareManager].oddsList;
    if (oddslist.count < 10) {
        return @"x";
    }
    
    switch (type) {
        case DSLTType_sanfencai_lm:
        case DSLTType_sanfenPKcai_lm:
        case DSLTType_beijingPKcai_lm:
        case DSLTType_PCdandan_lm:
            
        case DSLTType_cqsscai_lm:
        case DSLTType_tjsscai_lm:
            key = oddslist[0];
            break;
            
        case DSLTType_sanfencai_1_5:
        case DSLTType_cqsscai_1_5:
        case DSLTType_tjsscai_1_5:
            key = oddslist[1];
            break;
            
        case DSLTType_sanfenPKcai_1_10:
        case DSLTType_beijingPKcai_1_10:
            key = oddslist[2];
            break;
            
        case DSLTType_sanfenPKcai_gy:
        case DSLTType_beijingPKcai_gy:
            key = oddslist[3];
            break;
            
        case DSLTType_PCdandan_tm:
            key = oddslist[4];
            break;
        case DSLTType_jslhcai_tm:
        case DSLTType_lhcai_tm:
            key = oddslist[5];
            break;
            
        case DSLTType_jslhcai_tm_tws:
            key = oddslist[8];
            break;
        case DSLTType_jslhcai_tm_bs:
            key = oddslist[7];
            break;
        case DSLTType_jslhcai_tm_sx:
            key = oddslist[6];
            break;
        case DSLTType_jslhcai_tm_lm:
            key = oddslist[9];
            break;
            
        default:
            break;
            
    }
    
    return key;
}

- (void)setupData {
    
    switch (_type) {
        case 1:
        {

            break;
        }
        case 2:
        {
            self.navigationItem.title = @"投注记录";
            [TRCustomAlert showLoadingWithMessage:@"数据加载中..."];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self getPayData];
            });
            break;
        }
        case 3:
        {
            break;
            
        }
        case 4:
        {
            self.navigationItem.title = @"中奖记录";
            [TRCustomAlert showLoadingWithMessage:@"数据加载中..."];

            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self getZhongjiangData];
            });
            break;
        }
        default:
            break;
    }
}

- (void)getPayData {
    [DSAPIInterface getPayHistoryRequest:^(id result) {
        NSLog(@"%@", result);
        [self parseData:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadContentView];
            [TRCustomAlert dissmis];
        });
    } failed:^(NSError *error) {
        NSLog(@"error : %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert dissmis];
            [TRCustomAlert showMessage:error.domain image:nil];
        });
    }];
}

- (void)getZhongjiangData {
    
    [DSAPIInterface getZhongjiangHistoryRequest:^(id result) {
        
        [self parseData:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadContentView];
            [TRCustomAlert dissmis];
        });
        
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert dissmis];
            [TRCustomAlert showMessage:error.domain image:nil];
        });
    }];
}

- (void)parseData:(NSString *)msg {
    
    NSArray *contents = [msg componentsSeparatedByString:@"@"];
    if (!contentData) {
        contentData = [NSMutableArray array];
    } else {
        [contentData removeAllObjects];
    }
    
    for (NSString *str in contents) {
        if ([str isEqualToString:@""]) {
            continue;
        }
        [contentData addObject:str];
    }
}



- (NSArray *)getButtonsStringsWithIndexs:(NSArray *)indexs {
    
    NSMutableArray *btnTitels = [NSMutableArray array];
    
    for (NSString *cstr in indexs) {
        NSInteger bindex = cstr.integerValue;
        NSInteger titleIndex = (NSInteger)(bindex / 100);
        NSInteger subIndex = bindex % 100;
        NSString *detailRowData = rowsAry[titleIndex];
        NSArray *currentRowData = [detailRowData componentsSeparatedByString:@","];
        NSString *name = [self getButtonName:currentRowData withRowIndex:subIndex];
        NSString *titleName = titlesArrarys[titleIndex];
        titleName = [self getAbridgeName:titleName];
        name = [self getAbridgeName:name];
        if ([titleName isEqualToString:@""]) {
            [btnTitels addObject:[NSString stringWithFormat:@"%@",name]];
        } else {
            [btnTitels addObject:[NSString stringWithFormat:@"%@/%@", titleName, name]];
        }
        
    }
    
    return btnTitels;
    
}

- (NSString *)getButtonName:(NSArray *)items withRowIndex:(NSInteger)rowIndex {
    
    NSString *str = items[rowIndex];
    return str;
}


- (UIView *)makeContentView {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DSScreenSize.width, 100)];
    
    double posizitionY = 0;
    
    for (int rowIndex = 0; rowIndex < contentData.count ; rowIndex++) {
        
        NSString *contentstr = contentData[rowIndex];
        NSArray *tempData = [contentstr componentsSeparatedByString:@";"];
        NSString *str1 = tempData[0];
        NSString *str2 = tempData[1];
        DSLotteryTicketType type = str1.integerValue + 1;
        DSLTType dtype = [self getLotteryticketDetailTypeWithString:str2 andType:type];
        NSString *num = tempData[2];
        NSString *money = tempData[3];
        NSString *childStr = tempData[4];
        NSArray *childAry = [childStr componentsSeparatedByString:@","];
        [self initParameters:type withDetailType:dtype];
        NSString *titleText;
        if (_type == 2) {
            titleText = [NSString stringWithFormat:@"%@ %@ [第%@期] 投注:%@元", [DSCacheDataManager getLotteryTicketName:type], [DSCacheDataManager getTopTitleStringWithType:dtype], num, money];
        } else {
            titleText = [NSString stringWithFormat:@"%@ %@ [第%@期] 收益:%@元", [DSCacheDataManager getLotteryTicketName:type], [DSCacheDataManager getTopTitleStringWithType:dtype], num, money];
        }
        
        
        NSArray *currentDt = [self getButtonsStringsWithIndexs:childAry];
        UIView *view = [self makeRowView:currentDt andTitle:titleText];
        //add topline
        {
            UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DSScreenSize.width, 1)];
            [lineV setBackgroundColor:UIColor.lightGrayColor];
            [view addSubview:lineV];
        }
        if (rowIndex == (titlesArrarys.count - 1)) {
            //add bottom Line
            UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, view.height - 1, DSScreenSize.width, 1)];
            [lineV setBackgroundColor:UIColor.lightGrayColor];
            [view addSubview:lineV];
        }
        
        view.y = posizitionY;
        posizitionY += view.height;
        
        
        [contentView addSubview:view];
        
    }
    
    contentView.height = posizitionY;
    
    return contentView;
}

- (UIView *)makeRowView:(NSArray *)items andTitle:(NSString *)title {
    
    int count = (DSScreenSize.width - 60) / (BUTTON_Height + 15);
    
    int crows = (int)((items.count + count - 1) / count);
    
    UILabel *topView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DSScreenSize.width, 30)];
    [topView setBackgroundColor:UIColor.lightTextColor];
    topView.text = title;
    
    double rowHeight = (crows + 1) * 5 + crows * ROW_Height;
    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.height, DSScreenSize.width, rowHeight)];
    
    UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DSScreenSize.width, rowView.height + topView.height)];

    
    double posizitionY = 5;
    for (int index = 0; index < items.count; index++) {
        
        double posizitonX = 10 + (index % count) * (5 + BUTTON_Height) ;
        if (index % 4 == 0 && index != 0) {
            posizitionY += BUTTON_Height + 2 + 12 + 5;
        }
        
        UIButton *button = [self getSpecialButtonWithName:items[index]];
        button.x = posizitonX;
        button.y = posizitionY;
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [rowView addSubview:button];
        
        UILabel *plLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.x, button.y + BUTTON_Height + 2, 32, 12)];
        plLabel.text = oddstring;
        plLabel.font = [UIFont systemFontOfSize:10];
        plLabel.centerX = button.centerX;
        plLabel.textAlignment = NSTextAlignmentCenter;
        //        [plLabel setBackgroundColor:DSRandomColor];
        [plLabel setTextColor:UIColor.blackColor];
        [rowView addSubview:plLabel];
        
    }
    
    [fView addSubview:topView];
    [fView addSubview:rowView];
    
    return fView;
}

- (UIButton *)getSpecialButtonWithName:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.width = BUTTON_Height;
    btn.height = BUTTON_Height;
    btn.layer.cornerRadius = BUTTON_Height * 0.5;
    [btn setBackgroundColor:DS_MainColor];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    return btn;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = [NSString stringWithFormat:@"%ld-%ld", indexPath.row, indexPath.section];
    
   
    return nil;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
  
    
    return nil;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (NSString *)getAbridgeName:(NSString *)name {
    if ([name isEqualToString:@"总和龙虎"]) {
        return @"总和";
    }
    if ([name isEqualToString:@"总和大"]) {
        return @"大";
    }
    if ([name isEqualToString:@"总和小"]) {
        return @"小";
    }
    if ([name isEqualToString:@"总和单"]) {
        return @"单";
    }
    if ([name isEqualToString:@"总和双"]) {
        return @"双";
    }
    if ([name isEqualToString:@"冠亚军和"]) {
        return @"和";
    }
    if ([name isEqualToString:@"波色豹子"]) {
        return @"豹子";
    }
    if ([name isEqualToString:@"红波"]) {
        return @"红";
    }
    if ([name isEqualToString:@"蓝波"]) {
        return @"蓝";
    }
    if ([name isEqualToString:@"绿波"]) {
        return @"绿";
    }
    if ([name isEqualToString:@"特码生肖"]) {
        return @"生肖";
    }
    if ([name isEqualToString:@"特码波色"]) {
        return @"波色";
    }
    if ([name isEqualToString:@"特码头尾数"]) {
        return @"";
    }
    if ([name isEqualToString:@"特码两面"]) {
        return @"";
    }

    
    return name;
}

- (DSLTType)getLotteryticketDetailTypeWithString:(NSString *)msg andType:(DSLotteryTicketType)type {
    
    DSLTType dtype = DSLTType_sanfencai_lm;
    
    
    
    switch (type) {
        case DSLotteryTicketType_sanfencai:
            if ([msg isEqualToString:@"0"]) {
                dtype = DSLTType_sanfencai_lm;
                break;
            }
            if ([msg isEqualToString:@"1"]) {
                dtype = DSLTType_sanfencai_1_5;
                break;
            }
            break;
        case DSLotteryTicketType_sanfenPKcai:
            if ([msg isEqualToString:@"0"]) {
                dtype = DSLTType_sanfenPKcai_lm;
                break;
            }
            if ([msg isEqualToString:@"2"]) {
                dtype = DSLTType_sanfenPKcai_1_10;
                break;
            }
            if ([msg isEqualToString:@"3"]) {
                dtype = DSLTType_sanfenPKcai_gy;
            }
            break;
        case DSLotteryTicketType_beijingPKcai:
            if ([msg isEqualToString:@"0"]) {
                dtype = DSLTType_beijingPKcai_lm;
                break;
            }
            if ([msg isEqualToString:@"2"]) {
                dtype = DSLTType_beijingPKcai_1_10;
                break;
            }
            if ([msg isEqualToString:@"3"]) {
                dtype = DSLTType_beijingPKcai_gy;
            }
            break;
        case DSLotteryTicketType_PCdandan:
            if ([msg isEqualToString:@"0"]) {
                dtype = DSLTType_PCdandan_lm;
                break;
            }
            if ([msg isEqualToString:@"4"]) {
                dtype = DSLTType_PCdandan_tm;
                break;
            }
            break;
        case DSLotteryTicketType_cqsscai:
            if ([msg isEqualToString:@"0"]) {
                dtype = DSLTType_cqsscai_lm;
                break;
            }
            if ([msg isEqualToString:@"1"]) {
                dtype = DSLTType_cqsscai_1_5;
                break;
            }
 
            break;
        case DSLotteryTicketType_tjsscai:
            if ([msg isEqualToString:@"0"]) {
                dtype = DSLTType_tjsscai_lm;
                break;
            }
            if ([msg isEqualToString:@"1"]) {
                dtype = DSLTType_tjsscai_1_5;
                break;
            }
            break;
        case DSLotteryTicketType_jslhcai:
            if ([msg isEqualToString:@"4"]) {
                dtype = DSLTType_jslhcai_tm;
                break;
            }
            if ([msg isEqualToString:@"8"]) {
                dtype = DSLTType_jslhcai_tm_tws;
                break;
            }
            if ([msg isEqualToString:@"7"]) {
                dtype = DSLTType_jslhcai_tm_bs;
            }
            if ([msg isEqualToString:@"6"]) {
                dtype = DSLTType_jslhcai_tm_sx;
            }
            if ([msg isEqualToString:@"9"]) {
                dtype = DSLTType_jslhcai_tm_lm;
            }
            break;
        case DSLotteryTicketType_lhcai:
            if ([msg isEqualToString:@"5"]) {
                dtype = DSLTType_lhcai_tm;
            }
            break;
        default:
            break;
    }
    
    return dtype;
    
    /*
    switch (type) {
        case DSLTType_sanfencai_lm:
        case DSLTType_sanfenPKcai_lm:
        case DSLTType_beijingPKcai_lm:
        case DSLTType_PCdandan_lm:
        case DSLTType_cqsscai_lm:
        case DSLTType_tjsscai_lm:
            key = @"0";
            break;
            
        case DSLTType_sanfencai_1_5:
        case DSLTType_cqsscai_1_5:
        case DSLTType_tjsscai_1_5:
            key = @"1";
            break;
            
        case DSLTType_sanfenPKcai_1_10:
        case DSLTType_beijingPKcai_1_10:
            key = @"2";
            break;
            
        case DSLTType_sanfenPKcai_gy:
        case DSLTType_beijingPKcai_gy:
            key = @"3";
            break;
            
        case DSLTType_PCdandan_tm:
        case DSLTType_jslhcai_tm:
            key = @"4";
            break;
        case DSLTType_lhcai_tm:
            key = @"5";
            break;
            
        case DSLTType_jslhcai_tm_tws:
            key = @"8";
            break;
        case DSLTType_jslhcai_tm_bs:
            key = @"7";
            break;
        case DSLTType_jslhcai_tm_sx:
            key = @"6";
            break;
        case DSLTType_jslhcai_tm_lm:
            key = @"9";
            break;
            
        default:
            break;
            
    }
    
    return key;
     */
}



@end
