#import <UIKit/UIKit.h>
#import "SubCategoryModel.h"
#import "TypeModel.h"

@class TypeMuliSelectCell;
@protocol TypeMuliSelectCellProtocol <NSObject>

- (void)typeCell:(TypeMuliSelectCell *)typeCell selectedType:(TypeModel *)typeModel;
- (void)typeCell:(TypeMuliSelectCell *)typeCell deselectedType:(TypeModel *)typeModel;

- (void)selectedTypeOnSubCategroy;//to reload the table view

- (void)optionValueChangedFor:(UITableViewCell *)cell;

@end

@interface TypeMuliSelectCell : UITableViewCell

@property (weak, nonatomic) id <TypeMuliSelectCellProtocol> delegate;
@property (strong, nonatomic) SubCategoryModel *subCategoryModel;
@property (strong, nonatomic) NSMutableArray *selectedIndexPaths;

@end
