//
//  DSCollectionViewCell.m
//  TestDemo2
//
//  Created by works_yip on 2020/3/14.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSCollectionViewCell.h"

@implementation DSCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)init {
    
    self = [super init];
    if (self) {

        
    }
    
    return self;
}

+ (instancetype)cellWithTableView:(UICollectionView *)collectionView withIdentifyid:(NSString *)identifyid indexPath:(NSIndexPath *)indexPath {
    
    DSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifyid forIndexPath:indexPath];
    


    if (!cell) {
        NSArray * nibObjects = [[NSBundle mainBundle] loadNibNamed:@"DSCollectionViewCell" owner:nil options:nil];
        
        for (id obj in nibObjects) {
            if ([obj isKindOfClass:[DSCollectionViewCell class]]) {
                cell = obj;
                [cell setValue:identifyid forKey:@"reuseIdentifier"];
                break;
            }
        }
    }
    
    
    return cell;
}



@end
