//
//  DSAboutViewController.m
//  DSheng
//
//  Created by works_yip on 2020/4/15.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSAboutViewController.h"

@interface DSAboutViewController ()

@end

@implementation DSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"关于我们";

    self.navigationController.navigationBar.hidden = NO;
    
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
