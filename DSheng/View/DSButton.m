//
//  DSButton.m
//  DSheng
//
//  Created by works_yip on 2020/3/10.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSButton.h"
#import "DSCommonHeader.h"
#import <UIKit/UIKit.h>

@implementation DSButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}



+ (DSButton *)makeSpecialTypeButtonWithTitle:(NSString *)title {
    
    DSButton *btn = [[DSButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.layer.cornerRadius = 16;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

    
    return btn;
}


-(void)setSelected:(BOOL)selected {
    if (selected) {
        [self setBackgroundColor:DSColor(236, 107, 44)];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    [super setSelected:selected];
}

@end