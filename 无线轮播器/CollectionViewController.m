//
//  CollectionViewController.m
//  无线轮播器
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *followLayout;

@property(nonatomic,strong)NSMutableArray * nmArray;



@end

@implementation CollectionViewController

//数据数组
-(NSMutableArray *)nmArray{
    if (_nmArray == nil) {
        _nmArray = [NSMutableArray array];
        for (int i = 0; i<4; i++) {
            UILabel * lb = [UILabel new];
            
            lb.backgroundColor = [UIColor redColor];
            lb.text = [NSString stringWithFormat:@"这是第%zd个item",i+1];
            [lb sizeToFit];
            [_nmArray addObject:lb];
        }
    }
    return _nmArray;
}

static NSString * const reuseIdentifier = @"Cell";

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.followLayout.itemSize = CGSizeMake(SCREEN_W, SCREEN_H);
    self.followLayout.minimumLineSpacing = 0;
    self.collectionView.pagingEnabled = YES;
    
//定时器执行自动轮播
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scrollToNext) userInfo:nil repeats:YES];
    
    //程序运行的时候无动画到第二组
    NSIndexPath * centerIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.collectionView scrollToItemAtIndexPath:centerIndex atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
}

//轮播方法
-(void)scrollToNext{
    //1.计算当前滚动到第几页来了吧
    NSInteger index = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    
    //2.取模,获取当前索引的下一个
    NSInteger currentPage = index % 4 + 1;
    
    if (currentPage == 4) {
        currentPage = 0;
    }
    
    //3.回到中间那组对应的item索引
    NSIndexPath *centerIndex = [NSIndexPath indexPathForItem:currentPage inSection:1];

 
        [self.collectionView scrollToItemAtIndexPath:centerIndex atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
   }



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:(CGFloat)arc4random_uniform(256)/255 green:(CGFloat)arc4random_uniform(256)/255 blue:(CGFloat)arc4random_uniform(256)/255 alpha:1.0];
    
    [cell addSubview:self.nmArray[indexPath.row]];
    
    return cell;
}

//隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
