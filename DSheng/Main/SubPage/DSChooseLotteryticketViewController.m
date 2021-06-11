//
//  DSChooseLotteryticketViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/11.
//  Copyright © 2020 works_yip. All rights reserved.
//


#import "DSCommonHeader.h"
#import "DSChooseLotteryticketViewController.h"
#import "DSButton.h"
#import "DSCommonTool.h"
#import "DSNavigationController.h"
#import "DSCacheDataManager.h"
#import "DSAPIInterface.h"
#import "TRCustomAlert.h"
#import "DSPayViewController.h"
#import "DSRuleIntroduceViewController.h"
#import "DSHistoryWinnerViewController.h"



#define BUTTON_Height 32
#define ROW_Height (32 + 12 + 2)

@interface DSChooseLotteryticketViewController ()<DSNavigationBarDelegate> {
    NSArray *titlesArrarys;
    NSArray *rowsAry;
    NSArray *topTitleArys;
    
    __weak UIView *contentView;
    
    UIView *topView;
    BOOL btopViewShow;
    
    
    __weak UIButton *topButton;
    
    NSMutableArray *selectData;
    
    NSString *winnerNumString;
    
    NSString *oddstring;
    
    BOOL bshowShade;


}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *selectDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *winLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel2;

@property (nonatomic)dispatch_source_t mainTimer;

@property(nonatomic, copy)NSString *winnerNumString;

@property(nonatomic, assign) BOOL bshowShade;


@property (weak, nonatomic) IBOutlet UIView *shadeView;
@property (weak, nonatomic) IBOutlet UIView *moreView;

@end

@implementation DSChooseLotteryticketViewController

@synthesize winnerNumString = _winnerNumString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectData = [NSMutableArray array];
    //step1
    [self initParameters:_ltType];
    btopViewShow = NO;
    _bshowShade = NO;
    
    //step2 准备界面
    [self loadCustomView];
    
    [self makeTopView];
    
    self.navigationItem.title = [DSCacheDataManager getTopTitleStringWithType:_detailType];
    ((DSNavigationController *)self.navigationController).tdelegate = self;
    
//    [self setupNavigationBar];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];

    
    [self updateCustomView];
    
    __weak typeof(self) weakSelf = self;
    
    [TRCustomAlert showShadeLoadingWithMessage:@"加载数据中..."];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [weakSelf getWinnerInfo:weakSelf.ltType];
    });
    
    _moreView.layer.borderWidth = 1.0;
    _moreView.layer.borderColor = [UIColor.lightGrayColor CGColor];
    
    [self startTimer];
    
    [self setShadeLayer];
    
}

- (void)more {
    _moreView.hidden = !_moreView.hidden;
}

- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)setShadeLayer {
    [_shadeView setBackgroundColor:UIColor.lightGrayColor];
    _shadeView.alpha = 0.5;
}


- (void)setUpTimer {
    dispatch_queue_t pingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.mainTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, pingQueue);
    dispatch_source_set_timer(self.mainTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.mainTimer, ^{
        
        [weakSelf taskForTimer];
    });
}

- (void)startTimer {
    if (_mainTimer) {
        dispatch_resume(self.mainTimer);
    } else {
        [self setUpTimer];
        dispatch_resume(self.mainTimer);
    }
}

- (void)pauseTimer {
    if (self.mainTimer) {
        dispatch_suspend(_mainTimer);
    }
}

- (void)cancelTimer {
    if (self.mainTimer) {
        dispatch_source_cancel(self.mainTimer);
        self.mainTimer = nil;
    }
}

- (void)taskForTimer {
    
    __weak typeof(self) weakSelf = self;
    
    if (_ltType == DSLotteryTicketType_lhcai) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.remainTimeLabel.text = [NSString stringWithFormat:@"%@",@"周二21:30开奖"];
        });
        return;
    }
    
    
    BOOL needUpdate = _enablePayLotteryTicket;

    NSString *msg = [DSCacheDataManager.shareManager calculatorRemainTimeType:_ltType block:^(BOOL enalble, NSString * _Nonnull remainTime) {
        
        weakSelf.enablePayLotteryTicket = enalble;
        
    }];
        
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.remainTimeLabel.text = [NSString stringWithFormat:@"截止投注: %@",msg];
        
        
        if (needUpdate != weakSelf.enablePayLotteryTicket) {
            if (!weakSelf.enablePayLotteryTicket) {
                weakSelf.shadeView.hidden = NO;
                weakSelf.bshowShade = YES;
            } else {
//                [TRCustomAlert dissmis];
                [weakSelf updateCustomView];
                [TRCustomAlert showShadeLoadingWithMessage:@"加载数据中..."];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [weakSelf getWinnerInfo:weakSelf.ltType];
                });
                weakSelf.bshowShade = NO;
                weakSelf.shadeView.hidden = YES;
                
                [self updateCustomView];
            }
        } else {
            if (!weakSelf.bshowShade && !weakSelf.enablePayLotteryTicket) {
//                [TRCustomAlert showLoadingWithMessage:@"封盘"];
                weakSelf.shadeView.hidden = NO;
                weakSelf.bshowShade = YES;
            }
        }
    });
    
    [DSPayViewController updateRemainTime:msg enable:self.enablePayLotteryTicket];
}

- (void)dealloc {
    [self cancelTimer];
}



- (void)updateCustomView {
    
    NSString * order = [[DSCacheDataManager shareManager] getNumberOrder:_ltType];
    
//    _numLabel.text = [NSString stringWithFormat:@"%@", order];
    
    _numLabel.text = [NSString stringWithFormat:@"%@ %@",[DSCacheDataManager getLotteryTicketName:_ltType], order];

    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    [self cancelTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self startTimer];
}


- (void)getWinnerInfo:(DSLotteryTicketType)type {
    
    NSInteger typeindex = type - 1;
    
    
    __weak typeof(self) weakSelf = self;

    [DSAPIInterface getWinnerInfoAPIRequest:typeindex success:^(id result) {
        NSLog(@"%@", result);
        NSString *message = (NSString *)result;
        NSArray *contents = [self parseMessage:message];

        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert dissmis];
            if (!contents) {
                [TRCustomAlert showMessage:[NSString stringWithFormat:@"服务器数据错误。\r\n%@", message] image:nil];
            } else {
                if (weakSelf.ltType == DSLotteryTicketType_lhcai) {
                    NSString *str = contents[1];
                    str = [NSString stringWithFormat:@"%ld", ([str integerValue] + 1)];
                    
                    weakSelf.numLabel.text = [NSString stringWithFormat:@"%@ %@",[DSCacheDataManager getLotteryTicketName:weakSelf.ltType], str];
                } else {
                    [weakSelf updateCustomView];
                }
                weakSelf.winnerNumString = [NSString stringWithFormat:@"开奖号码: %@", contents.lastObject];
                weakSelf.winLabel.text = weakSelf.winnerNumString;
                
            }
        });
       
    } failed:^(NSError *error) {
        NSLog(@"%@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert dissmis];
            [TRCustomAlert showMessage:[NSString stringWithFormat:@"服务器错误。\r\n%@", error] image:nil];
        });
    }];
    
}

- (NSArray *)parseMessage:(NSString *)message {
    if (!message) {
        return nil;
    }
    
    NSArray *contents = [message componentsSeparatedByString:@"@"];
    if (contents.count <= 0) {
        return nil;
    }
    
    NSString *str = contents.firstObject;
    NSArray *subContents = [str componentsSeparatedByString:@"|"];
    
    if (contents.count < 3) {
        return nil;
    }
    return subContents;
}



- (void)topViewClicked:(id)sender {
    NSLog(@"sender : %@", sender);
    
    [selectData removeAllObjects];
    
    [self navigationTitleClick];
}



- (void)loadCustomView {
    
    if (contentView) {
        [contentView removeFromSuperview];
    }
    
    UIView *contentV = [self makeContentView];
    contentView = contentV;
    self.scrollView.contentSize = CGSizeMake(DSScreenSize.width, contentV.height);
    [self.scrollView addSubview:contentV];

}


- (void)initParameters:(DSLotteryTicketType) type {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LottryticketData" ofType:@"plist"];
    NSDictionary *dictData = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"dict data: %@", dictData);
    
    NSDictionary *ltdict = [dictData objectForKey:[self getLotteryTicketKey:type]];
    
    
    NSDictionary *detailDict = [ltdict objectForKey:[self getCurrentLotteryticket:_detailType]];
    
    NSString *titlestrs = [detailDict objectForKey:kDS_TitleAry_Key];
    titlesArrarys = [titlestrs componentsSeparatedByString:@","];
    rowsAry = [detailDict objectForKey:kDS_RowsData_Key];
    
    topTitleArys = [self getTopTitles:type];
    
    oddstring = [self getOddsLotteryticket:_detailType];
}

- (NSArray *)getTopTitles:(DSLotteryTicketType)type {
    
    NSArray *toptitleAry;
    switch (type) {
        case DSLotteryTicketType_sanfencai:
            toptitleAry = @[ @(DSLTType_sanfencai_lm), @(DSLTType_sanfencai_1_5)];
            break;
        case DSLotteryTicketType_sanfenPKcai:
            toptitleAry = @[@(DSLTType_sanfenPKcai_lm), @(DSLTType_sanfenPKcai_1_10), @(DSLTType_sanfenPKcai_gy)];
            break;
        case DSLotteryTicketType_beijingPKcai:
            toptitleAry = @[@(DSLTType_beijingPKcai_lm), @(DSLTType_beijingPKcai_1_10), @(DSLTType_beijingPKcai_gy)];
            break;
        case DSLotteryTicketType_PCdandan:
            toptitleAry = @[@(DSLTType_PCdandan_lm), @(DSLTType_PCdandan_tm)];
            break;
        case DSLotteryTicketType_cqsscai:
            toptitleAry = @[@(DSLTType_cqsscai_lm), @(DSLTType_cqsscai_1_5)];
            break;
        case DSLotteryTicketType_tjsscai:
            toptitleAry = @[@(DSLTType_tjsscai_lm), @(DSLTType_tjsscai_1_5)];
            break;
        case DSLotteryTicketType_jslhcai:
            toptitleAry = @[ @(DSLTType_jslhcai_tm), @(DSLTType_jslhcai_tm_tws), @(DSLTType_jslhcai_tm_bs), @(DSLTType_jslhcai_tm_sx), @(DSLTType_jslhcai_tm_lm)];
            break;
        case DSLotteryTicketType_lhcai:
            toptitleAry = @[@(DSLTType_lhcai_tm)];
            break;
            
        default:
            break;
    }
    return toptitleAry;
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

- (void)setupDefaultType:(DSLotteryTicketType)type {
    
    switch (type) {
        case DSLotteryTicketType_sanfencai:
            _detailType = DSLTType_sanfencai_lm;
            break;
        case DSLotteryTicketType_sanfenPKcai:
            _detailType = DSLTType_sanfenPKcai_lm;
            break;
        case DSLotteryTicketType_beijingPKcai:
            _detailType = DSLTType_beijingPKcai_lm;
            break;
        case DSLotteryTicketType_PCdandan:
            _detailType = DSLTType_PCdandan_lm;
            break;
        case DSLotteryTicketType_cqsscai:
            _detailType = DSLTType_cqsscai_lm;
            break;
        case DSLotteryTicketType_tjsscai:
            _detailType = DSLTType_tjsscai_lm;
            break;
        case DSLotteryTicketType_jslhcai:
            _detailType = DSLTType_jslhcai_tm;
            break;
        case DSLotteryTicketType_lhcai:
            _detailType = DSLTType_lhcai_tm;
            break;
            
        default:
            break;
    }
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (double)getPosizitionX:(NSUInteger)cout withIndex:(int)index {
    
    if (cout == 1) {
        return DSScreenSize.width / 2;
    }
    
    if (cout == 2) {
        if (index == 0) {
            return DSScreenSize.width / 2 - 60;
        } else {
            return DSScreenSize.width / 2 + 60;
        }
    }
    
    if (cout == 3) {
        if (index == 0) {
            return DSScreenSize.width / 2 / 2;
        } else if (index == 1) {
            return DSScreenSize.width / 2;
        } else {
            return DSScreenSize.width / 2 * 1.5;
        }
    }
    
    if (cout == 4) {
        if (index == 0 || index == 3) {
            return DSScreenSize.width / 2 / 2;
        } else if (index == 1) {
            return DSScreenSize.width / 2;
        } else {
            return DSScreenSize.width / 2 * 1.5;
        }
    }
    
    if (cout == 5) {
        if (index == 0 || index == 3) {
            return DSScreenSize.width / 2 / 2;
        } else if (index == 1 || index == 4) {
            return DSScreenSize.width / 2;
        } else {
            return DSScreenSize.width / 2 * 1.5;
        }
    }
    
    return 0;
}

- (void)makeTopView {
    
    int rows = (int)(topTitleArys.count + 2) / 3;
    double posizitionY = 5;
    double height = 5 * (rows + 1) + rows * 48;
    UIView *tview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DSScreenSize.width, height)];
    [tview setBackgroundColor:UIColor.whiteColor];
    
    for (int index = 0; index < topTitleArys.count; index++) {

        NSNumber *item = topTitleArys[index];
        
        if (index % 3 == 0 && index != 0) {
            posizitionY += 5 + 48;
        }
        
        DSLTType type = [item intValue];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, posizitionY, 96, 48)];
        double x = [self getPosizitionX:topTitleArys.count withIndex:index];
        button.centerX = x;
        NSString *title = [DSCacheDataManager getTopTitleStringWithType:type];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        button.imageView.contentMode = UIViewContentModeLeft;
        [button setImage:[UIImage imageNamed:@"m2"] forState:UIControlStateNormal];
        
//        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width, 0, -button.titleLabel.bounds.size.width)];
//        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.size.width, 0, button.imageView.size.width)];
        
        double marginX = 5;
        double marginX2 = 5;
         if (title.length == 3) {
            marginX = 5;
            marginX2 = 10;
        } else if (title.length >= 4) {
            marginX = 20;
            marginX2 = 30;
        }
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, marginX2-button.titleLabel.bounds.size.width - button.imageView.bounds.size.width, 0, 0)];
        
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0,-marginX -button.imageView.bounds.size.width - button.titleLabel.bounds.size.width)];
        
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = DS_MainColor.CGColor;
        
        button.tag = type;
        [button addTarget:self action:@selector(topButtionClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [tview addSubview:button];
        
    }
    
    tview.height = posizitionY + 48 + 5;
    
    topView = tview;
//    topView.hidden = YES;
    
//    [_mainView addSubview:view];
    
}

- (void)setLtType:(DSLotteryTicketType)ltType {
    _ltType = ltType;
    [self setupDefaultType:_ltType];
}

- (UIView *)makeContentView {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DSScreenSize.width, 100)];
    
    double posizitionY = 0;
    
    for (int rowIndex = 0; rowIndex < titlesArrarys.count ; rowIndex++) {
        
        //
        UIView *view = [self makeRowView:rowsAry andTitle:titlesArrarys[rowIndex] andRowIndex:rowIndex];
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

- (UIView *)makeRowView:(NSArray *)items andTitle:(NSString *)title andRowIndex:(int)rowIndex {
    
    NSString *contensStr = [items objectAtIndex:rowIndex];
    NSArray *contentArys = [contensStr componentsSeparatedByString:@","];
    
    
    int crows = (int)((contentArys.count + 3) / 4.0);

    //标准高40.0
    double rowHeight = (crows + 1) * 5 + crows * ROW_Height;
    double rowWidth = DSScreenSize.width;
    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DSScreenSize.width, rowHeight)];

    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 32)];
    [tLabel setBackgroundColor:DS_MainColor];
    tLabel.centerY = rowView.centerY;
    tLabel.text = title;
    tLabel.numberOfLines = 2;
    tLabel.font = [UIFont systemFontOfSize:10];
    
    [rowView addSubview:tLabel];
    
    double posizitionY = 5;
    for (int index = 0; index < contentArys.count; index++) {
        
        double posizitonX = 0.2 * ((index % 4 + 1)) * rowWidth;
        if (index % 4 == 0 && index != 0) {
            posizitionY += BUTTON_Height + 2 + 12 + 5;
        }
        
        DSButton *button = [DSButton makeSpecialTypeButtonWithTitle:contentArys[index] withFrame:CGRectMake(0, 0, 32, 32)];
        button.x = posizitonX;
        button.y = posizitionY;
        [button addTarget:self action:@selector(buttonClictAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        button.tag = rowIndex * 100 + index;
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
    
    return rowView;
}

- (IBAction)buttonClictAction:(id)sender {
    
    UIButton *button = sender;
    BOOL bselected = button.selected;
    NSLog(@"selected: %d", bselected);
    NSLog(@"tag : %ld", button.tag);
    button.selected = !bselected;
    
    if (button.selected) {
        [selectData addObject:button];
    } else {
        [selectData removeObject:button];
    }
    _selectDetailLabel.text = [NSString stringWithFormat:@"%ld注%ld元", selectData.count, selectData.count * 2];
}

- (IBAction)topButtionClick:(id)sender {
    UIButton *button = sender;
    
    if (_detailType != button.tag) {
        _detailType = button.tag;
        [self initParameters:_ltType];
        [self loadCustomView];
        
    }
    
    if (topView) {
        [topView removeFromSuperview];
        btopViewShow = NO;
    }
    
    self.navigationItem.title = [DSCacheDataManager getTopTitleStringWithType:_detailType];
    oddstring = [self getOddsLotteryticket:_detailType];

}

- (IBAction)deleteButtonAction:(id)sender {
    
    for (UIButton *btn in selectData) {
        btn.selected = NO;
    }
    
    _selectDetailLabel.text = @"0注0元";
}
- (IBAction)commintAction:(id)sender {
    
    
    if (selectData.count <= 0) {
        [TRCustomAlert showMessage:@"请先选择，再下注" image:nil];
        return;
    }
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DSPayViewController *myViewC = [story instantiateViewControllerWithIdentifier:@"DSPayViewController"];
    myViewC.ltType = _ltType;
    myViewC.detailType = _detailType;
    myViewC.winnerString = self.winnerNumString;
    [myViewC setSelectLotteryTicket:selectData];
    
    NSString *numstr = [_numLabel.text componentsSeparatedByString:@" "].lastObject;
    NSString *nextStr = numstr;
    myViewC.nextNumString = nextStr;
    
    [self.navigationController pushViewController:myViewC animated:YES];
    
}

- (void)navigationTitleClick {
    
    if (!btopViewShow) {
        [topView removeFromSuperview];
    
        [_mainView addSubview:topView];
        topView.hidden = NO;
        btopViewShow = YES;
    } else {
        btopViewShow = NO;
        [topView removeFromSuperview];
    }
    
}

- (IBAction)touzhuAction:(id)sender {
    _moreView.hidden = YES;
    
    

}

- (IBAction)winerAction:(id)sender {
    _moreView.hidden = YES;
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DSHistoryWinnerViewController *myView = [story instantiateViewControllerWithIdentifier:@"DSHistoryWinnerViewController"];
    [self.navigationController pushViewController:myView animated:YES];
    myView.ltType = _ltType;

}

- (IBAction)ruleAction:(id)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DSRuleIntroduceViewController *myViewC = [story instantiateViewControllerWithIdentifier:@"DSRuleIntroduceViewController"];
    myViewC.ltType = _ltType;
    [self.navigationController pushViewController:myViewC animated:YES];
    
    _moreView.hidden = YES;

}
@end
