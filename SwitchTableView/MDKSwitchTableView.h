//
//  MDKSwitchTableView.h
//
//
//  Created by mikun on 2017/10/25.
//  Copyright © 2017年 MDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDKSwitchTableDelegate.h"
@interface MDKSwitchTopSelectViewOption:NSObject

///topSelectView 的高度
@property (nonatomic,assign)CGFloat viewHeight;
///topSelectView 内部cell 的 EdgeInset
@property (nonatomic,assign)UIEdgeInsets cellContentInset;
///topSelectView 内部cell 的 间距
@property (nonatomic,assign)CGFloat cellSpacing;

@property (nonatomic,strong)UIFont *itemTextFont;

@property (nonatomic,strong)UIColor *itemTextColor;
@property (nonatomic,strong)UIColor *itemSelectedTextColor;

@property (nonatomic,strong)UIColor *itemBackgroundColor;
@property (nonatomic,strong)UIColor *itemSelectedBackgroundColor;

@property (nonatomic,strong)UIColor *bottomLineColor;
@end

@interface MDKSwitchTableView : UIView

-(instancetype)initWithOption:(MDKSwitchTopSelectViewOption *)option;

///topSelectView 距离顶部的高度
@property (nonatomic,strong)UIView *headerView;

@property (nonatomic,strong)MDKSwitchTopSelectViewOption *topSelectViewOption;

@property (readonly,assign)NSUInteger topSelectViewShowingIndex;
@property (readonly,assign)NSUInteger midTableSelectedIndex;

@property (nonatomic,readonly)UITableView *currentSwitchTable;

@property (nonatomic,weak)id<MDKSwitchTableDelegate> delegate;
@property (nonatomic,weak)id<MDKSwitchScrollDelegate> scrollDelegate;
- (void)reloadData;
@end
