//
//  MCTableView.h
//  MCListView
//
//  Created by ike7 on 2018/12/26.
//  Copyright © 2018年 ike7. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 使用说明：
 若自定义Cell、headerView、footerView 需集成父类 MCTableViewCell 即可
 建议使用Class 声明好的方法(声明的变量名是私有的)
 */
typedef NS_ENUM(NSInteger,MCOperationView){
    MCOperationViewDataSource,
    MCOperationViewCell,
    MCOperationViewHeader,
    MCOperationViewFooter,
};
@class MCTableViewDataSource;
@class MCTableViewCell;
@class MCTableViewHeaderFooterDataSource;
@class MCTableViewEditingStyle;
@class MCTableViewRowActionDefaultStyle;
@class MCTableViewRowActionsCustomStyle;
@class MCTableViewHeaderFooterView;
@class MCTableViewCellMoveStyle;
@class MCTableViewTFViewShouldChangeTextStyle;
@class MCTableViewTFViewClearButtonClickStyle;
typedef void(^MCTableViewScrollBlock)(CGFloat scroll);
typedef void(^MCTableViewCellBlock)(NSIndexPath *indexPath,MCTableViewCell *cell);
typedef void(^MCTableViewHeaderViewBlock)(NSIndexPath *indexPath,MCTableViewHeaderFooterView *headerView);
typedef void(^MCTableViewFooterViewBlock)(NSIndexPath *indexPath,MCTableViewHeaderFooterView *footerView);
typedef void(^MCTableViewDataSourceBlock)(MCOperationView loadView,NSIndexPath *indexPath,MCTableViewDataSource *tableViewDataSource);
typedef void(^MCTableViewRowActionDefaultStyleBlock)(NSIndexPath *indexPath,MCTableViewRowActionDefaultStyle *tableActionDefaultStyle);
typedef void(^MCTableViewRowActionDefaultCommitBlock)(NSIndexPath *indexPath);
typedef void(^MCTableViewRowActionsCustomStyleBlock)(NSIndexPath *indexPath,MCTableViewRowActionsCustomStyle *tableViewRowActionsCustomStyle);
typedef void(^MCTableViewCellMoveStyleBlock)(NSIndexPath *indexPath,MCTableViewCellMoveStyle *tableViewMoveStyle);
typedef void(^MCTableViewCellReturnMoveDataBlock)(NSIndexPath *oldIndexPath,NSIndexPath *newIndexPath);
typedef void(^MCTableViewCellReturnClickDataBlock)(MCOperationView operationView,NSIndexPath *indexPath,NSInteger tag,id data);
typedef void(^MCTableViewTFViewCallBlock)(MCOperationView operationView,NSIndexPath *indexPath,id TFView);
typedef void(^MCTableViewTFViewShouldChangeTextBlock)(MCOperationView operationView,NSIndexPath *indexPath,NSInteger tag,NSRange range,NSString *string,MCTableViewTFViewShouldChangeTextStyle *tfViewShouldChangeTextStyle);
typedef void(^MCTableViewTFViewClearButtonClickBlock)(MCOperationView operationView,NSIndexPath *indexPath,MCTableViewTFViewClearButtonClickStyle *tfViewClearStyle);
typedef void(^MCTableViewTFViewDidEditingBlock)(MCOperationView operationView,NSIndexPath *indexPath,NSInteger tag,NSString *data,id dataUi);
@interface MCTableView : UITableView
#pragma mark ---------------------------------- tableView implementation
/**
 Call TableView Scroll
 回调TableView滑动
 
 @param block <#block description#>
 */
-(void)mcCallDidScroll:(MCTableViewScrollBlock)block;
/**
 Setting call tableView Data source return cell for view operation Data
 设置回调tableView风格,返回cell和view,操作数据
 
 @param dataSourceBlock <#dataSourceBlock description#>
 @param cellBlock <#cellBlock description#>
 @param headerBlock <#headerBlock description#>
 @param footerBlcok <#footerBlcok description#>
 @param block <#block description#>
 */
-(void)mcSetLoadDataSource:(MCTableViewDataSourceBlock)dataSourceBlock
                               cell:(MCTableViewCellBlock)cellBlock
                         headerView:(MCTableViewHeaderViewBlock)headerBlock
                         footerView:(MCTableViewFooterViewBlock)footerBlcok
                      operationData:(MCTableViewCellReturnClickDataBlock)block;

/**
 Setting call Cell default editing Data source
 设置Cell左滑项 默认单个
 Call did commit editing
 回调确认点击
 indexPath.row header -1,footer -2
 
 @param actionBlock <#editingDataSourceBlock description#>
 @param block <#block description#>
 */
-(void)mcSetRowActionDefaultCell:(MCTableViewRowActionDefaultStyleBlock)actionBlock callCommitDid:(MCTableViewRowActionDefaultCommitBlock)block;
/**
 Setting call Cell custom editing Data source
 设置Cell左滑多项
 
 @param block <#block description#>
 */
-(void)mcSetRowActionsCustomCell:(MCTableViewRowActionsCustomStyleBlock)block;

/**
 Setting call cell can move data source
 设置Cell 移动
 Call can move old indexPath for new indexPath
 回调移动后旧的indexPath 和新的 indexPath

 @param dataSourceBlock <#dataSourceBlock description#>
 @param block <#block description#>
 */
-(void)mcSetMoveCell:(MCTableViewCellMoveStyleBlock)dataSourceBlock indexPath:(MCTableViewCellReturnMoveDataBlock)block;
/**
 In TFView for delegate in setting call string should change for clear button click call
 在输入框代理中设置回调字符串发生的改变及清空按钮点击回调
 
 call not implementation in for nil
 为nil 调用则不实现
 */
-(void)mcSetTFViewShouldChangeText:(MCTableViewTFViewShouldChangeTextBlock)changeBlock didShouldChange:(MCTableViewTFViewCallBlock)didShouldChangeBlock clearButtonClick:(MCTableViewTFViewClearButtonClickBlock)clickBlock didEditing:(MCTableViewTFViewDidEditingBlock)blcok;
@end

@interface MCLoadView : UITableViewCell
@property   (weak,nonatomic)IBOutlet UITextField *textField;
@property   (weak,nonatomic)IBOutlet UITextView  *textView;
@property   (weak,nonatomic)IBOutlet UILabel     *titleLabel;

@property   (copy,nonatomic)MCTableViewTFViewShouldChangeTextBlock      changeTextBlock;
@property   (copy,nonatomic)MCTableViewTFViewCallBlock                  didChangeBlock;
@property   (copy,nonatomic)MCTableViewTFViewCallBlock                  didBeginEditing;
@property   (copy,nonatomic)MCTableViewCellReturnClickDataBlock         clickDataBlock;
@property   (copy,nonatomic)MCTableViewTFViewClearButtonClickBlock      clearClickBlock;
@property   (copy,nonatomic)MCTableViewTFViewDidEditingBlock            didEditingBlock;
-(void)mcSetValueTag:(NSInteger)tag data:(id)data;
-(void)mcSetTFViewDidBeginEditing:(id)TFView;
-(void)mcSetTFViewShouldChangeTextTag:(NSInteger)tag range:(NSRange)range string:(NSString *)string;
-(void)mcSetTFViewDidShouldChangeText:(id)TFView;
-(void)mcSetTFViewShouldClearButtonClick:(id)TFView;
-(void)mcSetTFViewDidEditingText:(NSString *)string tag:(NSInteger)tag tfView:(id)tfView;
@end

#pragma mark HeaderFooterView 自定义
@interface MCTableViewHeaderFooterView : MCLoadView
/**
 Click fill
 点击、传值
 */
-(void)mcSetValueTag:(NSInteger)tag data:(id)data;
/**
 In TFView type for delegate in setting call begin Editing
 在输入框类型代理中设置回调开始编辑
 */
-(void)mcSetTFViewDidBeginEditing:(id)TFView;
/**
 In TFView type for delegate in setting call string should change
 在输入框类型代理中设置回调字符串发生的改变
 */
-(void)mcSetTFViewShouldChangeTextTag:(NSInteger)tag range:(NSRange)range string:(NSString *)string;
/**
 In TFView for delegate in setting call string did should change
 在输入框代理中设置回调字符串完成发生的改变
 */
-(void)mcSetTFViewDidShouldChangeText:(id)TFView;
/**
 In TFView for delegate in setting call string did Editing
 在输入框代理中设置回调字符串完成编辑
 */
-(void)mcSetTFViewDidEditingText:(NSString *)string tag:(NSInteger)tag tfView:(id)tfView;

/**
 In TFView for delegate in setting call clear button click
 在输入框代理中设置回调清空按钮
 */
-(void)mcSetTFViewShouldClearButtonClick:(id)TFView;
@end

#pragma mark Cell 自定义
@interface MCTableViewCell : MCLoadView

/**
 Setting cell height
 设置Cell的高
 */
-(MCTableViewCell *(^)(CGFloat height))mcSetHeight;

/**
 Setting cell bottom height
 设置Cell底部的高
 */
-(MCTableViewCell *(^)(CGFloat height))mcSetBottomHeight;
/**
 Click fill
 点击、传值
 */
-(void)mcSetValueTag:(NSInteger)tag data:(id)data;
/**
 In TFView type for delegate in setting call begin Editing
 在输入框类型代理中设置回调开始编辑
 */
-(void)mcSetTFViewDidBeginEditing:(id)TFView;
/**
 In TFView type for delegate in setting call string should change
 在输入框类型代理中设置回调字符串发生的改变
 */
-(void)mcSetTFViewShouldChangeTextTag:(NSInteger)tag range:(NSRange)range string:(NSString *)string;
/**
 In TFView type for delegate in setting call string did should change
 在输入框类型代理中设置回调字符串完成发生的改变
 */
-(void)mcSetTFViewDidShouldChangeText:(id)TFView;
/**
 In TFView for delegate in setting call string did Editing
 在输入框代理中设置回调字符串完成编辑
 */
-(void)mcSetTFViewDidEditingText:(NSString *)string tag:(NSInteger)tag tfView:(id)tfView;;
/**
 In TFView for delegate in setting call clear button click
 在输入框代理中设置回调清空按钮
 */
-(void)mcSetTFViewShouldClearButtonClick:(id)TFView;
@end

@interface MCDataSource : NSObject
@property   (nonatomic,assign)  NSInteger   numberSections;
@property   (nonatomic,assign)  NSInteger   numberSectionRows;
@property   (nonatomic,copy)    NSString *  cellBundleName;
@property   (nonatomic,assign)  CGFloat     headerHeight;
@property   (nonatomic,assign)  CGFloat     footerHeight;
@property   (nonatomic,copy)    NSString *  headerTitleString;
@property   (nonatomic,copy)    NSString *  footerTitleString;
@property   (nonatomic,copy)    NSString *  headerBundleName;
@property   (nonatomic,copy)    NSString *  footerBundleName;
@property (nonatomic,assign)    BOOL isEditing;
@property (nonatomic,assign)    BOOL isCanMove;
@property   (nonatomic,copy)    NSString *  titleDeleteName;
@property   (nonatomic,assign)  UITableViewCellEditingStyle     editingStyle;
@property   (nonatomic,strong)  NSArray  *  editActions;
@property (nonatomic,assign)    BOOL isShouldClear;
@property (nonatomic,assign)    BOOL isShouldChange;
@end

/**
 Cell风格及展示
 */
@interface MCTableViewDataSource : MCDataSource
/**
 Setting Number Sections
 设置有多少个区
 */
-(MCTableViewDataSource *(^)(NSInteger numberSections))mcSetNumberSections;
/**
 Setting for sections rows
 */
-(MCTableViewDataSource *(^)(NSInteger mcRows))mcSetNumberRows;

/**
 Setting Cell load bundle name
 */
-(MCTableViewDataSource *(^)(NSString * bundleName))mcSetLoadNibNameCell;

/**
 Setting Sections header in height
 */
-(MCTableViewDataSource *(^)(CGFloat headerHeight))mcSetHeaderHeight;
/**
 Setting Sections footer in height
 */
-(MCTableViewDataSource *(^)(CGFloat footerHeight))mcSetFooterHeight;
/**
 Setting sections header title string
 */
-(MCTableViewDataSource *(^)(NSString * headerTitleString))mcSetHeaderTitleString;
/**
 Setting sections footer title string
 */
-(MCTableViewDataSource *(^)(NSString * footerTitleString))mcSetFooterTitleString;
/**
 Setting sections header load bundle name
 */
-(MCTableViewDataSource *(^)(NSString * headerBundleName))mcSetLoadNibNameHeader;
/**
 Setting footer header load bundle name
 */
-(MCTableViewDataSource *(^)(NSString * footerBundleName))mcSetLoadNibNameFooter;
@end

@interface MCTableViewEditingStyle : MCDataSource
@end

//位置替换
@interface MCTableViewCellMoveStyle : MCTableViewEditingStyle
/**
 Setting cell is can edit default YES
 */
-(MCTableViewCellMoveStyle *(^)(BOOL isCanEdit))mcSetIsCanEdit;

/**
 Setting cell is can move YES
 */
-(MCTableViewCellMoveStyle *(^)(BOOL isCanMove))mcSetIsCanMove;
@end
//左滑风格 System default
@interface MCTableViewRowActionDefaultStyle : MCTableViewEditingStyle
/**
 Setting cell is can edit default YES
 */
-(MCTableViewRowActionDefaultStyle *(^)(BOOL isEditing))mcSetIsEditing;
/**
 Setting tableview can move style
 */
-(MCTableViewRowActionDefaultStyle *(^)(UITableViewCellEditingStyle editingStyle))mcSetEditingStyle;
/**
 Setting tableview can move title name
 */
-(MCTableViewRowActionDefaultStyle *(^)(NSString * titleDeleteName))mcSetDefaultTitleName;
@end

//左滑自定义风格
@interface MCTableViewRowActionsCustomStyle : MCTableViewEditingStyle
/**
 Setting cell is can edit default YES
 */
-(MCTableViewRowActionsCustomStyle *(^)(BOOL isEditing))mcSetIsEditing;
/**
 Setting tableview can move style
 */
-(MCTableViewRowActionsCustomStyle *(^)(UITableViewCellEditingStyle editingStyle))mcSetEditingStyle;

/**
 Setting tableview can move edit actions
 */
-(MCTableViewRowActionsCustomStyle *(^)(NSArray <UITableViewRowAction *>* editActions))mcSetEditingActions;
@end



@interface MCTableViewTFViewShouldChangeTextStyle : MCDataSource
/**
 Setting TFView is should change text default YES
 */
-(MCTableViewTFViewShouldChangeTextStyle *(^)(BOOL isShouldChange))mcSetIsShouldChangeText;
@end

@interface MCTableViewTFViewClearButtonClickStyle : MCDataSource
/**
 Setting textField clear button click default YES
 */
-(MCTableViewTFViewClearButtonClickStyle *(^)(BOOL isShouldClear))mcSetIsShouldClear;
@end
