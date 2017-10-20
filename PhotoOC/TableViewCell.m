//
//  TableViewCell.m
//  PhotoOC
//
//  Created by SHICHUAN on 2017/10/19.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import "TableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface TableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLable;
@property (weak, nonatomic) IBOutlet UILabel *groupLableCount;
@property (nonatomic, strong) ALAsset *asset;
@end



@implementation TableViewCell

+(TableViewCell *)tableView:(UITableView *)tableView
{
    static NSString *str;
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:nil options:nil].firstObject;
    }
    return cell;
}


-(void)setGroupDict:(NSDictionary *)groupDict
{
    _groupDict = groupDict;
    self.groupImageView.image = groupDict[@"image"];
    self.groupNameLable.text = groupDict[@"name"];
    self.groupLableCount.text = groupDict[@"groupCount"];

}


@end
