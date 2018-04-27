//
//  MDKSwitchTableMidCell.h
//  
//
//  Created by mikun on 2017/10/25.
//  Copyright © 2017年 MDK. All rights reserved.
//MDKSwitchTableView显示的cell,本质是table

#import <UIKit/UIKit.h>
#import "MDKSwitchTableDelegate.h"
extern NSString * const MDKSwitchTableMidCellIdentifer;

@interface MDKSwitchTableMidCell : UICollectionViewCell

@property (nonatomic,assign)NSUInteger tableIndex;
@property (nonatomic,weak)id<MDKSwitchTableDelegate> delegate;
@property (nonatomic,weak)id<MDKSwitchScrollDelegate> scrollDelegate;
- (UITableView *)table;
@end
