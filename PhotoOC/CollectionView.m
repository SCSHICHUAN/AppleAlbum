//
//  CollectionView.m
//  PhotoOC
//
//  Created by SHICHUAN on 2017/10/19.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import "CollectionView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#include "FullPhoto.h"

static NSString *cellIdentifier = @"cellIdentifier";
@interface CollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *photoArray;
@end

@implementation CollectionView
-(UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _collectionView.backgroundColor= [UIColor whiteColor];
        _collectionView.allowsMultipleSelection = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
-(NSMutableArray *)photoArray
{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    for (ALAsset *asset in self.assetArray) {
       //这里尽量不用thumbnail属性，因为太模糊了，可以用aspectRatioThumbnail比例缩略图代替
        UIImage *fullScreenImage = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
        [self.photoArray addObject:fullScreenImage];
    }
    
    
    
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //cell重用
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    UIImage *fullScreenImage = self.photoArray[indexPath.item];
    
    //设置背景视图
    UIImageView *imageView = [[UIImageView alloc] initWithImage:fullScreenImage];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    cell.backgroundView = imageView;
    //设置被选中后的背景视图
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ms_overlay"]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //获取返选的originalImage
   
    
    //从originalImages中将originalImage移除
    
    
  
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FullPhoto *fullPhtot = [[FullPhoto alloc] init];
    fullPhtot.assetArray = self.assetArray;
    fullPhtot.indexPath = indexPath;
    [self.navigationController pushViewController:fullPhtot animated:YES];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-3)/4.0, ([UIScreen mainScreen].bounds.size.width-3)/4.0);
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0,0,0, 0);
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}



@end
