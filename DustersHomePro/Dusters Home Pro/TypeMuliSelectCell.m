#import "TypeMuliSelectCell.h"
#import "UnitMultiSelcCell.h"
#import "Constant.h"

@interface TypeMuliSelectCell () <UITableViewDataSource, UITableViewDelegate, UnitMultiSelcCellProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricelabeel;

@property (strong, nonatomic) NSArray *typeChoices;

@end

@implementation TypeMuliSelectCell
{

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSubCategoryModel:(SubCategoryModel *)subCategoryModel
{
    _subCategoryModel = subCategoryModel;
    self.typeChoices = subCategoryModel.typeModels;
//    self.selectedIndexPaths = [subCategoryModel.selectedIndexPaths mutableCopy];
    self.titleLabel.text = self.subCategoryModel.serviceTitle;
    [self updatePriceLabel];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.typeChoices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnitMultiSelcCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnitMultiSelcCell"];
    cell.model = self.typeChoices[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndexPaths == nil)
    {
        self.selectedIndexPaths = [[NSMutableArray alloc] init];
    }
    
    TypeModel *typeModel = self.typeChoices[indexPath.row];
    
    if (typeModel.selected)
    {
        typeModel.selected = NO;
        [self.tableView reloadData];
        [self.delegate typeCell:self deselectedType:typeModel];
    }else
    {
        typeModel.selected = YES;
        [self.tableView reloadData];
        [self.delegate typeCell:self selectedType:typeModel];
    }
    
    [self updatePriceLabel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TypeModel *typeModel = self.typeChoices[indexPath.row];

//    if (typeModel.selected)
//    {
//        return MAX_TYPE_CELL_HEIGHT;
//    }
//    
    return [typeModel cellHeight];
}

- (void)optionValueChangedFor:(UnitMultiSelcCell *)cell
{
    [self updatePriceLabel];
}

- (void)updatePriceLabel
{
    self.pricelabeel.text = [NSString stringWithFormat:@"%@%.2f", kRUPPEE_SYMBOL,[self.subCategoryModel priceOfSelections]];
    [self.delegate optionValueChangedFor:self];
}

- (void)selectedTypeOnSubCategroy
{
    [self.delegate selectedTypeOnSubCategroy];
}


@end
