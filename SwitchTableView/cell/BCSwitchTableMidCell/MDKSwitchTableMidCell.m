//
//  MDKSwitchTableMidCell.m
//  
//
//  Created by mikun on 2017/10/25.
//  Copyright © 2017年 MDK. All rights reserved.
//

#import "MDKSwitchTableMidCell.h"
extern void autolayoutEqualZero(UIView *view);
NSString * const MDKSwitchTableMidCellIdentifer = @"MDKSwitchTableMidCell";

@interface MDKSwitchTableMidCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *table;
@end
@implementation MDKSwitchTableMidCell
-(instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		_table = [[UITableView alloc]init];
		[self addSubview:_table];
		
		_table.dataSource = self;
		_table.delegate = self;
		_table.showsVerticalScrollIndicator = NO;
		_table.showsHorizontalScrollIndicator = NO;
		
		_table.separatorStyle = UITableViewCellSeparatorStyleNone;
		autolayoutEqualZero(_table);

	}
	return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if ([_delegate respondsToSelector:@selector(MDKSwitchTable:ofIndex:numberOfRowsInSection:)]) {
		return [_delegate MDKSwitchTable:tableView ofIndex:_tableIndex numberOfRowsInSection:section];
	}
	return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([_delegate respondsToSelector:@selector(MDKSwitchTable:ofIndex:heightForRowAtIndexPath:)]) {
		return [_delegate MDKSwitchTable:tableView ofIndex:_tableIndex heightForRowAtIndexPath:indexPath];
	}
	return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([_delegate respondsToSelector:@selector(MDKSwitchTable:ofIndex:cellAtIndexPath:)]) {
		return [_delegate MDKSwitchTable:tableView ofIndex:_tableIndex cellAtIndexPath:indexPath];
	}
	return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if ([_delegate respondsToSelector:@selector(MDKSwitchTable:ofIndex:didSelectRowAtIndexPath:)]) {
		[_delegate MDKSwitchTable:tableView ofIndex:_tableIndex didSelectRowAtIndexPath:indexPath];
	}
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_table != scrollView) { return; }

	if ([_scrollDelegate respondsToSelector:@selector(MDKSwitchTableDidScroll:)]) {
		[_scrollDelegate MDKSwitchTableDidScroll:_table];
	}
}

//代码滚动scrollview后停止会来到这里
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
	if ([_scrollDelegate respondsToSelector:@selector(MDKSwitchTableDidStop:fromDragging:)]) {
		[_scrollDelegate MDKSwitchTableDidStop:scrollView fromDragging:NO];
	}
}


//用户手动滚回来到这里
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (!decelerate) {
		[self scrollViewDidEndDecelerating:scrollView];
	}
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	//如果上面的方法decelerate为YES才会来到这里
	if ([_scrollDelegate respondsToSelector:@selector(MDKSwitchTableDidStop:fromDragging:)]) {
		[_scrollDelegate MDKSwitchTableDidStop:scrollView fromDragging:YES];
	}
}
@end
