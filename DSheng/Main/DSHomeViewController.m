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
    
    _infomationLabel.text = @"重庆时时彩 20200310042期\r\n12,14,32,10,4,5";
    
    [self setViewActionEvent];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getData];
    });
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
    
    
    str = datas[1];//日期
    
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
    NSLog(@"refresh data");
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
