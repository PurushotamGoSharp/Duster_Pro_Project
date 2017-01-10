#import "TypeModel.h"
#import "OptionModel.h"

#define MAX_HEIGHT_WITHOUT_OPTION_N_DESC 44

@implementation TypeModel

- (CGFloat)cellHeight
{
    if (self.selected)
    {
        if (self.isInspectionRequired)
        {
            CGFloat widthOfLabel = [[UIApplication sharedApplication].delegate window].bounds.size.width;
            widthOfLabel -= 32;
            CGFloat height = [self.insepectionDescription boundingRectWithSize:(CGSizeMake(widthOfLabel, NSIntegerMax)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
            
            height += MAX_HEIGHT_WITHOUT_OPTION_N_DESC;
            return height;
        }else
        {
            OptionModel *selectedModel = self.optionModels[self.selectedOptionIndex];
            if (selectedModel.isInspectionRequired)
            {
                CGFloat widthOfLabel = [[UIApplication sharedApplication].delegate window].bounds.size.width;
                widthOfLabel -= 32;
                CGFloat height = [selectedModel.insepectionDescription boundingRectWithSize:(CGSizeMake(widthOfLabel, NSIntegerMax)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
                
                height += MAX_TYPE_CELL_HEIGHT;
                return height;
            }
        }
        return MAX_TYPE_CELL_HEIGHT;
    }
    return 36;
}

- (CGFloat)priceOfSelecltion
{
    if (self.optionModels.count == 0)
    {
        return 0.0;
    }
    
    OptionModel *selectedOption = self.optionModels[self.selectedOptionIndex];
    return selectedOption.servicePrice;
}

- (NSInteger)maxServiceDuration
{
    OptionModel *model = self.optionModels[self.selectedOptionIndex];
    return model.serviceDurationInMin;
}

- (BOOL)isAnySelectionMade
{
    return (self.selectedOptionIndex >= 0);
}

@end
