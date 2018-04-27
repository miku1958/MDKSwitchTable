//
//  MDKSwitchTableDelegate.h
//  
//
//  Created by mikun on 2017/11/28.
//  Copyright © 2017年 MDK. All rights reserved.
//

@protocol MDKSwitchTableDelegate<NSObject>
@required
-(NSInteger)MDKSwitchNumberOfSection;
-(NSString*)MDKSwitchTitleOfSectionInHeader:(NSInteger)section;


-(void)MDKSwitchRegisterCellForTable:(UITableView *)midTable ofIndex:(NSUInteger)index;

-(NSInteger)MDKSwitchTable:(UITableView *)midTable ofIndex:(NSUInteger)index numberOfRowsInSection:(NSInteger)section;

-(CGFloat)MDKSwitchTable:(UITableView *)midTable ofIndex:(NSUInteger)index heightForRowAtIndexPath:(NSIndexPath *)indexPath;

-(UITableViewCell *)MDKSwitchTable:(UITableView *)midTable ofIndex:(NSUInteger)index cellAtIndexPath:(NSIndexPath *)indexPath;

-(void)MDKSwitchTable:(UITableView *)midTable ofIndex:(NSUInteger)index didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol MDKSwitchScrollDelegate<NSObject>
- (void)MDKSwitchTableDidScroll:(UIScrollView *)table;
- (void)MDKSwitchTableDidStop:(UIScrollView *)table fromDragging:(BOOL)fromDragging;
@end


