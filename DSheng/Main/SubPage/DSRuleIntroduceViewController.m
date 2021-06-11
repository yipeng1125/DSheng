//
//  DSRuleIntroduceViewController.m
//  DSheng
//
//  Created by works_yip on 2020/4/4.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSRuleIntroduceViewController.h"

@interface DSRuleIntroduceViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *myWebview;
@end

@implementation DSRuleIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"规则说明";

    
    [self loadRuleTxt];
}

- (NSString *)getFileName:(DSLotteryTicketType)type {
    NSString *name = @"";
    switch (type) {
        case DSLotteryTicketType_sanfencai:
            name = @"三分彩规则.txt";
            break;
        case DSLotteryTicketType_sanfenPKcai:
            name = @"三分PK拾规.txt";
            break;
        case DSLotteryTicketType_beijingPKcai:
            //            name = @"北京PK拾";
            name = @"五分彩.txt";
            break;
        case DSLotteryTicketType_PCdandan:
            name = @"PC蛋蛋.txt";
            break;
        case DSLotteryTicketType_cqsscai:
            //            name = @"重庆时时彩";
            name = @"七分彩.txt";
            break;
        case DSLotteryTicketType_tjsscai:
            //            name = @"天津时时彩";
            name = @"十分彩.txt";
            break;
        case DSLotteryTicketType_jslhcai:
            name = @"六合彩规则说明.txt";
            break;
        case DSLotteryTicketType_lhcai:
            name = @"六合彩规则说明.txt";
            break;
            
        default:
            break;
    }
    
    return name;
    
}


- (void)loadRuleTxt {
    
    NSString *filename = [self getFileName:_ltType];
    // 创建URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    
    // 创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 通过url加载文件
    [_myWebview loadRequest:request];
    
//    NSString *contents = [NSString stringWithContentsOfFile:url.path encoding:NSUTF8StringEncoding error:nil];
//
//    //如果不是 则进行GBK编码再解码一次
//    if (!contents) {
//        contents =[NSString stringWithContentsOfFile:url.path encoding:0x80000632 error:nil];
//    }
//
//    //不行用GB18030编码再解码一次
//    if (!contents) {
//        contents =[NSString stringWithContentsOfFile:url.path encoding:0x80000631 error:nil];
//    }
//
//    if (contents) {
//        [_myWebview loadHTMLString:contents baseURL:nil];
//        return;
//    } else {
//        [_myWebview loadRequest:request];
//    }
}







//- (void)


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
