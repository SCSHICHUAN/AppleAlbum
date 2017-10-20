//
//  FullPhoto.m
//  PhotoOC
//
//  Created by SHICHUAN on 2017/10/19.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import "FullPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define with ([UIScreen mainScreen].bounds.size.width)
#define hight ([UIScreen mainScreen].bounds.size.height)

@interface FullPhoto ()<UIScrollViewDelegate>
{
    int Direction;//通过观察者scrollView，判断用户是左划，右划动
    int Pos;      //记录用户划动了多少页
    ALAsset *CurrentAsset; //记录同一个对象，如果是不添加imageView
   
}
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *imageView1;
@property(nonatomic,strong)UIImageView *imageView2;
@property(nonatomic,strong)NSMutableArray<UIImage*>* images;
@end

@implementation FullPhoto
-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,-64, with+20, hight)];
        _scrollView.contentSize = CGSizeMake(with*2+44, 0);
        _scrollView.showsVerticalScrollIndicator = FALSE;
        _scrollView.showsHorizontalScrollIndicator = FALSE;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}
-(UIImageView *)imageView1
{
    if (_imageView1 == nil) {
        _imageView1 = [[UIImageView alloc] init];
        _imageView1.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView1;
}
-(UIImageView *)imageView2
{
    if (_imageView2 == nil) {
        _imageView2 = [[UIImageView alloc] init];
        _imageView2.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    Pos = 0;
    Direction = 2;
    //添加观察者
   [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    
    
    
    if (self.assetArray.count ==1) {
        ALAsset *asset = self.assetArray[self.indexPath.item];
        
        UIImage * image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        self.imageView1.frame =  CGRectMake(0, 0, with, hight);
        self.imageView1.image = image;
        [self.view addSubview:self.imageView1];
   
        //处理最后一个
    }else if (self.indexPath.item+1 == self.assetArray.count) {
        Pos =-1;
      
        self.scrollView.contentOffset = CGPointMake(with+20, 0);

        ALAsset *asset = self.assetArray[self.indexPath.item-1];

        UIImage * image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        self.imageView1.frame =  CGRectMake(0, 0, with, hight);
        self.imageView1.image = image;
        [self.scrollView addSubview:self.imageView1];
        [self.view addSubview:self.scrollView];


        ALAsset *asset1 = self.assetArray[self.indexPath.item];

        UIImage * image1 = [UIImage imageWithCGImage:asset1.defaultRepresentation.fullScreenImage];
        self.imageView2.frame =  CGRectMake(with+20, 0, with, hight);
        self.imageView2.image = image1;
        [self.scrollView addSubview:self.imageView2];
        [self.view addSubview:self.scrollView];
        
        
    }else{
        
        ALAsset *asset = self.assetArray[self.indexPath.item];
        
        UIImage * image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        self.imageView1.frame =  CGRectMake(0, 0, with, hight);
        self.imageView1.image = image;
        [self.scrollView addSubview:self.imageView1];
        [self.view addSubview:self.scrollView];
    }
    

    
    
    

}
//观察者实现方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{

//  NSLog(@"self.scrollView.contentOffset.x = [ %f ]",self.scrollView.contentOffset.x);
//  NSLog(@"with+20= [ %f ]",with+20);

    if (self.scrollView.contentOffset.x > 0 ) {
        Direction = 1;
    }else if(self.scrollView.contentOffset.x ){
        Direction = 0;
    }
//
//   NSLog(@"Direction = [ %d ]",Direction);

    
    
   
    [self showPhoto];
    
    
    
}
-(void)showPhoto
{
    
    NSLog(@"self.indexPath.item+Pos= [ %ld ]",self.indexPath.item+Pos);
    NSLog(@"self.assetArray.count= [ %lu ]",(unsigned long)self.assetArray.count);
    
    
    
    
    if (self.assetArray.count >=2) {
       
        //用户向右滑动
        if (Direction == 1 && self.indexPath.item+Pos+2 <= self.assetArray.count){
            ALAsset *asset =  self.assetArray[self.indexPath.item+Pos];
            //防止多次走这里
            if (Direction == 1 && (CurrentAsset != asset)) {
                
                
                
                CurrentAsset = asset;
                
                
                UIImage * image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                self.imageView1.frame = CGRectMake(0, 0, with, hight);
                self.imageView1.image = image;
                [self.scrollView addSubview:self.imageView1];
                
                
                
                
                ALAsset *asset1 =  self.assetArray[self.indexPath.item+Pos+1];
                UIImage * image1 = [UIImage imageWithCGImage:asset1.defaultRepresentation.fullScreenImage];
                self.imageView2.frame = CGRectMake(with+20, 0, with, hight);
                self.imageView2.image = image1;
                [self.scrollView addSubview:self.imageView2];
                
                
           //如果用户继续滑动向右超出了scrollView的范围
            }else if(self.scrollView.contentOffset.x > with+20){
                //如果用户滑动最后一张
                if ( self.indexPath.item+Pos+3 <= self.assetArray.count) {
                    //添加新的资源，
                    Pos ++;
                    //让scrollView归位，注意归位一定要在添加资源之后，然后重复以上代码
                    self.scrollView.contentOffset = CGPointMake(0, -64);
                    NSLog(@"pos= [ %d ]",Pos);
                }
                
            }
        }
        
        
          //用户向左滑动
         if(Direction == 0 && self.indexPath.item+Pos >= 1){

          


             ALAsset *asset =  self.assetArray[self.indexPath.item+Pos];
             
             if (Direction == 1 && (CurrentAsset != asset)) {
                 
                 
                 
                 CurrentAsset = asset;
                 
                 
                 UIImage * image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                 self.imageView1.frame = CGRectMake(0, 0, with, hight);
                 self.imageView1.image = image;
                 [self.scrollView addSubview:self.imageView1];
                 
                 
                 ALAsset *asset1 =  self.assetArray[self.indexPath.item+Pos+1];
                 UIImage * image1 = [UIImage imageWithCGImage:asset1.defaultRepresentation.fullScreenImage];
                 self.imageView2.frame = CGRectMake(with+20, 0, with, hight);
                 self.imageView2.image = image1;
                 [self.scrollView addSubview:self.imageView2];
                 
                 
                 
             }else if(self.scrollView.contentOffset.x <  0){
                 
                 Pos --;
                 NSLog(@"pos= [ %d ]",Pos);
                 self.scrollView.contentOffset = CGPointMake(with+20, -64);
                 
             }


            


        }






    }
}
// ARC模式下 释放观察者
-(void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}



@end







