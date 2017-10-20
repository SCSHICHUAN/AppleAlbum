//
//  TableViewCell.h
//  PhotoOC
//
//  Created by SHICHUAN on 2017/10/19.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
+(TableViewCell *)tableView:(UITableView *)tableView;
@property(nonatomic,strong)NSDictionary *groupDict;
@end
