//
//  DSRule.m
//  DSheng
//
//  Created by works_yip on 2020/3/17.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSRule.h"

@implementation DSRule

+ (void)returnResul:(NSString *)result andType:(DSLotteryTicketType)type andBock:(void(^)(NSString *total, NSString *longhu))block {
    
    switch (type) {
        case DSLotteryTicketType_sanfencai:
            [self getSanfen:result returnBolck:block];
            break;
        case DSLotteryTicketType_sanfenPKcai:
            [self getSanfenPK:result returnBolck:block];
            break;
        case DSLotteryTicketType_beijingPKcai:
            [self getBeijingPK:result returnBolck:block];
            break;
        case DSLotteryTicketType_PCdandan:
            [self getPCDandan:result returnBolck:block];
            break;
        case DSLotteryTicketType_cqsscai:
            
            break;
        case DSLotteryTicketType_tjsscai:
            
            break;
        case DSLotteryTicketType_jslhcai:
            
            break;
        case DSLotteryTicketType_lhcai:
            
            break;
            
        default:
            break;
    }
    
}

+ (NSString *)getTotalResult:(NSArray *)contens {
    
    int t = 0;
    for (NSString *msg in contens) {
        t += msg.intValue;
    }
    
    NSString *totalstr;
    if (t<23) {
        if (t % 2) {
            totalstr = [NSString stringWithFormat:@"%d  ,%@ %@", t, @"小", @"双"];
        } else {
            totalstr = [NSString stringWithFormat:@"%d  ,%@ %@", t, @"小", @"单"];
        }
        
    } else {
        if (t % 2) {
            totalstr = [NSString stringWithFormat:@"%d  ,%@ %@", t, @"大", @"双"];
        } else {
            totalstr = [NSString stringWithFormat:@"%d  ,%@ %@", t, @"大", @"单"];
        }
    }
    
    return totalstr;
    
}

+ (void)getSanfen:(NSString *)result returnBolck:(void (^)(NSString * _Nonnull, NSString * _Nonnull))block {
    
    NSArray *contens = [result componentsSeparatedByString:@","];

    NSString *totalstr = [self getTotalResult:contens];
    
    NSString *longhu;
    NSString *index1 = contens.firstObject;
    NSString *index5 = contens.lastObject;
    int one = index1.intValue;
    int five = index5.intValue;
    if (one > five) {
        longhu = @"虎";
    } else if(one == five) {
        longhu = @"和";
    } else {
        longhu = @"龙";
    }
    
    if (block) {
        block(totalstr, longhu);
    }
}

+ (void)getSanfenPK:(NSString *)result returnBolck:(void (^)(NSString * _Nonnull, NSString * _Nonnull))block {
    
    NSArray *contens = [result componentsSeparatedByString:@","];
    int t = 0;
    for (int index = 0; index < 2; index++) {
        NSString *vstr = contens[index];
        t += vstr.intValue;
    }
    
    NSString *totalstr;
    if (t<=11) {
        if (t % 2) {
            totalstr = [NSString stringWithFormat:@"%d  ,%@ %@", t, @"小", @"双"];
        } else {
            totalstr = [NSString stringWithFormat:@"%d  ,%@ %@", t, @"小", @"单"];
        }
        
    } else {
        if (t % 2) {
            totalstr = [NSString stringWithFormat:@"%d  ,%@ %@", t, @"大", @"双"];
        } else {
            totalstr = [NSString stringWithFormat:@"%d  ,%@ %@", t, @"大", @"单"];
        }
    }
    
    NSString *longhu = @"";
    long countIndex = contens.count - 1;
    for (int index = 0; index < 5; index++) {
        NSString *vstr = contens[index];
        NSString *vstr2 = contens[countIndex - index];
        if (vstr > vstr2) {
            longhu = [longhu stringByAppendingString:@"龙"];
        } else {
             longhu = [longhu stringByAppendingString:@"虎"];
        }
    }
    
    if (block) {
        block(totalstr, longhu);
    }
}

+ (void)getBeijingPK:(NSString *)result returnBolck:(void (^)(NSString * _Nonnull, NSString * _Nonnull))block {
    
    [self getSanfenPK:result returnBolck:block];
}


+ (void)getPCDandan:(NSString *)result returnBolck:(void (^)(NSString * _Nonnull, NSString * _Nonnull))block {
    
    NSArray *contens = [result componentsSeparatedByString:@","];
    int t = 0;
    for (int index = 0; index < contens.count; index++) {
        NSString *vstr = contens[index];
        t += vstr.intValue;
    }
    
    NSString *totalstr;
    if (t<=13) {
        if (t % 2) {
            totalstr = [NSString stringWithFormat:@"%d  ,%@ %@", t, @"小", @"双"];
        } else {
            totalstr = [NSString stringWithFormat:@"%d  ,%@ %@", t, @"小", @"单"];
        }
        
    } else {
        if (t % 2) {
            totalstr = [NSString stringWithFormat:@"%d  ,%@ %@", t, @"大", @"双"];
        } else {
            totalstr = [NSString stringWithFormat:@"%d  ,%@ %@", t, @"大", @"单"];
        }
    }
    
    NSString *bose = @"";
    if (t == 0 || t == 13 || t == 14 || t ==27) {
        bose = @"-";
    } else if (t == 1 || t == 4 || t == 7 || t ==10 || t == 16 || t == 19) {
        bose = @"绿波";
    } else  if (t == 2 || t == 5 || t == 8 || t ==11 || t == 17 || t == 20){
        bose = @"蓝波";
    } else {
        bose = @"红波";
    }
    
    if (block) {
        block(totalstr, bose);
    }
}


+ (void)getChongqingshishi:(NSString *)result returnBolck:(void (^)(NSString * _Nonnull, NSString * _Nonnull))block {
    
    
}
@end
