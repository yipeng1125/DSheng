//
//  DSTrendViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/7.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSTrendViewController.h"
#import "DSCommonHeader.h"
#import "DSCollectionViewCell.h"
#import "DSCacheDataManager.h"
#import "DSAPIInterface.h"
#import "TRCustomAlert.h"


@interface DSTrendViewController ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    UICollectionView *mycollectionView;
    
    DSLotteryTicketType ltType;
    UIView *mySelectView;
    
    NSInteger catoryIndex;
    
    UIView *cView;
    
    __weak UIButton *currentSelectBtn;
    
    NSMutableDictionary *allTrendData;
    
    NSArray *sessionTitleAry;
    NSMutableArray *currentTrendDataAry;
    
    NSLock *mylock;
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *ltButton;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *catoryView;
@end

@implementation DSTrendViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mylock = [NSLock new];
    
    [self setupTableBarItem];
    self.navigationItem.title = @"走势";
    [self makeCollectionView];
    
    
    ltType = DSLotteryTicketType_sanfencai;
    [self setupTitleButton];
    
    [self updateCatoryView];
    
    sessionTitleAry = [self setSessionTitle:ltType andCatoryIndex:0];

    [TRCustomAlert showLoadingWithMessage:@"加载数据中..."];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getTrendData];
    });
}


- (void)setupTableBarItem {
    
    self.tabBarItem.image = [UIImage imageNamed:@"tablebar_zoushi"];
    self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tablebar_zoushi_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = UIColor.lightGrayColor;
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = DS_MainColor;
    [self.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [self.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
}


- (void)getTrendData {
    
    
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    [DSAPIInterface getTrendInfoAPIRequest:^(id result) {

        [self parseData:result];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [TRCustomAlert dissmis];
        });
        
        dispatch_semaphore_signal(sem);
        
    } failed:^(NSError *error) {
        NSLog(@"error : %@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [TRCustomAlert dissmis];
        });
        
        dispatch_semaphore_signal(sem);
    }];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self->mycollectionView reloadData];
        
        [self->mycollectionView setNeedsLayout];
    });
}


- (void)parseData:(NSString *)message {
    
    if (allTrendData) {
        [allTrendData removeAllObjects];
    } else {
        allTrendData = [NSMutableDictionary dictionary];
    }
    NSArray *contents = [message componentsSeparatedByString:@"@"];
    if (contents <= 0) {
        return;
    }
    
    for (NSString *cstr in contents) {
        NSArray *subAry = [cstr componentsSeparatedByString:@"|"];
        
        if (subAry.count <= 0) {
            return;
        }
        NSString *type = subAry.firstObject;
        NSString *key = [NSString stringWithFormat:@"%d", type.intValue + 1];
        NSMutableArray *tdata = [allTrendData objectForKey:key];
        if (tdata) {
            [tdata addObject:subAry];
        } else {
            NSMutableArray *mData = [NSMutableArray array];
            [mData addObject:subAry];
            [allTrendData setObject:mData forKey:key];
        }
    }
    
    NSLog(@"all data : %@", allTrendData);
    
    [self setupTrendData:ltType];
    
}

- (NSArray *)getCollectDataWithType:(NSInteger)catoryIndex {
    
    NSInteger index = catoryIndex % 100;
    
    if (index == 0) {
        return [currentTrendDataAry copy];
    }
    
    NSMutableArray *tdataAry = [NSMutableArray array];
    
    switch (ltType) {
        case DSLotteryTicketType_sanfencai:
        case DSLotteryTicketType_cqsscai:
        case DSLotteryTicketType_tjsscai:
            if (index == 0) {
                return currentTrendDataAry;
            } else if (index == 1) {
                
                [currentTrendDataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx1, BOOL * _Nonnull stop) {
                    NSMutableArray *rowAry = obj;
                    
                    NSMutableArray *newRowAry = [NSMutableArray array];
                    [rowAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx2, BOOL * _Nonnull stop) {
                        if (idx2 != 0) {
                            NSString *msg = obj;
                            if (msg.intValue >= 5) {
                                [newRowAry addObject:@"大"];
                            } else {
                                [newRowAry addObject:@"小"];
                            }
                        } else {
                            [newRowAry addObject:obj];
                        }
                    }];
                    
                    [tdataAry addObject:newRowAry];
                }];
                
            } else if (index == 2) {
                [currentTrendDataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx1, BOOL * _Nonnull stop) {
                    NSMutableArray *rowAry = obj;
                    
                    NSMutableArray *newRowAry = [NSMutableArray array];
                    [rowAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx2, BOOL * _Nonnull stop) {
                        if (idx2 != 0) {
                            NSString *msg = obj;
                            if (msg.intValue % 2 == 0) {
                                [newRowAry addObject:@"双"];
                            } else {
                                [newRowAry addObject:@"单"];
                            }
                        } else {
                            [newRowAry addObject:obj];
                        }
                    }];
                    
                    [tdataAry addObject:newRowAry];
                }];
                
            } else {
                
                for (int i = 0; i < currentTrendDataAry.count; i++) {
                    
                    NSMutableArray *rowAry = currentTrendDataAry[i];
                    NSMutableArray *newRowAry = [NSMutableArray array];
                    for (int j = 0; j < sessionTitleAry.count; j++) {
                        if (i == 0) {
                            [newRowAry addObject:sessionTitleAry[j]];
                        } else {
                            if (j == 0) {
                                [newRowAry addObject:rowAry[0]];
                            } else {
                                long total = [self getTotal:rowAry];
                                [newRowAry addObject:[NSString stringWithFormat:@"%ld", total]];
                                if (total >= 23) {
                                    [newRowAry addObject:@"大"];
                                } else {
                                    [newRowAry addObject:@"小"];
                                }
                                
                                if (total % 2 == 0) {
                                    [newRowAry addObject:@"双"];
                                } else {
                                    [newRowAry addObject:@"单"];
                                }
                                
                                NSString *str1 = rowAry[1];
                                NSString *str2 = rowAry.lastObject;
                                if (str1.intValue > str2.intValue) {
                                    [newRowAry addObject:@"龙"];
                                } else {
                                    [newRowAry addObject:@"虎"];
                                }
                            }
                        }
                    }
                    [tdataAry addObject:newRowAry];
                }
            }
            break;
        case DSLotteryTicketType_sanfenPKcai:
        case DSLotteryTicketType_beijingPKcai:
            if (index == 0) {
                
            } else if (index == 1) {
                for (int i = 0; i < currentTrendDataAry.count; i++) {
                    NSMutableArray *rowAry = currentTrendDataAry[i];
                    NSMutableArray *newRowAry = [NSMutableArray array];
                    for (int j = 0; j < sessionTitleAry.count; j++) {
                        if (i == 0) {
                            [newRowAry addObject:sessionTitleAry[j]];
                        } else {
                            if (j == 0) {
                                [newRowAry addObject:rowAry[0]];
                            } else {
                                NSString *valuestr = rowAry[j];
                                if (valuestr.intValue <= 4) {
                                    [newRowAry addObject:@"小"];
                                } else {
                                    [newRowAry addObject:@"大"];
                                }
                            }
                        }
                    }
                    [tdataAry addObject:newRowAry];
                }
            } else if (index == 2) {
                for (int i = 0; i < currentTrendDataAry.count; i++) {
                    NSMutableArray *rowAry = currentTrendDataAry[i];
                    NSMutableArray *newRowAry = [NSMutableArray array];
                    for (int j = 0; j < sessionTitleAry.count; j++) {
                        if (i == 0) {
                            [newRowAry addObject:sessionTitleAry[j]];
                        } else {
                            if (j == 0) {
                                [newRowAry addObject:rowAry[0]];
                            } else {
                                NSString *valuestr = rowAry[j];
                                if (valuestr.intValue % 2 == 0) {
                                    [newRowAry addObject:@"双"];
                                } else {
                                    [newRowAry addObject:@"单"];
                                }
                            }
                        }
                    }
                    [tdataAry addObject:newRowAry];
                }
            } else if (index == 3) {
                for (int i = 0; i < currentTrendDataAry.count; i++) {
                    NSMutableArray *rowAry = currentTrendDataAry[i];
                    NSMutableArray *newRowAry = [NSMutableArray array];
                    for (int j = 0; j < sessionTitleAry.count; j++) {
                        if (i == 0) {
                            [newRowAry addObject:sessionTitleAry[j]];
                        } else {
                            if (j == 0) {
                                [newRowAry addObject:rowAry[0]];
                            } else {
                                
                                long total = [self getFirstAndSecondTotal:rowAry];
                                if (j == 1) {
                                    NSString *str = [NSString stringWithFormat:@"%ld", total];
                                    [newRowAry addObject:str];
                                } else if (j == 2) {
                                    if (total > 11) {
                                        [newRowAry addObject:@"大"];
                                    } else {
                                        [newRowAry addObject:@"小"];
                                    }
                                } else {
                                    if (total % 2 == 0) {
                                        [newRowAry addObject:@"双"];
                                    } else {
                                        [newRowAry addObject:@"单"];
                                    }
                                }
                            }
                        }
                    }
                    [tdataAry addObject:newRowAry];
                }
            } else {
                for (int i = 0; i < currentTrendDataAry.count; i++) {
                    NSMutableArray *rowAry = currentTrendDataAry[i];
                    NSMutableArray *newRowAry = [NSMutableArray array];
                    for (int j = 0; j < sessionTitleAry.count; j++) {
                        if (i == 0) {
                            [newRowAry addObject:sessionTitleAry[j]];
                        } else {
                            if (j == 0) {
                                [newRowAry addObject:rowAry[0]];
                            } else {
                                NSString *valuestr = rowAry[j];
                                NSString *valuestr2 = rowAry[11 - j];
                                int v1 = valuestr.intValue;
                                int v2 = valuestr2.intValue;
                                if (v1 > v2) {
                                    [newRowAry addObject:@"龙"];
                                } else if (v1 < v2 ) {
                                    [newRowAry addObject:@"虎"];
                                } else {
                                    [newRowAry addObject:@"和"];
                                }
                            }
                        }
                    }
                    [tdataAry addObject:newRowAry];
                }
            }
            break;
        case DSLotteryTicketType_PCdandan:
            if (index == 0) {
                
            } else {
                for (int i = 0; i < currentTrendDataAry.count; i++) {
                    NSMutableArray *rowAry = currentTrendDataAry[i];
                    NSMutableArray *newRowAry = [NSMutableArray array];
                    for (int j = 0; j < sessionTitleAry.count; j++) {
                        if (i == 0) {
                            [newRowAry addObject:sessionTitleAry[j]];
                        } else {
                            if (j == 0) {
                                [newRowAry addObject:rowAry[0]];
                            } else {
                                NSString *totalstr = rowAry.lastObject;
                                int total = totalstr.intValue;
                                if (j == 1) {
                                    if (total <= 13) {
                                        [newRowAry addObject:@"小"];
                                    } else {
                                        [newRowAry addObject:@"大"];
                                    }
                                } else if (j == 2) {
                                    if (total % 2 == 0) {
                                        [newRowAry addObject:@"双"];
                                    } else {
                                        [newRowAry addObject:@"单"];
                                    }
                                } else if (j == 3) {
                                    if (total <= 4) {
                                        [newRowAry addObject:@"极小"];
                                    } else if (total >= 23 && total <= 27) {
                                         [newRowAry addObject:@"极大"];
                                    } else {
                                        [newRowAry addObject:@"-"];
                                    }
                                } else if (j == 4) {
                                    if ((total % 3 == 1) && total != 13 ) {
                                        [newRowAry addObject:@"绿波"];
                                    } else if (total == 2 || total == 5 || total == 8 || total == 11 || total == 17 || total == 20 || total == 23 || total == 26) {
                                        [newRowAry addObject:@"蓝波"];
                                    } else if (total % 3 == 0  && total != 27) {
                                        [newRowAry addObject:@"红波"];
                                    } else {
                                        [newRowAry addObject:@"-"];
                                    }
                                } else {
                                    [newRowAry addObject:@"-"];
                                }
                               
                            }
                        }
                    }
                    [tdataAry addObject:newRowAry];
                }
            }
            break;
            
        case DSLotteryTicketType_jslhcai:
        case DSLotteryTicketType_lhcai:
            if (index == 0) {
            } else if (index == 1){
            } else {
            }
            break;
        default:
            break;
    }
    
    return tdataAry;
}
    
- (long)getFirstAndSecondTotal:(NSArray *)ary {
    
    NSString *str = ary[1];
    NSString *str2 = ary[2];
    
    int t = str.intValue + str2.intValue;

    return t;
}

- (long)getTotal:(NSArray *)ary {
    
    long total = 0;

    for (int index = 0; index < ary.count; index++) {
        if (index == 0) {
            continue;
        }
        NSString *msg = ary[index];
        total += msg.intValue;
    }
    
    return total;
}


- (void)setupTrendData:(DSLotteryTicketType)ltype {
    
    [mylock lock];
    
    NSString *key = [NSString stringWithFormat:@"%d", ltype];
    NSMutableArray *collectionData = [allTrendData objectForKey:key];
    
    [currentTrendDataAry removeAllObjects];
    
    NSArray *titleAry = [self setSessionTitle:ltType andCatoryIndex:0];
    
    if (ltType == DSLotteryTicketType_PCdandan) {
        for (int i = 0; i < collectionData.count; i++) {
            NSMutableArray *sessionAry = [NSMutableArray array];
            for (int j = 0; j < titleAry.count; j++) {
                if (i == 0) {
                    [sessionAry addObject:titleAry[j]];
                    continue;
                }
                
                if (j == 0) {
                    NSString *nm = collectionData[i-1][1];
                    NSRange rg;
                    rg.length = 4;
                    rg.location = 0;
                    nm = [nm stringByReplacingCharactersInRange:rg withString:@""];
                    [sessionAry addObject:nm];
                    continue;
                }
                
                NSString *msg = collectionData[i - 1][2];
                NSArray *nums = [msg componentsSeparatedByString:@","];
                
                if (j == 4) {
                    
                    long total = 0;
                    for (int index = 0; index < nums.count; index++) {
                        NSString *msg = nums[index];
                        total += msg.intValue;
                    }
                    NSString *str = [NSString stringWithFormat:@"%ld", total];
                    [sessionAry addObject:str];
                } else {
                    [sessionAry addObject:nums[j - 1]];
                }
            }
            [currentTrendDataAry addObject:sessionAry];
        }
    } else {
        for (int i = 0; i < collectionData.count; i++) {
            NSMutableArray *sessionAry = [NSMutableArray array];
            for (int j = 0; j < titleAry.count; j++) {
                
                if (i == 0) {
                    [sessionAry addObject:titleAry[j]];
                    continue;
                }
                
                if (j == 0) {
                    NSString *nm = collectionData[i-1][1];
                    NSRange rg;
                    rg.length = 4;
                    rg.location = 0;
                    nm = [nm stringByReplacingCharactersInRange:rg withString:@""];
                    [sessionAry addObject:nm];
                    continue;
                }
                
                NSString *msg = collectionData[i - 1][2];
                NSArray *nums = [msg componentsSeparatedByString:@","];
                
                [sessionAry addObject:nums[j - 1]];
                
            }
            [currentTrendDataAry addObject:sessionAry];
        }
    }
    
    [mylock unlock];
    
}


- (NSArray *)setSessionTitle:(DSLotteryTicketType)type andCatoryIndex:(NSInteger)catoryIndex {
    NSArray *ctAry;
    
    NSInteger index = catoryIndex % 100;
    switch (type) {
        case DSLotteryTicketType_sanfencai:
        case DSLotteryTicketType_cqsscai:
        case DSLotteryTicketType_tjsscai:
            if (index == 0) {
                ctAry = @[@"期号", @"万", @"千", @"百", @"十", @"个"];
            } else if (index == 1) {
                ctAry = @[@"期号", @"万", @"千", @"百", @"十", @"个"];
            } else if (index == 2) {
                ctAry = @[@"期号", @"万", @"千", @"百", @"十", @"个"];
            } else {
                ctAry = @[@"期号", @"总和", @"大小", @"单双", @"龙虎"];
            }
            break;
        case DSLotteryTicketType_sanfenPKcai:
        case DSLotteryTicketType_beijingPKcai:
            if (index == 0) {
                ctAry = @[@"期号", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十"];
            } else if (index == 1) {
                ctAry = @[@"期号", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十"];
            } else if (index == 2) {
                ctAry = @[@"期号", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十"];
            } else if (index == 3){
                ctAry = @[@"期号", @"和", @"大小", @"单双"];
            } else {
                ctAry = @[@"期号", @"一", @"二", @"三", @"四", @"五"];
            }
            break;
        case DSLotteryTicketType_PCdandan:
            if (index == 0) {
                ctAry = @[@"期号", @"一", @"二", @"三", @"和"];
            } else {
                ctAry = @[@"期号", @"大小", @"单双", @"极值", @"波色", @"豹子"];
            }
            break;

        case DSLotteryTicketType_jslhcai:
        case DSLotteryTicketType_lhcai:
            if (index == 0) {
                ctAry = @[@"期号", @"一", @"二", @"三", @"四", @"五", @"六", @"特码"];
            } else if (index == 1){
                ctAry = @[@"期号", @"一", @"二", @"三", @"四", @"五", @"六", @"特码"];
            } else {
                ctAry = @[@"期号", @"特码", @"大小", @"单双", @"波色"];
            }
            break;
        default:
            break;
    }
    
    return ctAry;
}

- (NSArray *)getCatoryStrings:(DSLotteryTicketType)type {
    
    
    NSArray *ctAry;
    switch (type) {
        case DSLotteryTicketType_sanfencai:
            ctAry = @[@"号码", @"大小", @"单双", @"总和龙虎"];
            break;
        case DSLotteryTicketType_sanfenPKcai:
            ctAry = @[@"号码", @"大小", @"单双", @"冠亚和", @"1-5龙虎"];
            break;
        case DSLotteryTicketType_beijingPKcai:
            ctAry = @[@"号码", @"大小", @"单双", @"冠亚和", @"1-5龙虎"];
            break;
        case DSLotteryTicketType_PCdandan:
            ctAry = @[@"号码", @"混合"];
            break;
        case DSLotteryTicketType_cqsscai:
            ctAry = @[@"号码", @"大小", @"单双", @"总和龙虎"];
            break;
        case DSLotteryTicketType_tjsscai:
            ctAry = @[@"号码", @"大小", @"单双", @"总和龙虎"];
            break;
        case DSLotteryTicketType_jslhcai:
            ctAry = @[@"号码", @"生肖", @"两面/波色"];
            break;
        case DSLotteryTicketType_lhcai:
            ctAry = @[@"号码", @"生肖", @"两面/波色"];
            break;
            
        default:
            break;
    }
    

    return ctAry;
}

- (UIView *)makeCatoryView {
    
    UIView *catotyVw = [[UIView alloc] init];
    NSArray *btnStrings = [self getCatoryStrings:ltType];
    
    if (btnStrings.count<=0) {
        return nil;
    }
    
    double width = (DSScreenSize.width - btnStrings.count + 1) / btnStrings.count;
    
    for (int index = 0; index < btnStrings.count; index++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnStrings[index] forState:UIControlStateNormal];
        [btn setTitleColor:DS_MainColor forState:UIControlStateNormal];
        btn.frame = CGRectMake(index * (width + 1), 0, width, 60);
        btn.tag = ltType * 100 + index;
        [btn addTarget:self action:@selector(catoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //默认选中第一个
        if (index == 0) {
            btn.x = -1;
            btn.width = width + 1;
            [self selectedUpdate:btn isSelected:YES];
            catoryIndex = index;
            currentSelectBtn = btn;
        }
        
        if (index < btnStrings.count - 1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(btn.x + btn.width , 0, 1, btn.height)];
            [lineView setBackgroundColor:UIColor.lightGrayColor];
            [catotyVw addSubview:lineView];
        }
        
        
        [catotyVw addSubview:btn];
    }
    
    
    return catotyVw;
}

- (void)selectedUpdate:(UIButton *)button isSelected:(BOOL)isselcted {
    button.selected = isselcted;
    
    if (isselcted) {
        [button setBackgroundColor:DS_MainColor];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    } else {
        [button setBackgroundColor:UIColor.whiteColor];
        [button setTitleColor:DS_MainColor forState:UIControlStateNormal];
    }
}

- (UIView *)makeSelectView {
    
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, DSScreenSize.width, 207)];
    [selectView setBackgroundColor:UIColor.whiteColor];
    for (int index = 0; index < 8; index++) {
        
        double posX = DSScreenSize.width * 0.5 - 160 -20;
        if (index % 2 == 1) {
            posX = DSScreenSize.width * 0.5 + 20;
        }
        int row = (index + 2) / 2;
        double posY = 32 + (row - 1) * (32 + 5);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(posX, posY, 160, 32);
        [button setTitle:[DSCacheDataManager getLotteryTicketName:index + 1] forState:UIControlStateNormal];
        button.tag = index + 1;
        [button setTitleColor:DS_MainColor forState:UIControlStateNormal];
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [DS_MainColor CGColor];
        button.layer.cornerRadius = 2.0;
        [button addTarget:self action:@selector(selectAciont1:) forControlEvents:UIControlEventTouchUpInside];
        [selectView addSubview:button];
    }
    
    return selectView;
}


- (UICollectionView *)makeCollectionView {
    if (!mycollectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);//每个区的空隙
        layout.minimumInteritemSpacing = 10; //列与列之间的间距
        layout.minimumLineSpacing = 10;//行与行之间的间距
//        layout.itemSize = CGSizeMake((DSScreenSize.width - 10)/2, 200);//cell的大小
        
        mycollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        mycollectionView.backgroundColor = [UIColor whiteColor];
        mycollectionView.delegate = self;
        mycollectionView.dataSource = self;
        [mycollectionView registerClass:[DSCollectionViewCell class] forCellWithReuseIdentifier:@"DSCollectionViewCell"];
    }
    
    mycollectionView.frame = _contentView.bounds;
    
    mycollectionView.height = 1000;
    
    currentTrendDataAry = [NSMutableArray array];
    
    [mycollectionView registerNib:[UINib nibWithNibName:@"DSCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DSCollectionViewCell"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);//每个区的空隙
    layout.minimumInteritemSpacing = 0; //列与列之间的间距
    layout.minimumLineSpacing = 0;//行与行之间的间距
    
    [mycollectionView setCollectionViewLayout:layout];
    
    [_contentView addSubview:mycollectionView];
    _contentView.contentSize = CGSizeMake(DSScreenSize.width, mycollectionView.height);
    
    return mycollectionView;
}


- (void)setupTitleButton {
    
    [_ltButton setImage:[UIImage imageNamed:@"jiantou-xia"] forState:UIControlStateNormal];
    [_ltButton setTitle:[DSCacheDataManager getLotteryTicketName:ltType] forState:UIControlStateNormal];
    
    _ltButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _ltButton.titleLabel.textAlignment = NSTextAlignmentRight;
    
    CGFloat space = _ltButton.titleLabel.x - _ltButton.imageView.x - _ltButton.imageView.width;
    
    [_ltButton setImageEdgeInsets:UIEdgeInsetsMake(0,10 + space + _ltButton.titleLabel.width, 0, 0)];
    
    [_ltButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -5 -space - _ltButton.imageView.width, 0, 0)];

}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    NSArray *contentAry = [self getCollectDataWithType:catoryIndex];

    return contentAry.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return sessionTitleAry.count;
}

double posizitionY= 0.0;


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identyfier = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.row, (long)indexPath.section];
//    DSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DSCollectionViewCell" forIndexPath:indexPath];
    
    DSCollectionViewCell *cell = [DSCollectionViewCell cellWithTableView:collectionView withIdentifyid:@"DSCollectionViewCell" indexPath:indexPath];
    
    CGRect rt = cell.frame;
    double wd = (DSScreenSize.width - (sessionTitleAry.count - 1) * 0.25)/sessionTitleAry.count;

    posizitionY = indexPath.section * (48 + 0.25);
    double posizitionX = indexPath.row * (wd +0.25);
    
    rt.size.height = 48;
    rt.size.width =  wd;
    rt.origin.y = posizitionY;
    rt.origin.x = posizitionX;
    cell.frame = rt;
    cell.contentLabel.textColor = UIColor.blackColor;
    
    NSArray *contentAry = [self getCollectDataWithType:catoryIndex];
    
    if (contentAry.count>0) {
        cell.contentLabel.text = contentAry[indexPath.section][indexPath.row];
    } else {
        cell.contentLabel.text = identyfier;
    }
    
    if (indexPath.row == 0) {
        if (indexPath.section != 0) {
            cell.contentLabel.numberOfLines = 2;
            cell.contentLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    
    NSLog(@"%@ : %f", identyfier, rt.size.width);
    
    cell.contentLabel.layer.borderWidth = 0.5;
    cell.contentLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    cell.contentLabel.layer.masksToBounds = YES;
    [cell setNeedsLayout];
    /*
    if (indexPath.section == 0) {
        cell.contentLabel.text = sessionTitleAry[indexPath.row];
        
    } else {
        
        NSInteger index = indexPath.section;
        NSArray *items = currentTrendDataAry[index -1][0];

        if (indexPath.row == 0) {
            cell.contentLabel.text = items[1];
        } else {
            cell.contentLabel.text =
        }
        
        cell.contentLabel;
    }
     */
    
    return cell;
}

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    double width = (DSScreenSize.width - (sessionTitleAry.count - 1) * 0.25)/ sessionTitleAry.count;
    return CGSizeMake(width, 48);
}

// 定义每个Section的四边间距
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    // UIEdgeInsets insets = {top, left, bottom, right};
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

//// 两行cell之间的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}
//
//// 两列cell之间的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"click : %@", indexPath);
}

- (IBAction)refreshAction:(id)sender {
    
    [TRCustomAlert showLoadingWithMessage:@"加载数据中..."];
    
    DSLotteryTicketType ty = ltType;
    NSInteger cindex = catoryIndex;
    UICollectionView *tclview = mycollectionView;
    
    sessionTitleAry = [self setSessionTitle:ty andCatoryIndex:cindex];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getTrendData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [tclview reloadData];
            
        });
    });
    
    
    
}
- (IBAction)selectAction:(id)sender {

    
    if (mySelectView) {
        [mySelectView removeFromSuperview];
        mySelectView = nil;
    } else {
        mySelectView = [self makeSelectView];
        mySelectView.y = _topView.y + _topView.height;
        [self.view addSubview:mySelectView];
    }
    
}


- (void)selectAciont1:(id)sender {
    UIButton *button = (UIButton *)sender;
    ltType = button.tag;
    [_ltButton setTitle:[DSCacheDataManager getLotteryTicketName:ltType] forState:UIControlStateNormal];
    
    if (mySelectView) {
        [mySelectView removeFromSuperview];
        mySelectView = nil;
    }
    
    [self updateCatoryView];
    sessionTitleAry = [self setSessionTitle:ltType andCatoryIndex:0];
    [self setupTrendData:ltType];
    [mycollectionView reloadData];
}

- (void)updateCatoryView {
    
    if (cView) {
        [cView removeFromSuperview];
        cView = nil;
    }
    
    cView = [self makeCatoryView];
    cView.frame = _catoryView.bounds;
    cView.height = cView.height - 1;
    cView.y = 1;

    [_catoryView addSubview:cView];
    
}


- (void)catoryBtnAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    catoryIndex = button.tag % (ltType * 100);
    
    
    [self selectedUpdate:button isSelected:YES];
    [self selectedUpdate:currentSelectBtn isSelected:NO];
    sessionTitleAry = [self setSessionTitle:ltType andCatoryIndex:catoryIndex];
    
    currentSelectBtn = button;
    
    [mycollectionView reloadData];
}



@end
