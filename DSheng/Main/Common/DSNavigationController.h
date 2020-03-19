

#import <UIKit/UIKit.h>

@protocol DSNavigationBarDelegate <NSObject>

@required
- (void)topViewClicked:(id)sender;

@end

@interface DSNavigationController : UINavigationController

@property(nonatomic, assign) id<DSNavigationBarDelegate> tdelegate;

@end



