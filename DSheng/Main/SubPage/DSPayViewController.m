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


__weak DSPayViewController *instanceVC;

@interface DSPayViewController ()<UITextFieldDelegate> {
    
    NSMutableArray *mDatas;
    
}


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
    _numTextfield.layer.borderColor = DSColor(236, 107, 44).CGColor;
    _numTextfield.layer.cornerRadius = 10.0;
    _numTextfield.layer.masksToBounds = YES;
    _numTextfield.delegate = self;
    _numTextfield.keyboardType = UIKeyboardTypeNumberPad;
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    //将触摸事件添加到view上view可以换成任意一个控件的
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)keyboardHide:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@", textField.text);
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSString *valuestring = textField.text;
    if ([DSCommonTool checkIsNumber:valuestring]) {
        _totalLabel.text = [NSString stringWithFormat:@"%ld注%ld元", mDatas.count, valuestring.intValue * mDatas.count * 2];
    }
    
    return YES;
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

+ (void)updateRemainTime:(NSString *)msg {
    if (instanceVC) {
        [instanceVC refreshRemainTime:msg];
    }
    
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
    
    if (![DSCommonTool checkIsNumber:_numTextfield.text]) {
        [TRCustomAlert showMessage:@"请检查输入格式" image:nil];
        return;
    }
    
    if (_numTextfield.text.length > 5) {
        [TRCustomAlert showMessage:@"最多投注9999" image:nil];
        return;
    }
    
    
    NSString *valuestring = _numTextfield.text;
    if ([DSCommonTool checkIsNumber:valuestring]) {
        _totalLabel.text = [NSString stringWithFormat:@"%ld注%ld元", mDatas.count, valuestring.intValue * mDatas.count * 2];
    }
    
}


- (void)setSelectLotteryTicket:(NSArray *)datas {
    
    if (!mDatas) {
        mDatas = [NSMutableArray array];
    }
    
    for (UIButton *btn in datas) {
        [mDatas addObject:[btn copy]];
    }
}

@end
