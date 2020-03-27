//
//  DSCollectionViewCell.h
//  TestDemo2
//
//  Created by works_yip on 2020/3/14.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+ (instancetype)cellWithTableView:(UICollectionView *)collectionView withIdentifyid:(NSString *)identifyid indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
