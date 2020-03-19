//
//  DSTrendViewController.m
//  DSheng
//
//  Created by works_yip on 2020/3/7.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSTrendViewController.h"
#import "DSCommonHeader.h"
#import "DSCollectionViewCell.h"

@interface DSTrendViewController ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    UICollectionView *mycollectionView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
@end

@implementation DSTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"走势";
    mycollectionView = [self makeCollectionView];
    mycollectionView.frame = _contentView.bounds;
    
    [mycollectionView registerNib:[UINib nibWithNibName:@"DSCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DSCollectionViewCell"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);//每个区的空隙
    layout.minimumInteritemSpacing = 1; //列与列之间的间距
    layout.minimumLineSpacing = 5;//行与行之间的间距
    
    [mycollectionView setCollectionViewLayout:layout];
    
    [_contentView addSubview:mycollectionView];
    _contentView.contentSize = CGSizeMake(DSScreenSize.width, mycollectionView.height);

}

- (UICollectionView *)makeCollectionView {
    if (!mycollectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);//每个区的空隙
        layout.minimumInteritemSpacing = 10; //列与列之间的间距
        layout.minimumLineSpacing = 10;//行与行之间的间距
        layout.itemSize = CGSizeMake((DSScreenSize.width - 10)/2, 200);//cell的大小
        
        mycollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        mycollectionView.backgroundColor = [UIColor whiteColor];
        mycollectionView.delegate = self;
        mycollectionView.dataSource = self;
        [mycollectionView registerClass:[DSCollectionViewCell class] forCellWithReuseIdentifier:@"DSCollectionViewCell"];
    }
    return mycollectionView;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

double posizitionY= 0.0;


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identyfier = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.row, (long)indexPath.section];
    DSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DSCollectionViewCell" forIndexPath:indexPath];
    [cell setBackgroundColor:UIColor.whiteColor];
    
    
    
    CGRect rt = cell.frame;
    
    double wd = DSScreenSize.width/6.0;
    posizitionY = indexPath.section * (wd * 0.5 + 0.25);
    double posizitionX = indexPath.row * (wd + 0.25);
    
    
    NSLog(@"str:%@", identyfier);
    
    rt.size.height = wd * 0.5;
    rt.size.width =  wd;
    rt.origin.y = posizitionY;
    rt.origin.x = posizitionX;
    cell.frame = rt;
    
    
    cell.contentLabel.textColor = UIColor.blackColor;
    cell.contentLabel.text = identyfier;
    
    cell.contentLabel.layer.borderWidth = 0.25;
    cell.contentLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    cell.contentLabel.layer.masksToBounds = YES;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"click : %@", indexPath);
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
