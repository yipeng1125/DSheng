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


#define BUTTON_Height 32
#define ROW_Height (32 + 12 + 2)

@interface DSChooseLotteryticketViewController () {
    NSArray *titlesArrarys;
    NSArray *rowsAry;
    NSArray *topTitleArys;

}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@end

@implementation DSChooseLotteryticketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //step1
    [self setupDefaultType:_ltType];
    //step2
    [self initParameters:_ltType];
    
    
    //step3 准备界面
    UIView *contentV = [self makeContentView];
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


- (NSString *)getTopTitleStringWithType:(DSLTType)type {
    
    NSString *key = @"";
    
    switch (type) {
        case DSLTType_sanfencai_lm:
        case DSLTType_sanfenPKcai_lm:
        case DSLTType_beijingPKcai_lm:
        case DSLTType_PCdandan_lm:
        case DSLTType_cqsscai_lm:
        case DSLTType_tjsscai_lm:
            key = @"两面盘";
            break;
            
        case DSLTType_sanfencai_1_5:
        case DSLTType_cqsscai_1_5:
        case DSLTType_tjsscai_1_5:
            key = @"1-5球";
            break;
            
        case DSLTType_sanfenPKcai_1_10:
        case DSLTType_beijingPKcai_1_10:
            key = @"1-10名";
            break;
            
        case DSLTType_sanfenPKcai_gy:
        case DSLTType_beijingPKcai_gy:
            key = @"冠亚军";
            break;
            
        case DSLTType_PCdandan_tm:
        case DSLTType_jslhcai_tm:
        case DSLTType_lhcai_tm:
            key = @"特码";
            break;
            
        case DSLTType_jslhcai_tm_tws:
            key = @"特码特尾数";
            break;
        case DSLTType_jslhcai_tm_bs:
            key = @"特码波色";
            break;
        case DSLTType_jslhcai_tm_sx:
            key = @"特码生肖";
            break;
        case DSLTType_jslhcai_tm_lm:
            key = @"特码两面";
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



- (void)makeTopView {
    
    for (NSNumber *item in topTitleArys) {
        DSLTType type = [item intValue];
        
        UIButton *button = [[UIButton alloc] init];
        NSString *title = [self getTopTitleStringWithType:type];
        [button setTitle:title forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"m2"] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width, 0, -button.titleLabel.bounds.size.width)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.size.width, 0, button.imageView.size.width)];
        
    }
}

- (UIView *)makeContentView {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DSScreenSize.width, 100)];
    
    double posizitionY = 0;
    
    for (int rowIndex = 0; rowIndex < titlesArrarys.count ; rowIndex++) {
        
        //
        UIView *view = [self makeRowView:rowsAry andTitle:titlesArrarys[rowIndex] andRowIndex:rowIndex];
        
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
    [rowView setBackgroundColor:DSRandomColor];

    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 32)];
    [tLabel setBackgroundColor:DSColor(236, 107, 44)];
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
        
        DSButton *button = [DSButton makeSpecialTypeButtonWithTitle:contentArys[index]];
        button.x = posizitonX;
        button.y = posizitionY;
        [button addTarget:self action:@selector(buttonClictAction:) forControlEvents:UIControlEventTouchUpInside];
        [rowView addSubview:button];
        
        UILabel *plLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.x, button.y + BUTTON_Height + 2, 32, 12)];
        plLabel.text = @"1.53";
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
    button.selected = !bselected;
}



@end
