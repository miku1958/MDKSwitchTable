//
//  MDKSwitchTableHeaderViewCell.m
//  
//
//  Created by mikun on 2017/10/25.
//  Copyright © 2017年 MDK. All rights reserved.
//

#import "MDKSwitchTableHeaderViewCell.h"
void autolayoutEqualZero(UIView *view){
	view.translatesAutoresizingMaskIntoConstraints = NO;

	[view.superview addConstraints:[NSLayoutConstraint
									constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
									options:0
									metrics:nil
									views:@{@"view":view}]];
	[view.superview addConstraints:[NSLayoutConstraint
									constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
									options:0
									metrics:nil
									views:@{@"view":view}]];
}
NSString * const MDKSwitchTableHeaderViewCellIdentifer = @"MDKSwitchTableHeaderViewCell";
@implementation MDKSwitchTableHeaderViewCell
-(instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		_textLabel = [[UILabel alloc]init];
		[self addSubview:_textLabel];
		_textLabel.textAlignment = NSTextAlignmentCenter;

		autolayoutEqualZero(_textLabel);

	}
	return self;
}

@end
