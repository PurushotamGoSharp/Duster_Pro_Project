#import "UnitMultiSelcCell.h"
#import "OptionModel.h"

@interface UnitMultiSelcCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkBoximageView;
@property (weak, nonatomic) IBOutlet UIButton *decreaseButton;
@property (weak, nonatomic) IBOutlet UIButton *increaseButton;
@property (weak, nonatomic) IBOutlet UILabel *currentOptionLabel;
@property (weak, nonatomic) IBOutlet UIView *optionsContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionViewHeightCons;
@property (weak, nonatomic) IBOutlet UILabel *inspectionDescLabel;

@end

@implementation UnitMultiSelcCell

- (void)awakeFromNib {
    // Initialization code
    self.optionsContainerView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.optionsContainerView.layer.borderWidth = 1;
    self.optionsContainerView.layer.cornerRadius = 5;
    self.optionsContainerView.layer.masksToBounds = YES;
}

- (void)setModel:(TypeModel *)model
{
    _model = model;
    self.typeLabel.text = model.serviceTitle;
    if (self.model.selected)
    {
        self.checkBoximageView.image = [UIImage imageNamed:@"checkbox-checked"];
    }else
    {
        self.checkBoximageView.image = [UIImage imageNamed:@"checkbox-unchecked"];
    }
    
    if (self.model.isInspectionRequired)
    {
        self.optionViewHeightCons.constant = 0;
        self.inspectionDescLabel.text = self.model.insepectionDescription;
    }else
    {
        self.optionViewHeightCons.constant = 40;
        self.inspectionDescLabel.text = @"";
    }
    
    [self updateOptionForTypeModel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark
#pragma mark Options

- (void)updateOptionForTypeModel
{
    [self setOptionLabelForIndex:self.model.selectedOptionIndex];
}

- (IBAction)increaseOptionValue:(UIButton *)sender
{
    NSInteger index = self.model.selectedOptionIndex;
    [self setOptionLabelForIndex:++index];
}

- (IBAction)decreaseOptionValue:(UIButton *)sender
{
    NSInteger index = self.model.selectedOptionIndex;
    [self setOptionLabelForIndex:--index];
}

- (void)setOptionLabelForIndex:(NSInteger)index
{
    if (index < self.model.optionModels.count && index >= 0)
    {
        NSInteger previousIndex = self.model.selectedOptionIndex;
        OptionModel *previousOption = self.model.optionModels[previousIndex];

        self.model.selectedOptionIndex = index;
        OptionModel *optionModel = self.model.optionModels[index];
        self.currentOptionLabel.text = optionModel.serviceTitle;
        
        if (!self.model.isInspectionRequired)
        {
            if (optionModel.isInspectionRequired)
            {
                self.inspectionDescLabel.text = optionModel.insepectionDescription;
            }else
            {
                self.inspectionDescLabel.text = @"";
            }
        }
        
        if (![previousOption isEqual:optionModel])
        {
            [self.delegate selectedTypeOnSubCategroy];
        }
        [self.delegate optionValueChangedFor:self];
    }
}


@end
