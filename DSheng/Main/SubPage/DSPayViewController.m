//
//  DSPayViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/11.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSPayViewController.h"
#import "DSCacheDataManager.h"
#import "TRCustomAlert.h"
#import "DSAPIInterface.h"



__weak DSPayViewController *instanceVC;

@interface DSPayViewController ()<UITextFieldDelegate> {
    
    NSMutableArray *mDatas;
    
    long total;
    
}
@property (weak, nonatomic) IBOutlet UIView *shadeView;


@property (weak, nonatomic) IBOutlet UIScrollView *myscrollView;
@property (weak, nonatomic) IBOutlet UILabel *numberOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *winerLabel;
@property (weak, nonatomic) IBOutlet UILabel *remaintimeLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UITextField *numTextfield;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;

@end

@implementation DSPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateContentView];
    
    self.navigationItem.title = @"投注";
    
    [self setupViews];
    
    instanceVC = self;
    
    _numTextfield.layer.borderWidth = 1.0;
    _numTextfield.layer.borderColor = DS_MainColor.CGColor;
    _numTextfield.layer.cornerRadius = 10.0;
    _numTextfield.layer.masksToBounds = YES;
    _numTextfield.delegate = self;
    _numTextfield.keyboardType = UIKeyboardTypeNumberPad;
    
    NSString *bl = [NSString stringWithFormat:@"可用余额%@元", [DSCacheDataManager shareManager].userInfo.balanceMoney];
    _balanceLabel.text = bl;
    
    [self setShadeLayer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    //将触摸事件添加到view上view可以换成任意一个控件的
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)setShadeLayer {
    [_shadeView setBackgroundColor:UIColor.lightGrayColor];
    _shadeView.alpha = 0.5;
}


- (void)keyboardHide:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@", textField.text);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"%@", textField.text);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"change : %@", textField.text);
    
    if (![DSCommonTool checkIsNumber:string]) {
        return NO;
    }
    [self updateMoney];
   
    return YES;
}

- (void)updateMoney {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger totalM = weakSelf.numTextfield.text.integerValue;
        
        self->total = totalM * self->mDatas.count;
        weakSelf.totalLabel.text = [NSString stringWithFormat:@"%ld注%ld元", self->mDatas.count, self->total];
    });

}

- (void)setupViews {
    
    NSString * order = [[DSCacheDataManager shareManager] getNumberOrder:_ltType];
    _numberOrderLabel.text = [NSString stringWithFormat:@"%@", order];
    _winerLabel.text = _winnerString;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch");
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)refreshRemainTime:(NSString *)message {
    
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *msg = [DSCacheDataManager.shareManager calculatorRemainTimeType:weakSelf.ltType block:^(BOOL enalble, NSString * _Nonnull remainTime) {
            
        }];
        weakSelf.remaintimeLabel.text = msg;
    });
    
}

+ (void)updateRemainTime:(NSString *)msg enable:(BOOL)enable {
    if (instanceVC) {
        [instanceVC refreshRemainTime:msg];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!enable) {
            instanceVC.shadeView.hidden = NO;
        } else {
        }
    });
    
    
}

- (void)updateContentView {
    
    double posX = 20.0;
    double posY = 15.0;
    
    int index2 = 0;
    
    int row = 0;
    for (int index = 0; index < mDatas.count; index++) {
        UIButton *btn = mDatas[index];
        posX = 20 + index2 * (btn.width + 10);
        
        if ((posX + 20) > DSScreenSize.width) {
            posX = 20;
            row++;
            index2 = 0;
        } else {
            index2++;
        }
        
        posY = 15 + row * (btn.height + 5);
        btn.x = posX;
        btn.y = posY;
        
        _contentHeightConstraint.constant = posY + btn.height + 10;
        [_contentView addSubview:btn];
        
    }
    
    _myscrollView.contentSize = CGSizeMake(DSScreenSize.width, 190 + _contentHeightConstraint.constant);
    [_contentView updateConstraints];
    
    
}

- (IBAction)commitAction:(id)sender {
    
    if (_numTextfield.text.length == 0) {
        [TRCustomAlert showMessage:@"请输入投注倍数" image:nil];
        return;
    }
    
    if (_numTextfield.text.integerValue == 1) {
        [TRCustomAlert showMessage:@"d每注金额不能低于2元" image:nil];
        return;
    }
    
    if (![DSCommonTool checkIsNumber:_numTextfield.text]) {
        [TRCustomAlert showMessage:@"请检查输入格式" image:nil];
        return;
    }
    
    if (_numTextfield.text.length > 5) {
        [TRCustomAlert showMessage:@"最多投注9999" image:nil];
        return;
    }
    
    long bmoney = DSCacheDataManager.shareManager.userInfo.balanceMoney.integerValue;
    if (total > bmoney) {
        [TRCustomAlert showMessage:@"余额不足" image:nil];
        return;
    }
    
    [self pay];
}

- (void)pay {
    
    NSArray *chooseDataAry = [self getChooseData:mDatas];
    NSString *content = [chooseDataAry componentsJoinedByString:@","];
    
    NSString *type = [self getLotteryTicketString:_ltType];
    NSString *dtype = [self getLotteryticketDetailTypeString:_detailType];
    
    [TRCustomAlert showShadeLoadingWithMessage:@"正在下注中..."];
    
    [DSAPIInterface sendCommitTicketLotteryRequest:type detailType:dtype number:_nextNumString totalMoney:total content:content success:^(id result) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [TRCustomAlert showMessage:@"下注成功" image:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
        
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert showMessage:error.domain image:nil];
        });
    }];
}

- (NSArray *)getChooseData:(NSArray *)items {
    
    NSMutableArray *dataAry = [NSMutableArray array];
    
    for (UIButton *btn in items) {
        [dataAry addObject:@(btn.tag)];
    }
    
    NSLog(@"%@", dataAry);
    
    [dataAry sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSLog(@"%@", dataAry);
    
    NSMutableArray *strDatas = [NSMutableArray array];
    
    for (NSNumber *num in dataAry) {
        NSString *strValue = [NSString stringWithFormat:@"%03ld", num.integerValue];
        [strDatas addObject:strValue];
    }
    
    NSLog(@"strDatas");
    
    return strDatas;
}



- (void)setSelectLotteryTicket:(NSArray *)datas {
    
    if (!mDatas) {
        mDatas = [NSMutableArray array];
    }
    
    for (UIButton *btn in datas) {
        [mDatas addObject:[btn copy]];
    }
}

- (NSString *)getLotteryTicketString:(DSLotteryTicketType)type {
    
    NSString *name = nil;
    switch (type) {
        case DSLotteryTicketType_sanfencai:
            name = @"0";
            break;
        case DSLotteryTicketType_sanfenPKcai:
            name = @"1";
            break;
        case DSLotteryTicketType_beijingPKcai:
            name = @"2";
            break;
        case DSLotteryTicketType_PCdandan:
            name = @"3";
            break;
        case DSLotteryTicketType_cqsscai:
            name = @"4";
            break;
        case DSLotteryTicketType_tjsscai:
            name = @"5";
            break;
        case DSLotteryTicketType_jslhcai:
            name = @"6";
            break;
        case DSLotteryTicketType_lhcai:
            name = @"7";
            break;
        default:
            break;
    }
    
    return name;
    
}

- (NSString *)getLotteryticketDetailTypeString:(DSLTType)type {
    
    NSString *key = nil;
    
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
}

@end
