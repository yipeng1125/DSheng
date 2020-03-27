//
//  DSScanPayViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/23.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSScanPayViewController.h"
#import "DSLabel.h"
#import "TRCustomAlert.h"

@interface DSScanPayViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet DSLabel *nameLabel;
@end

@implementation DSScanPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self pressAction];
    [self setupView];
}

- (void)setupView {
    
    if (_type == 1) {
        self.navigationItem.title = @"微信扫码支付";
        _nameLabel.text = [NSString stringWithFormat:@"微信账号: %@\r\n微信昵称: %@", @"123", @"456"];
    } else {
        self.navigationItem.title = @"支付宝扫码支付";
        _nameLabel.text = [NSString stringWithFormat:@"支付宝账号: %@\r\n支付宝昵称: %@", @"abc", @"efg"];

    }
}


- (IBAction)saveAction:(id)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.myImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

// 初始化设置
- (void)pressAction {
    _nameLabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 1;
    [_nameLabel addGestureRecognizer:longPress];
}

// 使label能够成为响应事件
- (BOOL)canBecomeFirstResponder {
    return YES;
}
// 控制响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return action == @selector(customCopy:);
}

- (void)customCopy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _nameLabel.text;
}

- (void)longPressAction:(UIGestureRecognizer *)recognizer {
    
    [self becomeFirstResponder];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(customCopy:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyItem, nil]];
    CGRect rect = _nameLabel.frame;
    rect.size.width = 80;
    rect.size.height = 30;
    [[UIMenuController sharedMenuController] setTargetRect:rect inView:_nameLabel.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}




#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    [TRCustomAlert showMessage:msg image:nil];
}

@end
