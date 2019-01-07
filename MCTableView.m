//
//  MCTableView.m
//  MCListView
//
//  Created by ike7 on 2018/12/26.
//  Copyright © 2018年 ike7. All rights reserved.
//

#import "MCTableView.h"
@interface MCTableView ()<UITableViewDelegate,UITableViewDataSource>{
    MCTableViewDataSource                               *tableViewDataSource;
    MCTableViewDataSourceBlock                          tableViewDataDourceBlock;
    MCTableViewCellReturnClickDataBlock                 tableViewCellReturnClickBlock;
    MCTableViewCellReturnClickDataBlock                 tableViewHeaderFooterReturnClickBlock;
    MCTableViewCellBlock                                tableViewCellBlcok;
    MCTableViewHeaderViewBlock                          tableViewHeaderViewBlcok;
    MCTableViewFooterViewBlock                          tableViewFooterViewBlcok;
    MCTableViewScrollBlock                              tableViewDidScrollBlock;
    MCTableViewRowActionDefaultStyle                    *tableViewRowActionDefaultStyle;
    MCTableViewRowActionsCustomStyle                    *tableViewRowActionsCustomStyle;
    MCTableViewRowActionDefaultStyleBlock               tableViewRowActionDefaultStyleBlock;
    MCTableViewRowActionsCustomStyleBlock               tableViewRowActionsCustomStyleBlock;
    MCTableViewRowActionDefaultCommitBlock              tableViewRowActionDefaultCommitBlock;
    MCTableViewCellMoveStyleBlock                       tableViewCellMoveStyleBlock;
    MCTableViewCellMoveStyle                            *tableViewCellMoveStyle;
    MCTableViewCellReturnMoveDataBlock                  tableViewCellReturnMoveDataBlock;
    MCTableViewTFViewShouldChangeTextBlock              tableViewCellTFViewShouldChangeTextBlock;
    MCTableViewTFViewCallBlock                          tableViewCellTFViewDidShouldChangeBlock;
    MCTableViewTFViewClearButtonClickBlock              tableViewTFViewClearButtonClickBlock;
    MCTableViewTFViewDidEditingBlock                    tableViewTFViewDidEditingBlock;
}
@end

@implementation MCTableView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
    self.dataSource = self;
    tableViewDataSource = [[MCTableViewDataSource alloc]init];
}

#pragma mark load  Cell Header/Footer View 处理
-(void)setLayoutViewDataSource:(NSIndexPath *)indexPath cell:(MCLoadView *)cell tableView:(UITableView *)tableView loadView:(MCOperationView)loadView{
    [self callTFViewShouldChange:indexPath layoutCell:cell loadView:loadView];
    if (tableViewCellReturnClickBlock) {
        cell.clickDataBlock = ^(MCOperationView operationView, NSIndexPath *indexPath, NSInteger tag, id data) {
            self->tableViewCellReturnClickBlock(loadView,indexPath,tag,data);
        };
    }
    if (tableViewTFViewClearButtonClickBlock) {
        cell.clearClickBlock = ^(MCOperationView operationView,NSIndexPath *mcIndexPath, MCTableViewTFViewClearButtonClickStyle *tfViewClearStyle) {
            self->tableViewTFViewClearButtonClickBlock(loadView,indexPath,tfViewClearStyle);
        };
    }
}

#pragma mark TFView Should Change
-(void)callTFViewShouldChange:(NSIndexPath *)indexPath layoutCell:(MCLoadView *)cell loadView:(MCOperationView)loadView{
    if (tableViewCellTFViewShouldChangeTextBlock) {
        cell.changeTextBlock = ^(MCOperationView operationView,NSIndexPath *mcIndexPath, NSInteger tag,NSRange range, NSString *string, MCTableViewTFViewShouldChangeTextStyle *tfViewShouldChangeTextStyle) {
            self->tableViewCellTFViewShouldChangeTextBlock(loadView,indexPath,tag,range,string,tfViewShouldChangeTextStyle);
        };
    }
    if (tableViewCellTFViewDidShouldChangeBlock) {
        cell.didChangeBlock = ^(MCOperationView operationView,NSIndexPath *mcIndexPath, id TFView) {
            self->tableViewCellTFViewDidShouldChangeBlock(loadView,indexPath,TFView);
        };
    }
    if (tableViewTFViewDidEditingBlock) {
        cell.didEditingBlock = ^(MCOperationView operationView, NSIndexPath *mcIndexPath, NSInteger tag, NSString *data, id dataUi) {
            self->tableViewTFViewDidEditingBlock(loadView,indexPath,tag,data,dataUi);
        };
    }
}
-(void)mcSetTFViewShouldChangeText:(MCTableViewTFViewShouldChangeTextBlock)changeBlock didShouldChange:(MCTableViewTFViewCallBlock)didShouldChangeBlock clearButtonClick:(MCTableViewTFViewClearButtonClickBlock)clickBlock didEditing:(MCTableViewTFViewDidEditingBlock)blcok{
    tableViewCellTFViewShouldChangeTextBlock = changeBlock;
    tableViewCellTFViewDidShouldChangeBlock = didShouldChangeBlock;
    tableViewTFViewClearButtonClickBlock = clickBlock;
    tableViewTFViewDidEditingBlock = blcok;
}
-(void)mcCallDidScroll:(MCTableViewScrollBlock)block{
    tableViewDidScrollBlock = block;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (tableViewDidScrollBlock) {
        tableViewDidScrollBlock(scrollView.contentOffset.y);
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableViewDataDourceBlock) {
        tableViewDataDourceBlock(MCOperationViewDataSource,[NSIndexPath indexPathForRow:0 inSection:0],tableViewDataSource);
    }
    return tableViewDataSource.numberSections;
}
-(void)mcSetLoadDataSource:(MCTableViewDataSourceBlock)dataSourceBlock
                               cell:(MCTableViewCellBlock)cellBlock
                         headerView:(MCTableViewHeaderViewBlock)headerBlock
                         footerView:(MCTableViewFooterViewBlock)footerBlcok
                      operationData:(MCTableViewCellReturnClickDataBlock)block{
    tableViewDataDourceBlock    = dataSourceBlock;
    tableViewCellBlcok          = cellBlock;
    tableViewHeaderViewBlcok    = headerBlock;
    tableViewFooterViewBlcok    = footerBlcok;
    tableViewCellReturnClickBlock = block;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableViewDataDourceBlock) {
        tableViewDataDourceBlock(MCOperationViewDataSource,[NSIndexPath indexPathForRow:0 inSection:section],tableViewDataSource);
    }
    return tableViewDataSource.numberSectionRows;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idCell = @"idCell";
    tableViewDataDourceBlock(MCOperationViewCell,indexPath,tableViewDataSource);
    MCTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:tableViewDataSource.cellBundleName owner:self options:nil]objectAtIndex:0];
    }else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    tableViewCellBlcok(indexPath,cell);
    [self setLayoutViewDataSource:indexPath cell:cell tableView:tableView loadView:MCOperationViewCell];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[self tableView:self cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableViewDataDourceBlock) {
        tableViewDataDourceBlock(MCOperationViewHeader,[NSIndexPath indexPathForRow:-1 inSection:section],tableViewDataSource);
    }
    return tableViewDataSource.headerHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableViewDataDourceBlock) {
        tableViewDataDourceBlock(MCOperationViewFooter,[NSIndexPath indexPathForRow:-2 inSection:section],tableViewDataSource);
    }
    return tableViewDataSource.footerHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:-1 inSection:section];
    return [self setHeaderFooterView:indexPath tableView:tableView];
}
-(UIView *)setHeaderFooterView:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    
    UIView *view = [[UIView alloc]init];
    switch (indexPath.row) {
        case -1:{
            [self setHeaderFooterDataSource:MCOperationViewHeader indexPath:indexPath];
            if (tableViewDataSource.headerBundleName.length != 0) {
                MCTableViewHeaderFooterView * cell = [[[NSBundle mainBundle]loadNibNamed:tableViewDataSource.headerBundleName owner:nil options:nil]lastObject];
                tableViewHeaderViewBlcok(indexPath,cell);
                [self setLayoutViewDataSource:indexPath cell:cell tableView:tableView loadView:MCOperationViewHeader];
                cell.frame = CGRectMake(0, 0, self.bounds.size.width, tableViewDataSource.headerHeight);
                [view addSubview:cell];
            }
        }
            break;
        default:{
            [self setHeaderFooterDataSource:MCOperationViewFooter indexPath:indexPath];
            if (tableViewDataSource.footerBundleName.length != 0) {
                MCTableViewHeaderFooterView * cell = [[[NSBundle mainBundle]loadNibNamed:tableViewDataSource.footerBundleName owner:nil options:nil]lastObject];
                tableViewFooterViewBlcok(indexPath,cell);
                [self setLayoutViewDataSource:indexPath cell:cell tableView:tableView loadView:MCOperationViewFooter];
                cell.frame = CGRectMake(0, 0, self.bounds.size.width, tableViewDataSource.footerHeight);
                [view addSubview:cell];
            }
        }
            break;
    }
    if (view.subviews.count > 0) {
        return view;
    }
    return  nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    [self setHeaderFooterDataSource:MCOperationViewHeader indexPath:[NSIndexPath indexPathForRow:-1 inSection:section]];
    return tableViewDataSource.headerTitleString;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    [self setHeaderFooterDataSource:MCOperationViewFooter indexPath:[NSIndexPath indexPathForRow:-2 inSection:section]];
    return tableViewDataSource.footerTitleString;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:-2 inSection:section];
    return [self setHeaderFooterView:indexPath tableView:tableView];
}

-(void)setHeaderFooterDataSource:(MCOperationView)loadView indexPath:(NSIndexPath *)indexPath{
    if (tableViewDataDourceBlock) {
        tableViewDataDourceBlock(loadView,indexPath,tableViewDataSource);
    }
}
-(void)mcSetRowActionDefaultCell:(MCTableViewRowActionDefaultStyleBlock)actionBlock callCommitDid:(MCTableViewRowActionDefaultCommitBlock)block{
    if (!tableViewRowActionDefaultStyle) {
        tableViewRowActionDefaultStyle = [[MCTableViewRowActionDefaultStyle alloc]init];
    }
    tableViewRowActionDefaultStyleBlock = actionBlock;
    tableViewRowActionDefaultCommitBlock = block;
}
-(void)mcSetRowActionsCustomCell:(MCTableViewRowActionsCustomStyleBlock)block{
    if (!tableViewRowActionsCustomStyle) {
        tableViewRowActionsCustomStyle = [[MCTableViewRowActionsCustomStyle alloc]init];
    }
    tableViewRowActionsCustomStyleBlock = block;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self setCanEditMoveRow:indexPath].titleDeleteName;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self setCanEditMoveRow:indexPath].editActions;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self setCanEditMoveRow:indexPath].editingStyle;
}
//移动Cell 完成 处理
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableViewRowActionDefaultCommitBlock) {
        tableViewRowActionDefaultCommitBlock(indexPath);
    }
}
-(void)mcSetMoveCell:(MCTableViewCellMoveStyleBlock)dataSourceBlock indexPath:(MCTableViewCellReturnMoveDataBlock)block{
    if (!tableViewCellMoveStyle) {
        tableViewCellMoveStyle = [[MCTableViewCellMoveStyle alloc]init];
    }
    [self setEditing:YES animated:YES];
    tableViewCellMoveStyleBlock = dataSourceBlock;
    tableViewCellReturnMoveDataBlock = block;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self setCanEditMoveRow:indexPath].isEditing;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self setCanEditMoveRow:indexPath].isCanMove;
}
-(MCTableViewEditingStyle *)setCanEditMoveRow:(NSIndexPath *)indexPath{
    MCTableViewEditingStyle *style;
    if (tableViewCellMoveStyleBlock){
        tableViewCellMoveStyleBlock(indexPath,tableViewCellMoveStyle);
        style = (MCTableViewEditingStyle *)tableViewCellMoveStyle;
    }
    
    if (tableViewRowActionDefaultStyleBlock) {
        tableViewRowActionDefaultStyleBlock(indexPath,tableViewRowActionDefaultStyle);
        style = (MCTableViewEditingStyle *)tableViewRowActionDefaultStyle;
    }
    
    if (tableViewRowActionsCustomStyleBlock) {
        tableViewRowActionsCustomStyleBlock(indexPath,tableViewRowActionsCustomStyle);
        style = (MCTableViewEditingStyle *)tableViewRowActionsCustomStyle;
    }
    
    return style;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if (tableViewCellReturnMoveDataBlock) {
        tableViewCellReturnMoveDataBlock(sourceIndexPath,destinationIndexPath);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableViewCellReturnClickBlock) {
        tableViewCellReturnClickBlock(MCOperationViewCell,indexPath,0,nil);
    }
}
@end

@interface MCLoadView ()<UITextViewDelegate,UITextFieldDelegate>{
    MCTableViewTFViewShouldChangeTextStyle      *tableViewCellTFViewChangeStyle;
    MCTableViewTFViewClearButtonClickStyle      *tableViewCellTextFieldClearStyle;
}

@end

@implementation MCLoadView
-(void)awakeFromNib{
    [super awakeFromNib];
    if (self.textView) {
        self.textView.delegate = self;
    }
    if (self.textField) {
        self.textField.delegate = self;
        [self.textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    }
}
-(void)setChangeTextBlock:(MCTableViewTFViewShouldChangeTextBlock)changeTextBlock{
    if (!tableViewCellTFViewChangeStyle) {
        tableViewCellTFViewChangeStyle = [[MCTableViewTFViewShouldChangeTextStyle alloc]init];
    }
    _changeTextBlock = changeTextBlock;
}
-(void)setDidChangeBlock:(MCTableViewTFViewCallBlock)didChangeBlock{
    _didChangeBlock = didChangeBlock;
}
-(void)textFieldDidChanged:(UITextField *)textField{
    if (self.didChangeBlock) {
        self.didChangeBlock(0,nil,textField);
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self mcSetTFViewDidBeginEditing:textField];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self mcSetTFViewDidBeginEditing:textView];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (tableViewCellTFViewChangeStyle) {
        self.changeTextBlock(0,nil,textField.tag,range,string,tableViewCellTFViewChangeStyle);
        return tableViewCellTFViewChangeStyle.isShouldChange;
    }else{
        return YES;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (tableViewCellTFViewChangeStyle) {
        self.changeTextBlock(0,nil,textView.tag,range,text,tableViewCellTFViewChangeStyle);
        return tableViewCellTFViewChangeStyle.isShouldChange;
    }else{
        return YES;
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    if (self.didChangeBlock) {
        self.didChangeBlock(0,nil,textView);
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.didEditingBlock) {
        self.didEditingBlock(0, nil, 0, textField.text, textField);
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (self.didEditingBlock) {
        self.didEditingBlock(0, nil, 0, textView.text, textView);
    }
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if (self.clearClickBlock) {
        if (!tableViewCellTextFieldClearStyle) {
            tableViewCellTextFieldClearStyle = [[MCTableViewTFViewClearButtonClickStyle alloc]init];
        }
        self.clearClickBlock(0,nil, tableViewCellTextFieldClearStyle);
        return tableViewCellTextFieldClearStyle.isShouldClear;
    }else{
        return YES;
    }
}
-(void)mcSetValueTag:(NSInteger)tag data:(id)data{
    if (self.clickDataBlock) {
        self.clickDataBlock(0,nil, tag, data);
    }
}
-(void)mcSetTFViewDidBeginEditing:(id)TFView{
    if (self.didBeginEditing) {
        self.didBeginEditing(0,nil,TFView);
    }
}
-(void)mcSetTFViewShouldChangeTextTag:(NSInteger)tag range:(NSRange)range string:(NSString *)string{
    if (tableViewCellTFViewChangeStyle) {
        self.changeTextBlock(0,nil,tag,range,string,tableViewCellTFViewChangeStyle);
    }else{
        NSLog(@"MC Not implementation -(void)mcSetTFViewShouldChangeText:(MCTableViewTFViewShouldChangeTextBlock)changeBlock  callDidShouldChange:(MCTableViewTFViewDidShouldChangeBlock)block");
    }
}
-(void)mcSetTFViewDidShouldChangeText:(id)TFView{
    if (self.didChangeBlock) {
        self.didChangeBlock(0,nil,TFView);
    }else{
        NSLog(@"MC Not implementation -(void)mcSetTFViewShouldChangeText:(MCTableViewTFViewShouldChangeTextBlock)changeBlock  callDidShouldChange:(MCTableViewTFViewDidShouldChangeBlock)block");
    }
}
-(void)mcSetTFViewDidEditingText:(NSString *)string tag:(NSInteger)tag tfView:(id)tfView{
    if (self.didEditingBlock) {
        self.didEditingBlock(0, nil, tag, string, tfView);
    }
}
-(IBAction)buttonClick:(UIButton *)sender{
    if (self.clickDataBlock) {
        self.clickDataBlock(0,nil, sender.tag, sender);
    }
}
-(void)mcSetTFViewShouldClearButtonClick:(id)TFView{
    if (self.clearClickBlock) {
        if (!tableViewCellTextFieldClearStyle) {
            tableViewCellTextFieldClearStyle = [[MCTableViewTFViewClearButtonClickStyle alloc]init];
        }
        self.clearClickBlock(0,nil, tableViewCellTextFieldClearStyle);
    }else{
        NSLog(@"MC Not implementation -(void)mcSetTextFieldClearButtonClick:(MCTableViewTextFieldClearButtonClickBlock)block");
    }
}

@end

@implementation MCTableViewHeaderFooterView

-(void)mcSetTFViewDidBeginEditing:(id)TFView{
    [super mcSetTFViewDidBeginEditing:TFView];
}
-(void)mcSetTFViewDidShouldChangeText:(id)TFView{
    [super mcSetTFViewDidShouldChangeText:TFView];
}
-(void)mcSetTFViewDidEditingText:(NSString *)string tag:(NSInteger)tag tfView:(id)tfView{
    [super mcSetTFViewDidEditingText:string tag:tag tfView:tfView];
}
-(void)mcSetTFViewShouldChangeTextTag:(NSInteger)tag range:(NSRange)range string:(NSString *)string{
    [super mcSetTFViewShouldChangeTextTag:tag range:range string:string];
}
-(void)mcSetTFViewShouldClearButtonClick:(id)TFView{
    [super mcSetTFViewShouldClearButtonClick:TFView];
}
-(void)mcSetValueTag:(NSInteger)tag data:(id)data{
    [super mcSetValueTag:tag data:data];
}
@end
@interface MCTableViewCell (){
    CGFloat height;
    CGFloat buttomHeight;
}

@end
@implementation MCTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    height = self.frame.size.height;
}
-(MCTableViewCell *(^)(CGFloat))mcSetHeight{
    return ^MCTableViewCell *(CGFloat heigh){
        CGRect frame = [self frame];
        frame.size.height = heigh;
        self->height = heigh;
        self.frame = frame;
        return self;
    };
}
-(MCTableViewCell *(^)(CGFloat))mcSetBottomHeight{
    return ^MCTableViewCell *(CGFloat heigh){
        self->buttomHeight = heigh;
        return self;
    };
}
-(void)mcSetValueTag:(NSInteger)tag data:(id)data{
    [super mcSetValueTag:tag data:data];
}
-(void)setFrame:(CGRect)frame{
    if (buttomHeight != 0) {
        self.separatorInset = UIEdgeInsetsMake(0, self.frame.size.width, 0, 0);
    }
    if (height - frame.size.height != buttomHeight) {
        frame.size.height -= buttomHeight;
    }
    [super setFrame:frame];
}
-(void)mcSetTFViewDidBeginEditing:(id)TFView{
    [super mcSetTFViewDidBeginEditing:TFView];
}
-(void)mcSetTFViewShouldChangeTextTag:(NSInteger)tag range:(NSRange)range string:(NSString *)string{
    [super mcSetTFViewShouldChangeTextTag:tag range:range string:string];
}
-(void)mcSetTFViewDidShouldChangeText:(id)TFView{
    [super mcSetTFViewDidShouldChangeText:TFView];
}
-(void)mcSetTFViewDidEditingText:(NSString *)string tag:(NSInteger)tag tfView:(id)tfView{
    [super mcSetTFViewDidEditingText:string tag:tag tfView:tfView];
}
-(void)mcSetTFViewShouldClearButtonClick:(id)TFView{
    [super mcSetTFViewShouldClearButtonClick:TFView];
}
@end

@implementation MCDataSource



@end

@implementation MCTableViewDataSource
-(MCTableViewDataSource *(^)(NSInteger))mcSetNumberSections{
    return ^MCTableViewDataSource *(NSInteger numberRows){
        self.numberSections = numberRows;
        return self;
    };
}
-(MCTableViewDataSource *(^)(NSInteger))mcSetNumberRows{
    return ^MCTableViewDataSource *(NSInteger numberSectionRows){
        self.numberSectionRows = numberSectionRows;
        return self;
    };
}

-(MCTableViewDataSource *(^)(NSString *))mcSetLoadNibNameCell{
    return ^MCTableViewDataSource *(NSString *cellBundleName){
        self.cellBundleName = cellBundleName;
        return self;
    };
}
-(MCTableViewDataSource *(^)(CGFloat))mcSetHeaderHeight{
    return ^MCTableViewDataSource *(CGFloat headerHeight){
        self.headerHeight = headerHeight;
        return self;
    };
}
-(MCTableViewDataSource *(^)(CGFloat))mcSetFooterHeight{
    return ^MCTableViewDataSource *(CGFloat footerHeight){
        self.footerHeight = footerHeight;
        return self;
    };
}
-(MCTableViewDataSource *(^)(NSString *))mcSetHeaderTitleString{
    return ^MCTableViewDataSource *(NSString *headerTitleString){
        self.headerTitleString = headerTitleString;
        return self;
    };
}
/**
 Setting sections footer title string
 */
-(MCTableViewDataSource *(^)(NSString *))mcSetFooterTitleString{
    return ^MCTableViewDataSource *(NSString *footerTitleString){
        self.footerTitleString = footerTitleString;
        return self;
    };
}
-(MCTableViewDataSource *(^)(NSString *))mcSetLoadNibNameFooter{
    return ^MCTableViewDataSource *(NSString *footerBundleName){
        self.footerBundleName = footerBundleName;
        return self;
    };
}
-(MCTableViewDataSource *(^)(NSString *))mcSetLoadNibNameHeader{
    return ^MCTableViewDataSource *(NSString *headerBundleName){
        self.headerBundleName = headerBundleName;
        return self;
    };
}
@end

@implementation MCTableViewEditingStyle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isEditing = YES;
        self.editActions = nil;
    }
    return self;
}
@end


@implementation MCTableViewRowActionDefaultStyle
-(MCTableViewRowActionDefaultStyle *(^)(BOOL))mcSetIsEditing{
    return ^MCTableViewRowActionDefaultStyle *(BOOL isEditing){
        [super setIsEditing:isEditing];
        return self;
    };
}
-(MCTableViewRowActionDefaultStyle *(^)(UITableViewCellEditingStyle))mcSetEditingStyle{
    return ^MCTableViewRowActionDefaultStyle *(UITableViewCellEditingStyle editingStyle){
        self.editingStyle = editingStyle;
        return self;
    };
}
-(MCTableViewRowActionDefaultStyle *(^)(NSString *))mcSetDefaultTitleName{
    return ^MCTableViewRowActionDefaultStyle *(NSString * titleDeleteName){
        self.titleDeleteName = titleDeleteName;
        return self;
    };
}

@end

@implementation MCTableViewRowActionsCustomStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(MCTableViewRowActionsCustomStyle *(^)(BOOL))mcSetIsEditing{
    return ^MCTableViewRowActionsCustomStyle *(BOOL isEditing){
        self.isEditing = isEditing;
        return self;
    };
}
-(MCTableViewRowActionsCustomStyle *(^)(UITableViewCellEditingStyle))mcSetEditingStyle{
    return ^MCTableViewRowActionsCustomStyle *(UITableViewCellEditingStyle editingStyle){
        self.editingStyle = editingStyle;
        return self;
    };
}
-(MCTableViewRowActionsCustomStyle *(^)(NSArray<UITableViewRowAction *> *))mcSetEditingActions{
    return ^MCTableViewRowActionsCustomStyle *(NSArray <UITableViewRowAction *>*editActions){
        self.editActions = editActions;
        return self;
    };
}
@end

@implementation MCTableViewCellMoveStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isCanMove = YES;
    }
    return self;
}
-(MCTableViewCellMoveStyle *(^)(BOOL))mcSetIsCanEdit{
    return ^MCTableViewCellMoveStyle *(BOOL isEditing){
        self.isEditing = isEditing;
        return self;
    };
}
-(MCTableViewCellMoveStyle *(^)(BOOL))mcSetIsCanMove{
    return ^MCTableViewCellMoveStyle *(BOOL isCanMove){
        self.isCanMove = isCanMove;
        return self;
    };
}
@end

@implementation MCTableViewTFViewShouldChangeTextStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isShouldChange = YES;
    }
    return self;
}
-(MCTableViewTFViewShouldChangeTextStyle *(^)(BOOL))mcSetIsShouldChangeText{
    return ^MCTableViewTFViewShouldChangeTextStyle *(BOOL isShouldChange){
        self.isShouldChange = isShouldChange;
        return self;
    };
}

@end

@implementation MCTableViewTFViewClearButtonClickStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isShouldClear = YES;
    }
    return self;
}

-(MCTableViewTFViewClearButtonClickStyle *(^)(BOOL))mcSetIsShouldClear{
    return ^MCTableViewTFViewClearButtonClickStyle *(BOOL isShouldClear){
        self.isShouldClear = isShouldClear;
        return self;
    };
}

@end
