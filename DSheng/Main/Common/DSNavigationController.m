

#import "DSCommonHeader.h"
#import "DSNavigationController.h"
#import "DSViewHeader.h"
#import "DSCommonTool.h"
#import "DSChooseLotteryticketViewController.h"





@interface DSNavigationController () {
    __weak UIImageView *navigationImageView;
}

@end

@implementation DSNavigationController

+ (void)initialize
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blueColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];

    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBarTintColor:DSColor(236, 107, 44)];
    [self.navigationBar setBackgroundColor:DSColor(236, 107, 44)];

//    self.navigationBar.hidden = YES;
//    [self.navigationBar setBarTintColor:UIColor.redColor];
    
    self.navigationController.navigationBar.translucent =NO;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.whiteColor};
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        /* 设置导航栏上面的内容 */
        // 设置左边的按钮
        viewController.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
        
        
        // 设置右边的按钮
        viewController.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
        
    }
    
    if ([viewController isKindOfClass:[DSChooseLotteryticketViewController class]]) {
        DSChooseLotteryticketViewController *ltVC = (DSChooseLotteryticketViewController *)viewController;
        NSString *title = [ltVC getTopTitleStringWithType:ltVC.detailType];
        [self setupViewController:ltVC navigationBar:title];
    } else {
        if (navigationImageView) {
            [navigationImageView removeFromSuperview];
        }
    }
    
    [super pushViewController:viewController animated:animated];
}


- (void)setupViewController:(UIViewController *)vc navigationBar:(NSString *)title  {
    
    UIView *contentView;
    for (UIView *view in self.navigationBar.subviews) {
        NSLog(@"view : %@", view);
        
        if ([NSStringFromClass(view.class) isEqualToString:@"_UINavigationBarContentView"]) {
            contentView = view;
            
            //            for (UIView *cv in contentView.subviews) {
            //                NSLog(@"child :%@", cv);
            //                if ([NSStringFromClass(cv.class) isEqualToString:@"UILabel"]) {
            //
            //                    labelV = cv;
            //                    break;
            //                }
            //
            //            }
            break;
        }
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topTitleClick:)];
    UIImage *image = [UIImage imageNamed:@"jiantou"];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:image];
    imgV.width = 15;
    imgV.height = 15;
    imgV.centerY = contentView.centerY;
    imgV.userInteractionEnabled = YES;
    [imgV addGestureRecognizer:tapGesture];
    
    UIFont *font = [UIFont systemFontOfSize:17.0];
    CGRect rect = [DSCommonTool getStringRect:title withFont:font];
    imgV.x = contentView.centerX +  rect.size.width * 0.5 + 2;
    [imgV addGestureRecognizer:tapGesture];
    
    navigationImageView = imgV;
    
    
    [contentView addSubview:imgV];
    
}

- (void)back
{
#warning 这里要用self，不是self.navigationController
    
    if (navigationImageView) {
        [navigationImageView removeFromSuperview];
    }
    
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
    
    NSLog(@"%@", self.childViewControllers);
    [self popViewControllerAnimated:YES];

    
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}



- (void)topTitleClick:(id)sender {
    if (self.tdelegate && [self.tdelegate respondsToSelector:@selector(topViewClicked:)]) {
        [self.tdelegate topViewClicked:sender];
    }
}



/**
 *  创建一个item
 *
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
