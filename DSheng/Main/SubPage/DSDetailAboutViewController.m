//
//  DSDetailAboutViewController.m
//  DSheng
//
//  Created by works_yip on 2020/4/9.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSDetailAboutViewController.h"

@interface DSDetailAboutViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *myWebV;

@end

@implementation DSDetailAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadAboutTxt];
    
    self.navigationItem.title = [[self getFileName:_type] stringByReplacingOccurrencesOfString:@".txt" withString:@""];
}

- (NSString *)getFileName:(NSInteger)type {
    NSString *name = @"";
    switch (type) {
        case 1:
            name = @"服务协议.txt";
            break;
        case 2:
            name = @"隐私策略.txt";
            break;
        case 3:
            name = @"关于我们.txt";
            break;
        default:
            break;
    }
    
    return name;
    
}


- (void)loadAboutTxt {
    
    NSString *filename = [self getFileName:_type];
    // 创建URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    
    // 创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 通过url加载文件
    [_myWebV loadRequest:request];
    
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
