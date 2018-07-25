# MDKSwitchTable
##### a easy way to combine tableviews with a switch tap like android's taplayout in IOS

# Screenshots

![image](https://github.com/miku1958/MDKSwitchTable/raw/master/example/apngb-animated.png)

# usage
#### 1、create a swtichTable

    MDKSwitchTopSelectViewOption *option = [[MDKSwitchTopSelectViewOption alloc]init];
    MDKSwitchTableView *switchTable = [[MDKSwitchTableView alloc]initWithOption:option];

#### 2、if you want to change the property of switch tab view ,you can change the option's property,like itemTextColor
    
#### 3、add delegate 


    switchTable.delegate = self;


#### 4、implement MDKSwitchTableDelegate methods 
basically is the same as tableviewDatasource and tableviewDelegate

    //MARK:	switchTab
    - (NSInteger)MDKSwitchNumberOfSection {
    	return _midSwitchTitleArr.count;
    }
    - (NSString *)MDKSwitchTitleOfSectionInHeader:(NSInteger)section {
    	return _midSwitchTitleArr[section];
    }
    
    - (NSInteger)MDKSwitchTable:(UITableView *)midTable ofIndex:(NSUInteger)index numberOfRowsInSection:(NSInteger)section {
    	return _midSwitchDataArr[index].count;
    }
    
    //MARK:	mid
    - (void)MDKSwitchRegisterCellForTable:(UITableView *)midTable ofIndex:(NSUInteger)index {
    	[midTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    
    - (CGFloat)MDKSwitchTable:(UITableView *)midTable ofIndex:(NSUInteger)index heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    	return 50;
    }
    
    - (UITableViewCell *)MDKSwitchTable:(UITableView *)midTable ofIndex:(NSUInteger)index cellAtIndexPath:(NSIndexPath *)indexPath {
    	UITableViewCell *cell = [midTable dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    	cell.textLabel.text = _midSwitchDataArr[index][indexPath.row];
    	return cell;
    }
    
    - (void)MDKSwitchTable:(UITableView *)midTable ofIndex:(NSUInteger)index didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    }

#### 5、if you need a extra headerView,you can reset

    switchTable.headerView
    

