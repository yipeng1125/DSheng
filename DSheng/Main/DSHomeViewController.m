//
//  DSHomeViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/7.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSHomeViewController.h"
#import "DSCommonHeader.h"
#import "MJRefresh.h"
#import "DSAPIInterface.h"
#import "DSCacheDataManager.h"
#import "DSLotteryTicketInfo.h"
#import "DSChooseLotteryticketViewController.h"
#import "NSDate+ext.h"


#define DS_Bananer_Count 2

@interface DSHomeViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bananerView;

@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;
@property (weak, nonatomic) IBOutlet UILabel *infomationLabel;
@property (weak, nonatomic) IBOutlet UILabel *num1;
@property (weak, nonatomic) IBOutlet UILabel *num2;
@property (weak, nonatomic) IBOutlet UILabel *num3;
@property (weak, nonatomic) IBOutlet UILabel *num4;
@property (weak, nonatomic) IBOutlet UILabel *num5;
@property (weak, nonatomic) IBOutlet UILabel *num6;
@property (weak, nonatomic) IBOutlet UILabel *num7;
@property (weak, nonatomic) IBOutlet UILabel *num8;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UIView *view8;



@property (nonatomic)dispatch_source_t mainTimer;


@end

@implementation DSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    /* 设置导航栏上面的内容 */
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightClick) image:@"列表更多" highImage:@"列表更多"];
//    self.navigationItem.title = @""
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"列表添加" highImage:@"列表添加"];
    
    [_bananerView addSubview:[self scrollViewMake]];
    
    [self loadRefreshView];
    
    [self delayRefeshBananer];
    
    _infomationLabel.text = @"重庆时时彩 20200310042期\r\n12,14,32,10,4,5";
    
    [self setViewActionEvent];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getData];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getUserInfo];
        
    });
    
    [self setUpTimer];
    [self startTimer];
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
    }
}

- (void)taskForTimer {
    
    NSArray *messages = [self calculatorDynamicTime];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateView:messages];
    });
}

- (void)updateView:(NSArray *)messages {
    
    for (int index = 0; index < messages.count; index++) {
        switch (index) {
            case 0:
                _num1.text = messages[index];
                break;
            case 1:
                _num2.text = messages[index];
                break;
            case 2:
                _num3.text = messages[index];
                break;
            case 3:
                _num4.text = messages[index];
                break;
            case 4:
                _num5.text = messages[index];
                break;
            case 5:
                _num6.text = messages[index];
                break;
            case 6:
                _num7.text = messages[index];
                break;
            case 7:
                _num8.text = messages[index];
                break;
                
            default:
                break;
        }
    }
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self pauseTimer];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self startTimer];
}



- (NSArray *)calculatorDynamicTime {
    
    if (DSCacheDataManager.shareManager.lotteryTicketInfoList <= 0) {
        return nil;
    }
    
//    NSString *
    NSMutableArray *mstrings = [NSMutableArray array];
    
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval newInterval = (currentTimeInterval + DSCacheDataManager.shareManager.deviationTime)  - [DSCacheDataManager shareManager].todayTimeInterval;
    NSDate *curTime = [NSDate dateWithTimeIntervalSince1970:(currentTimeInterval + DSCacheDataManager.shareManager.deviationTime)];

    for (DSLotteryTicketInfo *item in DSCacheDataManager.shareManager.lotteryTicketInfoList) {
        
        NSString *message = [item cuttentState:newInterval currentDate:curTime];
        [mstrings addObject:message];
    }
    
    return mstrings;
}






- (void)setViewActionEvent {
    
    _view1.userInteractionEnabled = YES;
    _view2.userInteractionEnabled = YES;
    _view3.userInteractionEnabled = YES;
    _view4.userInteractionEnabled = YES;
    _view5.userInteractionEnabled = YES;
    _view6.userInteractionEnabled = YES;
    _view7.userInteractionEnabled = YES;
    _view8.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickAction1:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickAction2:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickAction3:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickAction4:)];
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickAction5:)];
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickAction6:)];
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickAction7:)];
    UITapGestureRecognizer *tap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickAction8:)];

    [_view1 addGestureRecognizer:tap1];
    [_view2 addGestureRecognizer:tap2];
    [_view3 addGestureRecognizer:tap3];
    [_view4 addGestureRecognizer:tap4];
    [_view5 addGestureRecognizer:tap5];
    [_view6 addGestureRecognizer:tap6];
    [_view7 addGestureRecognizer:tap7];
    [_view8 addGestureRecognizer:tap8];
    
    

}

- (void)getUserInfo {
    NSDictionary *userdict = [DSCommonTool getUserInfo];
    NSDictionary *parameters = @{@"ph":userdict[DS_USER_KEY], @"ps" : userdict[DS_USER_PSD_KEY]};
    [DSAPIInterface getUserInfoAPIReqeust:parameters success:^(id result) {
        NSLog(@"%@",result);
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (void)getData {
    
    [DSAPIInterface lotteryTicketTInfoAPIRequest:^(id result) {
        NSLog(@"result : %@", result);
        NSArray *datas = result;
        [self cacheData:datas];
        
    } failed:^(NSError *error) {
        NSLog(@"error : %@", error.description);
    }];
}

- (void)cacheData:(NSArray *)datas {
    if (datas.count < 5) {
        NSLog(@"server data wrong");
        return;
    }
    
    [[DSCacheDataManager shareManager] clearData];
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *str = datas[0];//服务器当前时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]];

    NSLog(@"server date: %@", date);
    NSLog(@"local  date: %@", [NSDate date]);
    [DSCacheDataManager shareManager].deviationTime = [str doubleValue] - currentTime;
    [DSCacheDataManager shareManager].serverTimeInterval = [str doubleValue];
    
    NSLog(@"deviationTime : %f", [DSCacheDataManager shareManager].deviationTime);
    
    
    str = datas[1];//日期
    if (str) {
        NSDate *todayDate = [NSDate dateWithString:str style:1];
        [DSCacheDataManager shareManager].todayTimeInterval = todayDate.timeIntervalSince1970;
        DSCacheDataManager.shareManager.ymdString = str;
    }
    
    
    NSString *lticketstr = datas[2];
    NSArray *ltickets = [lticketstr componentsSeparatedByString:@";"];
    
    int iType = 1;
    for (NSString *item in ltickets) {
        if ([item isEqualToString:@""]) {
            continue;
        }
        DSLotteryTicketInfo *lticket = [[DSLotteryTicketInfo alloc] initWithString:item withType:iType];
        [[DSCacheDataManager shareManager].lotteryTicketInfoList addObject:lticket];
        iType++;
    }

    
    str = datas[3];//赔率
    NSArray *items = [str componentsSeparatedByString:@";"];
    for (NSString *pl in items) {
        [[DSCacheDataManager shareManager].oddsList addObject:pl];
    }
    
}



- (void)gotoPageWithType:(DSLotteryTicketType)type {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DSChooseLotteryticketViewController *vc = [story instantiateViewControllerWithIdentifier:@"DSChooseLotteryticketViewController"];
    vc.ltType = type;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewClickAction1:(id)sender {
    NSLog(@"click tag : %d", 101);
    
    [self gotoPageWithType:DSLotteryTicketType_sanfencai];
}
- (void)viewClickAction2:(id)sender {
    NSLog(@"click tag : %d", 102);
    
    [self gotoPageWithType:DSLotteryTicketType_sanfenPKcai];
}

- (void)viewClickAction3:(id)sender {
    NSLog(@"click tag : %d", 103);
    
    [self gotoPageWithType:DSLotteryTicketType_beijingPKcai];
}

- (void)viewClickAction4:(id)sender {
    NSLog(@"click tag : %d", 104);
    
    [self gotoPageWithType:DSLotteryTicketType_PCdandan];
}

- (void)viewClickAction5:(id)sender {
    NSLog(@"click tag : %d", 105);
    
    [self gotoPageWithType:DSLotteryTicketType_cqsscai];
}
- (void)viewClickAction6:(id)sender {
    NSLog(@"click tag : %d", 106);
    
    [self gotoPageWithType:DSLotteryTicketType_tjsscai];
}
- (void)viewClickAction7:(id)sender {
    NSLog(@"click tag : %d", 107);
    
    [self gotoPageWithType:DSLotteryTicketType_jslhcai];
}
- (void)viewClickAction8:(id)sender {
    NSLog(@"click tag : %d", 108);
    
    [self gotoPageWithType:DSLotteryTicketType_lhcai];
}

- (IBAction)payAction:(id)sender {
}
- (IBAction)takeMoneyAction:(id)sender {
}
- (IBAction)helpAction:(id)sender {
}

- (void)loadRefreshView {
    
    _mainScrollview.delegate = self;
    _mainScrollview.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}

- (void)refreshData {
    
    [_mainScrollview.mj_header endRefreshing];
}

-(UIView *)scrollViewMake{
    
    UIView *chidView = [[UIView alloc] init];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor blueColor];
    
//    scrollView.frame = CGRectMake(0, 0, wide, wide * 0.5);
    scrollView.frame = _bananerView.bounds;
    
    self.scrollView = scrollView;
    
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (int i=0; i < DS_Bananer_Count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.x = scrollW * i;
        imageView.y = 0;
        
        imageView.backgroundColor = DSRandomColor;
        if ( i % 2 == 0) {
            [imageView setImage:[UIImage imageNamed:@"t1"]];
        } else {
            [imageView setImage:[UIImage imageNamed:@"t2"]];
        }

        [scrollView addSubview:imageView];
    }
    
    scrollView.contentSize = CGSizeMake(DS_Bananer_Count * scrollW, scrollH);
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = DS_Bananer_Count;
    pageControl.backgroundColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = DSColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = DSColor(169, 169, 169);
    pageControl.centerX = scrollW * 0.5;
    pageControl.centerY = scrollH - 10;
    
    chidView.frame = scrollView.bounds;
    [chidView addSubview:scrollView];
    [chidView addSubview:pageControl];
    self.pageControl = pageControl;


    
    return chidView;
}

- (void)delayRefeshBananer {
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        double page = weakSelf.scrollView.contentOffset.x / weakSelf.scrollView.width;
        

        
        weakSelf.pageControl.currentPage = (int)(page + 0.5);
        
        
        [UIView animateWithDuration:0.5 animations:^{
            if (weakSelf.scrollView.contentOffset.x > 0) {
                CGPoint point = weakSelf.scrollView.contentOffset;
                point.x = 0;
                weakSelf.scrollView.contentOffset = point;
            } else {
                CGPoint point = weakSelf.scrollView.contentOffset;
                point.x =  weakSelf.scrollView.width;
                weakSelf.scrollView.contentOffset = point;
            }
        }];
        
        [weakSelf delayRefeshBananer];
    });
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double page = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(page + 0.5);
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
