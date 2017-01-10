#import "TypeSingleSelectionCell.h"
#import "TypeModel.h"
#import "OptionModel.h"
#import "Constant.h"

@interface TypeSingleSelectionCell () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *typeChoicesTableView;
@property (weak, nonatomic) IBOutlet UILabel *subServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *increaseButton;
@property (weak, nonatomic) IBOutlet UIButton *decreaseButton;
@property (weak, nonatomic) IBOutlet UILabel *optionTextLabel;
@property (weak, nonatomic) IBOutlet UIView *optionsContainerView;
@property (strong, nonatomic) NSArray *typeChoices;
@property (weak, nonatomic) IBOutlet UILabel *inspectionDescLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionViewHeightConst;

@end

@implementation TypeSingleSelectionCell
{
    NSIndexPath *selectedIndexPath;
    TypeModel *selectedTypeModel;
}

- (void)awakeFromNib {
    // Initialization code
    
    self.optionsContainerView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.optionsContainerView.layer.borderWidth = 1;
    self.optionsContainerView.layer.cornerRadius = 5;
    self.optionsContainerView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
}

- (void)setSubCategoryModel:(SubCategoryModel *)subCategoryModel
{
    _subCategoryModel = subCategoryModel;
    self.typeChoices = subCategoryModel.typeModels;
    self.selectedIndex = subCategoryModel.selectedTypeIndex;
    self.subServiceLabel.text = self.subCategoryModel.serviceTitle;
    [self.typeChoicesTableView reloadData];
    
    selectedTypeModel = self.typeChoices[self.selectedIndex];
    if (self.typeChoices.count > 0)
    {
        [self updateOptionForTypeModel:selectedTypeModel];
    }else {
        self.optionTextLabel.text = @"NA";
        self.priceLabel.text = [NSString stringWithFormat:@"%@0.00",kRUPPEE_SYMBOL];
        selectedTypeModel = nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.typeChoices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    TypeModel *model = self.typeChoices[indexPath.row];
    UILabel *label = (UILabel *) [cell viewWithTag:1011];
    label.text = model.serviceTitle;
    
    UIImageView *radioButton = (UIImageView *) [cell viewWithTag:1010];
    
    if ([selectedIndexPath isEqual:indexPath])
    {
        radioButton.image = [UIImage imageNamed:@"Radio-selected"];
    }else {
        radioButton.image = [UIImage imageNamed:@"Radio-unselected"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
    self.selectedIndex = indexPath.row;
    self.subCategoryModel.selectedTypeIndex = self.selectedIndex;
    [self updateOptionForTypeModel:self.typeChoices[indexPath.row]];
    [self.delegate selectedTypeOnSubCategroy];
    [tableView reloadData];
}

-  (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}


#pragma mark
#pragma mark Options

- (void)updateOptionForTypeModel:(TypeModel *)model
{
    selectedTypeModel = model;
    if (selectedTypeModel.isInspectionRequired)
    {
        self.optionViewHeightConst.constant = 0;
        self.inspectionDescLabel.text = selectedTypeModel.insepectionDescription;
    }else
    {
        self.optionViewHeightConst.constant = 40;
        self.inspectionDescLabel.text = @"";
    }
    
    [self setOptionLabelForIndex:model.selectedOptionIndex];
}

- (IBAction)increaseOptionValue:(UIButton *)sender
{
    NSInteger index = selectedTypeModel.selectedOptionIndex;
    [self setOptionLabelForIndex:++index];
}

- (IBAction)decreaseOptionValue:(UIButton *)sender
{
    NSInteger index = selectedTypeModel.selectedOptionIndex;
    [self setOptionLabelForIndex:--index];
}

- (void)setOptionLabelForIndex:(NSInteger)index
{
    if (index < selectedTypeModel.optionModels.count && index >= 0)
    {
        NSInteger previousIndex = selectedTypeModel.selectedOptionIndex;
        OptionModel *previousOption = selectedTypeModel.optionModels[previousIndex];
        selectedTypeModel.selectedOptionIndex = index;
        OptionModel *optionModel = selectedTypeModel.optionModels[index];
        
        self.priceLabel.text = [NSString stringWithFormat:@"%@%.2f", kRUPPEE_SYMBOL,[self.subCategoryModel priceOfSelections]];
        self.optionTextLabel.text = optionModel.serviceTitle;
        
        if (!selectedTypeModel.isInspectionRequired)
        {
            if (optionModel.isInspectionRequired)
            {
                self.inspectionDescLabel.text = optionModel.insepectionDescription;
            }else
            {
                self.inspectionDescLabel.text = @"";
            }
        }

        NSLog(@"Option %@", optionModel.serviceTitle);
        if (![previousOption isEqual:optionModel])
        {
            [self.delegate selectedTypeOnSubCategroy];
        }

    }else if (selectedTypeModel.optionModels.count == 0)
    {
        self.optionTextLabel.text = @"NA";
        self.priceLabel.text = [NSString stringWithFormat:@"%@0.00",kRUPPEE_SYMBOL];
    }
    
    [self.delegate optionValueChangedFor:self];
}

@end
