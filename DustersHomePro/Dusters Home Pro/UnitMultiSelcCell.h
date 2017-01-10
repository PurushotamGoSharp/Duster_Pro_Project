#import <UIKit/UIKit.h>
#import "TypeModel.h"

@class UnitMultiSelcCell;

@protocol UnitMultiSelcCellProtocol <NSObject>

- (void)selectedTypeOnSubCategroy; //to reload the table view
- (void)optionValueChangedFor:(UnitMultiSelcCell *)cell;

@end

@interface UnitMultiSelcCell : UITableViewCell

@property (strong, nonatomic) TypeModel *model;
@property (weak, nonatomic) id<UnitMultiSelcCellProtocol> delegate;

@end
