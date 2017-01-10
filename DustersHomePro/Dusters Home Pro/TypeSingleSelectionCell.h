#import <UIKit/UIKit.h>
#import "SubCategoryModel.h"

@protocol TypeSingleSelectCellProtocol <NSObject>
- (void)selectedTypeOnSubCategroy; //to reload the table view
- (void)optionValueChangedFor:(UITableViewCell *)cell;
@end

@interface TypeSingleSelectionCell : UITableViewCell

@property (strong, nonatomic) SubCategoryModel *subCategoryModel;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (weak, nonatomic) id<TypeSingleSelectCellProtocol> delegate;
@end
