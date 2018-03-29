//
//  AddTaskView.m
//  TaskManage
//
//  Created by zhengnan on 2018/3/27.
//  Copyright © 2018年 zn. All rights reserved.
//

#import "AddTaskView.h"
#import "AddTaskCell.h"
#import "ZNDatePickerView.h"
#import "ZNSelectIconView.h"

@interface AddTaskView()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_addTaskTitleArray;
}
@property (nonatomic,weak) UITextField *nameField;
@property (nonatomic,weak) UITextView  *remarkField;
@property (nonatomic,strong) ZNDatePickerView *znDatePickerView;
@property (nonatomic,strong) ZNSelectIconView *znSelectIconView;
@property (nonatomic,strong) UIAlertController *alertController;

@property(nonatomic,strong) UIButton *addTaskButton;


@end

@implementation AddTaskView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
    
        _addTaskTitleArray = [NSMutableArray arrayWithArray:@[
                              @{@"title":@"名称",@"type":@"input",@"height":[NSNumber numberWithFloat:50]},
                              @{@"title":@"图标",@"type":@"imagSelect",@"height":[NSNumber numberWithFloat:50],@"value": [UIImage imageNamed:@"good1"]},
                              @{@"title":@"开始时间",@"type":@"select",@"height":[NSNumber numberWithFloat:50],@"value":[NSDate getDateString:@"yyyy-MM-dd"]},
                              @{@"title":@"结束时间",@"type":@"select",@"height":[NSNumber numberWithFloat:50],@"value":[NSDate getStringDate:[NSDate getNextDayDate] FormatterString:@"yyyy-MM-dd"]},
                              @{@"title":@"备注",@"type":@"remark",@"height":[NSNumber numberWithFloat:150]}
                              ]];
        [self addSubview:self.addTaskTableView];
        
    }
    return self;
}

-(void)addTaskAction{
    ZNLog(@"%@:%@",self.nameField.text,self.remarkField.text);
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addTaskTitleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber *number = _addTaskTitleArray[indexPath.row][@"height"];
    return number.floatValue;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell = [[AddTaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if([_addTaskTitleArray[indexPath.row][@"title"] isEqualToString:@"名称"]){
        self.nameField = cell.textField;
    }else if([_addTaskTitleArray[indexPath.row][@"title"] isEqualToString:@"备注"]){
        self.remarkField = cell.textView;
    }
   
    cell.cellData = _addTaskTitleArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellTitle = _addTaskTitleArray[indexPath.row][@"title"];
    if([cellTitle isEqualToString:@"结束时间"]){
        
        [self.viewControllerID presentViewController:self.alertController animated:YES completion:nil];
        
    }else if([cellTitle isEqualToString:@"开始时间"]){
    
        self.znDatePickerView.title = @"开始时间";
        self.znDatePickerView.currentDate = [NSDate date];
        [self.znDatePickerView setHidden:NO];
        
    }else if([cellTitle isEqualToString:@"图标"]){
        [self.znSelectIconView setHidden:NO];
    }
}


-(UITableView *)addTaskTableView{
    if(_addTaskTableView == nil){
        _addTaskTableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _addTaskTableView.delegate = self;
        _addTaskTableView.dataSource = self;
        _addTaskTableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.00f];
        _addTaskTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        [footView addSubview:self.addTaskButton];
        [self.addTaskButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footView);
            make.left.equalTo(footView).with.offset(25);
            make.right.equalTo(footView).with.offset(-25);
            make.height.with.offset(50);
        }];
        
        _addTaskTableView.tableFooterView = footView;
        
    }
    return _addTaskTableView;
}

-(UIButton *)addTaskButton
{
    if(_addTaskButton == nil){
        
        _addTaskButton = [[UIButton alloc]init];
        _addTaskButton.backgroundColor = [UIColor colorWithRed:0.29f green:0.75f blue:0.96f alpha:1.00f];
        _addTaskButton.layer.masksToBounds = YES;
        _addTaskButton.layer.cornerRadius = 10;
        _addTaskButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addTaskButton setTitle:@"+添加到小目标栏" forState:UIControlStateNormal];
        [_addTaskButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addTaskButton addTarget:self action:@selector(addTaskAction) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _addTaskButton;
}
-(UIAlertController *)alertController{
    if(_alertController == nil){
        _alertController = [UIAlertController alertControllerWithTitle:@"选择结束模式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [_alertController addAction:[UIAlertAction actionWithTitle:@"有限期" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.znDatePickerView.title = @"结束时间";
            NSDate *date = [[NSDate alloc]init];
            NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
            self.znDatePickerView.currentDate = nextDay;
            [self.znDatePickerView setHidden:NO];
        }]];
        
        [_alertController addAction:[UIAlertAction actionWithTitle:@"无限期" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [_alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [_alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
    }
    return _alertController;
}

-(ZNDatePickerView *)znDatePickerView{
    if(_znDatePickerView == nil){
        _znDatePickerView = [[ZNDatePickerView alloc]init];
        
        __weak NSMutableArray *addTaskTitleArray = _addTaskTitleArray;
        __weak typeof(self) weakSelf = self;
        _znDatePickerView.datePickerBlock=^(NSString *title,NSInteger toolButtonType,NSDate *date){
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *dateStr = [formatter stringFromDate:date];
            
            if([title isEqualToString:@"开始时间"]){
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:addTaskTitleArray[2]] ;
                [dict setValue:dateStr forKey:@"value"];
                [addTaskTitleArray replaceObjectAtIndex:2 withObject:dict];
                [weakSelf.addTaskTableView reloadData];
                
            }else{
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:addTaskTitleArray[3]] ;
                [dict setValue:dateStr forKey:@"value"];
                [addTaskTitleArray replaceObjectAtIndex:3 withObject:dict];
                [weakSelf.addTaskTableView reloadData];
            }
        };
        [self addSubview:_znDatePickerView];
        [_znDatePickerView setHidden:YES];

    }
    return _znDatePickerView;
}

-(ZNSelectIconView *)znSelectIconView{
    if(_znSelectIconView == nil){
        
        _znSelectIconView = [[ZNSelectIconView alloc]init];
        NSMutableArray *iconArray = [NSMutableArray array];
        for (NSInteger i=1; i<=8; i++) {
            [iconArray addObject:[NSString stringWithFormat:@"good%ld",i]];
        }
        _znSelectIconView.iconNameArray = iconArray;
        [self addSubview:_znSelectIconView];
        [_znSelectIconView setHidden:YES];
    }
    return _znSelectIconView;
}


@end