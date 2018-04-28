//
//  MDKSwitchTableView.m
//  
//
//  Created by mikun on 2017/10/25.
//  Copyright © 2017年 MDK. All rights reserved.
//


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
#pragma clang diagnostic ignored "-Wprotocol"


#import "MDKSwitchTableView.h"
#import "MDKSwitchTableHeaderViewCell.h"
#import "MDKSwitchTableMidCell.h"

@implementation MDKSwitchTopSelectViewOption

- (instancetype)init
{
	self = [super init];
	if (self) {
		_viewHeight = 50;


		_cellSpacing = 0;

		_cellContentInset = UIEdgeInsetsZero;

		_itemTextFont = [UIFont systemFontOfSize:14];

		_itemTextColor = [UIColor blackColor];
		_itemSelectedTextColor = [UIColor redColor];

		_itemBackgroundColor = [UIColor whiteColor];
		_itemSelectedBackgroundColor = [UIColor whiteColor];

		_bottomLineColor = [UIColor blackColor];
	}
	return self;
}

@end

@interface MDKSwitchTableView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,MDKSwitchTableDelegate,MDKSwitchScrollDelegate>
@property (nonatomic,strong)UICollectionView *topSelectCollectionView;
@property (nonatomic,strong)UIView *topSelectBottomLineView;
@property (nonatomic,strong)UICollectionView *midCollectionView;

@property (nonatomic,weak)UITableView *midCurrentTable;
@property (nonatomic,strong)NSArray<__kindof UICollectionViewLayoutAttributes *> *headerCellAttributeArr;


@property (nonatomic,assign)BOOL topSelectViewCanScroll;


@property (nonatomic,strong)NSMutableArray<UITableView *(^)(void)> *tableWeakArr;
@property (nonatomic,assign)CGFloat currentOffsetY;

@end

@implementation MDKSwitchTableView

-(instancetype)initWithFrame:(CGRect)frame{
	return [self initWithOption:[[MDKSwitchTopSelectViewOption alloc]init] frame:frame];
}
-(instancetype)initWithOption:(MDKSwitchTopSelectViewOption *)option{
	return [self initWithOption:option frame:CGRectZero];
}
-(instancetype)initWithOption:(MDKSwitchTopSelectViewOption *)option frame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		[self initSelf];
		[self setTopSelectViewOption:option];
	}
	return self;
}
- (void)initSelf{
	[self initView];

	_tableWeakArr = @[].mutableCopy;

	_topSelectViewCanScroll = YES;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
	[super setBackgroundColor:backgroundColor];
	_midCollectionView.backgroundColor = backgroundColor;
}

- (void)initView{
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	_topSelectCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(1, _headerView.frame.size.height, 1, 1) collectionViewLayout:layout];
	[self addSubview:_topSelectCollectionView];
	_topSelectCollectionView.backgroundColor = [UIColor whiteColor];
	_topSelectCollectionView.dataSource = self;
	_topSelectCollectionView.delegate = self;
	_topSelectCollectionView.alwaysBounceHorizontal = YES;
	_topSelectCollectionView.showsVerticalScrollIndicator = NO;
	_topSelectCollectionView.showsHorizontalScrollIndicator = NO;
	[_topSelectCollectionView registerClass:[MDKSwitchTableHeaderViewCell class] forCellWithReuseIdentifier:MDKSwitchTableHeaderViewCellIdentifer];

	
	UICollectionViewFlowLayout *midLayout = [[UICollectionViewFlowLayout alloc]init];
	
	midLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	midLayout.minimumLineSpacing = 0;
	midLayout.minimumInteritemSpacing = 0;
	midLayout.sectionInset = UIEdgeInsetsZero;
	
	_midCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(1, 1, 1, 1) collectionViewLayout:midLayout];
	[self addSubview:_midCollectionView];
	
	_midCollectionView.backgroundColor = self.backgroundColor;
	_midCollectionView.dataSource = self;
	_midCollectionView.delegate = self;

	
	_midCollectionView.showsVerticalScrollIndicator = NO;
	_midCollectionView.showsHorizontalScrollIndicator = NO;
	
	_midCollectionView.pagingEnabled = YES;
	
	[_midCollectionView registerClass:[MDKSwitchTableMidCell class] forCellWithReuseIdentifier:MDKSwitchTableMidCellIdentifer];

	
	_topSelectBottomLineView = [[UIView alloc]init];
	[self addSubview:_topSelectBottomLineView];
	

	
	[self bringSubviewToFront:_topSelectCollectionView];
	[self bringSubviewToFront:_topSelectBottomLineView];
}

-(UITableView *)currentSwitchTable{
	MDKSwitchTableMidCell *midCell = [_midCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_midTableSelectedIndex inSection:0]];
	return midCell.table;
}

- (void)reloadData{
	[self layoutSubviews];
	[_topSelectCollectionView reloadData];
	[_midCollectionView reloadData];
}

-(void)setHeaderView:(UIView *)headerView{
	[_headerView removeFromSuperview];
	_headerView = headerView;
	[self addSubview:_headerView];
	if (_topSelectCollectionView.frame.size.width <2) {//代表还没有触发过 layoutsubview
		CGRect topFrame = _topSelectCollectionView.frame;
		topFrame.origin.y = _headerView.frame.size.height;
		_topSelectCollectionView.frame = topFrame;

		CGRect topLineFrame = _topSelectBottomLineView.frame;
		topLineFrame.origin.y = CGRectGetMaxY(_topSelectCollectionView.frame);
		_topSelectBottomLineView.frame = topLineFrame;
		[self layoutSubviews];
	}
}

-(void)setTopSelectViewOption:(MDKSwitchTopSelectViewOption *)topSelectViewOption{
	_topSelectViewOption = topSelectViewOption;
	UICollectionViewFlowLayout *layout = _topSelectCollectionView.collectionViewLayout;

	BOOL shouldResetMidLayout = layout.itemSize.height != _topSelectViewOption.viewHeight;
	layout.itemSize = CGSizeMake(50, _topSelectViewOption.viewHeight);
	if (shouldResetMidLayout) {
		[self resetMidLayout];
	}

	layout.sectionInset = _topSelectViewOption.cellContentInset;

	layout.minimumInteritemSpacing = _topSelectViewOption.cellSpacing;
	layout.minimumLineSpacing = _topSelectViewOption.cellSpacing;

	layout.sectionInset = UIEdgeInsetsMake(0, _topSelectViewOption.cellSpacing, 0, 0);

	_topSelectBottomLineView.backgroundColor = _topSelectViewOption.bottomLineColor;
}

-(void)layoutSubviews{
	[super layoutSubviews];
	_topSelectCollectionView.frame = (CGRect){{0, _topSelectCollectionView.frame.origin.y}, self.frame.size.width, _topSelectViewOption.viewHeight};

	_topSelectBottomLineView.frame = (CGRect){{0, _topSelectViewOption.viewHeight-1}, _topSelectCollectionView.frame.size.width, 1};

	_midCollectionView.frame = (CGRect){{0, _topSelectViewOption.viewHeight}, self.frame.size.width, self.frame.size.height - _topSelectViewOption.viewHeight};
	[self resetMidLayout];
}

- (void)resetMidLayout{
	if (_delegate) {//防止接着调用numberOfItemsInSection中返回0
		[_midCollectionView setNeedsLayout];
		[_midCollectionView layoutIfNeeded];
	}
	UICollectionViewFlowLayout *midlayout = _midCollectionView.collectionViewLayout;
	midlayout.itemSize = CGSizeMake(_midCollectionView.frame.size.width, _midCollectionView.frame.size.height);
	[_midCollectionView reloadData];
}


#pragma mark - headerCollection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	if ([_delegate respondsToSelector:@selector(MDKSwitchNumberOfSection)]) {
		return [_delegate MDKSwitchNumberOfSection];
	}
	return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	if (collectionView == _topSelectCollectionView) {
		MDKSwitchTableHeaderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDKSwitchTableHeaderViewCellIdentifer forIndexPath:indexPath];
		
		if ([_delegate respondsToSelector:@selector(MDKSwitchTitleOfSectionInHeader:)]) {
			cell.textLabel.text = [_delegate MDKSwitchTitleOfSectionInHeader:indexPath.item];
		}
		cell.textLabel.font = _topSelectViewOption.itemTextFont;
		
		//弄个变量记录是否被选中来决定颜色
		if (indexPath.item == _topSelectViewShowingIndex) {
			cell.textLabel.textColor = _topSelectViewOption.itemSelectedTextColor;
			cell.backgroundColor = _topSelectViewOption.itemSelectedBackgroundColor;
		}else{
			cell.textLabel.textColor = _topSelectViewOption.itemTextColor;
			cell.backgroundColor = _topSelectViewOption.itemBackgroundColor;
		}
		
		return cell;
	}else if(collectionView == _midCollectionView){
		MDKSwitchTableMidCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDKSwitchTableMidCellIdentifer forIndexPath:indexPath];
		cell.tableIndex = indexPath.item;

		if (_headerView.frame.size.height<1) {
			cell.table.tableHeaderView = nil;
		}else if (fabs(cell.table.tableHeaderView.frame.size.height - _headerView.frame.size.height)>1) {
			UIView *view = [[UIView alloc]initWithFrame:(CGRect){{0, 0}, 1, _headerView.frame.size.height}];
			cell.table.tableHeaderView = view;
		}
		BOOL unDisplay = NO;
		if (!cell.delegate) {
			unDisplay = YES;
			cell.delegate = _delegate;
			cell.scrollDelegate = self;
			if ([_delegate respondsToSelector:@selector(MDKSwitchRegisterCellForTable:ofIndex:)]) {
				[_delegate MDKSwitchRegisterCellForTable:cell.table ofIndex:cell.tableIndex];
			}
			__weak UITableView *weakTable = cell.table;
			[_tableWeakArr addObject:^ UITableView *{
				return weakTable;
			}];

		}

		[self updateMidCellTableContentOffsetY:cell.table];

		return cell;
	}
	
	return [[UICollectionViewCell alloc]init];
}
- (CGSize)text:(NSString *)text LabelSizeWith:(UIFont *)font{
	CGSize maxSize = (CGSize){CGFLOAT_MAX,CGFLOAT_MAX};
	UILabel *testlabel = [[UILabel alloc]init];
	testlabel.lineBreakMode = NSLineBreakByWordWrapping;
	testlabel.frame = (CGRect){{0, 0}, maxSize};
	testlabel.preferredMaxLayoutWidth = maxSize.width;
	testlabel.numberOfLines = 0;
	testlabel.font = font;
	testlabel.text = text;
	CGSize size = [testlabel sizeThatFits:maxSize];
	return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
	if (collectionView == _topSelectCollectionView) {
		if ([_delegate respondsToSelector:@selector(MDKSwitchTitleOfSectionInHeader:)]) {
			NSString *text = [_delegate MDKSwitchTitleOfSectionInHeader:indexPath.item];

			CGFloat textWidth =  [self text:text LabelSizeWith:_topSelectViewOption.itemTextFont].width;
			if ([layout isKindOfClass:UICollectionViewFlowLayout.class]) {
				return CGSizeMake(textWidth+28, (NSInteger)(layout.itemSize.height));
			}
		}
	}else if(collectionView == _midCollectionView){
		return collectionView.frame.size;
	}
	return CGSizeZero;
}

#pragma mark - 切换滚动
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	if (collectionView == _midCollectionView) { return; }


	UICollectionViewFlowLayout *midlayout = _midCollectionView.collectionViewLayout;

	_midTableSelectedIndex = indexPath.item;

    _topSelectViewShowingIndex = indexPath.item;
	[_topSelectCollectionView reloadData];
	_topSelectViewCanScroll = NO;
	[self updateHeaderSelected:_topSelectViewShowingIndex midViewOffset:midlayout.itemSize.width/2.0 scrollAnimation:YES];
	
	CGFloat offsetX = indexPath.item*midlayout.itemSize.width;

	CGPoint midOffset =  _midCollectionView.contentOffset;
	midOffset.x = offsetX;
	[_midCollectionView setContentOffset:midOffset animated:YES];

}

- (void)updateHeaderSelected:(NSUInteger)index midViewOffset:(CGFloat)offset scrollAnimation:(BOOL)animation{

	_topSelectViewShowingIndex = index;
	[_topSelectCollectionView reloadData];
	[_topSelectCollectionView layoutIfNeeded];
	if (_topSelectCollectionView.contentSize.width<_topSelectCollectionView.frame.size.width) { return; }
	
	if (!_headerCellAttributeArr) {
		UICollectionViewFlowLayout *headerLayout =  _topSelectCollectionView.collectionViewLayout;
		_headerCellAttributeArr = [headerLayout layoutAttributesForElementsInRect:(CGRect){{0, 0}, _topSelectCollectionView.contentSize}];
	}
	
	CGRect cellFrame = _headerCellAttributeArr[_topSelectViewShowingIndex].frame;
	
	
	UICollectionViewFlowLayout *midlayout = _midCollectionView.collectionViewLayout;
	
	CGFloat suggestHeaderOffsetX = cellFrame.origin.x + offset/midlayout.itemSize.width*cellFrame.size.width;
	
	suggestHeaderOffsetX -= _topSelectCollectionView.frame.size.width/2.0;
	
	suggestHeaderOffsetX = MAX(0, MIN(suggestHeaderOffsetX, _topSelectCollectionView.contentSize.width - _topSelectCollectionView.frame.size.width));
	
	[_topSelectCollectionView setContentOffset:CGPointMake(suggestHeaderOffsetX, 0) animated:animation];
}

- (void)centerHeaderSelecteTo:(NSInteger)index{
	_topSelectViewShowingIndex = index;
	[_topSelectCollectionView reloadData];
	CGRect cellFrame = _headerCellAttributeArr[index].frame;

	CGFloat offsetX = cellFrame.origin.x - (_topSelectCollectionView.frame.size.width - cellFrame.size.width)/2;

	offsetX = MAX(0, MIN(offsetX, _topSelectCollectionView.contentSize.width - _topSelectCollectionView.frame.size.width));
	if (fabs(_topSelectCollectionView.contentOffset.x - offsetX)>0.5) {
		_topSelectViewCanScroll = NO;
	}
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
	if (collectionView == _topSelectCollectionView) {

    }else{
		cell.backgroundColor = self.backgroundColor;
		if([cell isKindOfClass:[MDKSwitchTableMidCell class]]){
			MDKSwitchTableMidCell *_cell = cell;
			_cell.table.backgroundColor = self.backgroundColor;
			[self updateMidCellTableContentOffsetY:_cell.table];
		}
    }
}

- (void)updateMidCellTableContentOffsetY:(UITableView *)table{
	[table reloadData];
	[table layoutIfNeeded];

	if (table.contentSize.height < table.frame.size.height + _headerView.frame.size.height) {
		table.contentInset = UIEdgeInsetsMake(0, 0, table.frame.size.height + _headerView.frame.size.height - table.contentSize.height, 0);
		[table layoutIfNeeded];
	}else{
		table.contentInset = UIEdgeInsetsZero;
	}

	[table setContentOffset:CGPointMake(0, MAX(MIN(_currentOffsetY, _headerView.frame.size.height), table.contentOffset.y)) animated:NO];
	[self MDKSwitchTableDidScroll:table];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _midCollectionView) {

		UICollectionViewFlowLayout *midlayout = _midCollectionView.collectionViewLayout;

		CGFloat replaceContentX = scrollView.contentOffset.x + midlayout.itemSize.width *0.5;
		NSInteger leftIndex = replaceContentX / midlayout.itemSize.width;

		CGFloat midOffset = fmod(replaceContentX, midlayout.itemSize.width);

		NSInteger maxIndex = leftIndex;
		if ([_delegate respondsToSelector:@selector(MDKSwitchNumberOfSection)]) {
			maxIndex = [_delegate MDKSwitchNumberOfSection];
		}
		leftIndex = MIN(MAX(0, leftIndex), maxIndex);

		if (leftIndex != _midTableSelectedIndex) {
			_midTableSelectedIndex = leftIndex;
			[_midCurrentTable reloadData];
			[self updateMidCellTableContentOffsetY:_midCurrentTable];
		}
		if (_topSelectViewCanScroll) {
			[self updateHeaderSelected:leftIndex midViewOffset:midOffset scrollAnimation:(NO)];
		}

		if (_topSelectViewShowingIndex == leftIndex && midOffset <1) {
			_topSelectViewCanScroll = YES;
		}

    }
}

- (void)MDKSwitchTableDidScroll:(__kindof UIScrollView *)table{
	_midCurrentTable = table;

	CGRect topFrame = _topSelectCollectionView.frame;
	topFrame.origin.y = MAX(0, _headerView.frame.size.height - _midCurrentTable.contentOffset.y);
	_topSelectCollectionView.frame = topFrame;


	CGRect topLineFrame = _topSelectBottomLineView.frame;
	topLineFrame.origin.y = CGRectGetMaxY(_topSelectCollectionView.frame);
	_topSelectBottomLineView.frame = topLineFrame;

	CGRect headerFrame = _headerView.frame;
	headerFrame.origin.y = topFrame.origin.y - headerFrame.size.height;
	_headerView.frame = headerFrame;

	if ([_scrollDelegate respondsToSelector:@selector(MDKSwitchTableDidScroll:)]) {
		[_scrollDelegate MDKSwitchTableDidScroll:table];
	}
}
-(void)MDKSwitchTableDidStop:(__kindof UIScrollView *)table fromDragging:(BOOL)fromDragging{
	if (fromDragging) {
		_currentOffsetY = table.contentOffset.y;
		[self syncTablesContentOffsetYTo:table];
	}
}

- (void)syncTablesContentOffsetYTo:(UITableView *)table{
	[_tableWeakArr enumerateObjectsUsingBlock:^(UITableView *(^ obj)(void), NSUInteger idx, BOOL *stop) {
		UITableView *objTable = obj();
		if (objTable != table) {
			if (objTable.contentOffset.y < _headerView.frame.size.height) {
				[objTable setContentOffset:CGPointMake(0, MIN(_currentOffsetY, objTable.contentOffset.y)) animated:NO];
			}else if(_currentOffsetY < objTable.contentOffset.y){
				[objTable setContentOffset:CGPointMake(0, _currentOffsetY) animated:NO];
			}

		}
	}];
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
	if (scrollView == _midCollectionView) {
		_topSelectViewCanScroll = YES;
	}
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (!decelerate) {
		[self scrollViewDidEndDecelerating:scrollView];
	}
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	if (scrollView == _midCollectionView) {
		_topSelectViewCanScroll = YES;
	}
}

@end


#pragma clang diagnostic pop
