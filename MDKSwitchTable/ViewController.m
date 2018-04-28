//
//  ViewController.m
//  MDKSwitchTable
//
//  Created by mikun on 2018/4/27.
//  Copyright © 2018年 mdk. All rights reserved.
//

#import "ViewController.h"
#import "MDKSwitchTableView.h"
@interface ViewController ()<MDKSwitchTableDelegate>
@property (nonatomic,strong)MDKSwitchTableView *switchTable;
@property (nonatomic,strong)NSArray<NSString *> *midSwitchTitleArr;
@property (nonatomic,strong)NSArray<NSArray<NSString *> *> *midSwitchDataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	MDKSwitchTopSelectViewOption *option = [[MDKSwitchTopSelectViewOption alloc]init];
	option.itemTextColor = [UIColor greenColor];
	option.itemSelectedTextColor = [UIColor redColor];
	_switchTable = [[MDKSwitchTableView alloc]initWithOption:option];
	[self.view addSubview:_switchTable];

	_switchTable.frame = self.view.bounds;
	_switchTable.delegate = self;

	_switchTable.headerView = [[UIView alloc]initWithFrame:(CGRect){{0, 0}, _switchTable.frame.size.width, 200}];
	_switchTable.headerView.backgroundColor = [UIColor grayColor];
	[self loadData];
}
- (void)loadData{
	_midSwitchTitleArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"midSwitchTitleArr" ofType:@"plist"]];

	NSArray<NSDictionary *> *allArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"midSwitchDataArr" ofType:@"plist"]];

	NSMutableArray *arr = @[].mutableCopy;

	[_midSwitchTitleArr enumerateObjectsUsingBlock:^(NSString * dept, NSUInteger idx, BOOL *stop) {

		__block NSMutableArray *singleArr = @[].mutableCopy;
		if ([dept isEqualToString:@"所有部门"]) {
			[allArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				[singleArr addObject:obj[@"JobName"]];
			}];
		}else{
			[allArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
				if ([obj[@"DeptName"] isEqualToString:dept]) {
					[singleArr addObject:obj[@"JobName"]];
				}
			}];
		}

		[arr addObject:singleArr.copy];
	}];
	_midSwitchDataArr = arr.copy;

	[_switchTable reloadData];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


- (NSInteger)MDKSwitchNumberOfSection {
	return _midSwitchTitleArr.count;
}

- (void)MDKSwitchRegisterCellForTable:(UITableView *)midTable ofIndex:(NSUInteger)index {
	[midTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (UITableViewCell *)MDKSwitchTable:(UITableView *)midTable ofIndex:(NSUInteger)index cellAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [midTable dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	cell.textLabel.text = _midSwitchDataArr[index][indexPath.row];
	return cell;
}

- (void)MDKSwitchTable:(UITableView *)midTable ofIndex:(NSUInteger)index didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)MDKSwitchTable:(UITableView *)midTable ofIndex:(NSUInteger)index heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (NSInteger)MDKSwitchTable:(UITableView *)midTable ofIndex:(NSUInteger)index numberOfRowsInSection:(NSInteger)section {
	return _midSwitchDataArr[index].count;
}

- (NSString *)MDKSwitchTitleOfSectionInHeader:(NSInteger)section {
	return _midSwitchTitleArr[section];
}


@end
