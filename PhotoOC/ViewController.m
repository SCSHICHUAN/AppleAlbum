//
//  ViewController.m
//  PhotoOC
//
//  Created by SHICHUAN on 2017/10/18.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import "ViewController.h"
#include "TableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CollectionView.h"



@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int i;
    int j;
    UIImage *fullScreenImage;
}

@property(nonatomic,strong)ALAssetsLibrary *assetsLibrary;
@property(nonatomic,strong)UITableView *tableView;
- (IBAction)showIPhoneData:(UIBarButtonItem *)sender;
@property(nonatomic,strong)NSMutableArray *groupArray;
@end

@implementation ViewController


- (ALAssetsLibrary *)assetsLibrary
{
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}
-(NSMutableArray *)groupArray
{
    if (_groupArray == nil) {
        _groupArray = [NSMutableArray array];
    }
    return _groupArray;
}
-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 107;
    }
    return _tableView;
}

- (IBAction)showIPhoneData:(UIBarButtonItem *)sender {
    
    //遍历相册组
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
            if (group.numberOfAssets>0) {
                NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
                long groupCount = group.numberOfAssets;
                UIImage *image = [UIImage imageWithCGImage:group.posterImage];
                NSLog(@"name= [ %@ ] groupCount = [%lu] image = [%@]",name,groupCount,image);
               
                
                i = 0;
                //遍历相册,为了获取高清封面
                [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                    if (asset && i == 0) {
                         //这里尽量不用thumbnail属性，因为太模糊了，可以用aspectRatioThumbnail比例缩略图代替
                        fullScreenImage = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
                        
                        i++;
                    }
                    NSLog(@"ee= [ %d ]",j++);
                }];
                
               NSDictionary *dict = @{@"name":name,
                                       @"groupCount":[NSString stringWithFormat:@"%lu",groupCount],
                                       @"image":fullScreenImage,
                                       @"group":group
                                       };
                [self.groupArray addObject:dict];
            }
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"error= [ %@ ]",error);
    }];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"苹果资源";
    [self.view addSubview:self.tableView];
    [self showIPhoneData:nil];
}



#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [TableViewCell tableView:tableView];
    cell.groupDict = self.groupArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    ALAssetsGroup *group = self.groupArray[indexPath.row][@"group"];
    NSLog(@"group= [ %@ ]",group);
    NSMutableArray *array = [NSMutableArray array];
    //遍历相册
    [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
       
        if (asset) {
            [array addObject:asset];
        }
        
        NSLog(@"ee= [ %d ]",j++);
    }];
    
    
    
    CollectionView *cocView = [[CollectionView alloc] init];
    cocView.assetArray = array;
    [self.navigationController pushViewController:cocView animated:YES];
}



    


@end
