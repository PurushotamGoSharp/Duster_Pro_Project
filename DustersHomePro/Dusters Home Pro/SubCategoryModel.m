#import "SubCategoryModel.h"
#import "TypeModel.h"
#import "AppDelegate.h"
#import "OptionModel.h"

#define SINGLE_SELC_HEIGHT_WITHOUT_TABLEVIEW 84 //4+17+4+1+8+40+8
#define SINGLE_SELC_INSPEC_H_WITHOUT_TABLEVIEW_N_DESC 43
#define SINGLE_SELC_HEIGHT_OF_CHOISE_CELL 36

#define MULTI_SELC_HEIGHT_WITHOUT_TABLEVIEW 29

@implementation SubCategoryModel

- (CGFloat)cellHeight
{
    if (self.isInspectionRequired)
    {
        AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        CGFloat widthOflabel = appDel.window.frame.size.width - 24;
        CGFloat height = [self.insepectionDescription boundingRectWithSize:(CGSizeMake( widthOflabel, NSIntegerMax))
                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        height += 38;
        return height;
    }
    
    CGFloat height = 0.0f;
    
    if (self.multiSelection)
    {
        for (TypeModel *type in self.typeModels)
        {
            height += [type cellHeight];
        }
        
        height += MULTI_SELC_HEIGHT_WITHOUT_TABLEVIEW;
    }else
    {
        TypeModel *selectedType = self.typeModels[self.selectedTypeIndex];
        if (selectedType.isInspectionRequired)
        {
            CGFloat widthOfLabel = [[UIApplication sharedApplication].delegate window].bounds.size.width;
            widthOfLabel -= 32;
            height = SINGLE_SELC_INSPEC_H_WITHOUT_TABLEVIEW_N_DESC + (self.typeModels.count * SINGLE_SELC_HEIGHT_OF_CHOISE_CELL);
            height += [selectedType.insepectionDescription boundingRectWithSize:(CGSizeMake(widthOfLabel, NSIntegerMax)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;

        }else
        {
            height = SINGLE_SELC_HEIGHT_WITHOUT_TABLEVIEW + (self.typeModels.count * SINGLE_SELC_HEIGHT_OF_CHOISE_CELL);
            
            OptionModel *selectedOptionModel = selectedType.optionModels[selectedType.selectedOptionIndex];
            if (selectedOptionModel.isInspectionRequired)
            {
                CGFloat widthOfLabel = [[UIApplication sharedApplication].delegate window].bounds.size.width;
                widthOfLabel -= 32;
                height += [selectedOptionModel.insepectionDescription boundingRectWithSize:(CGSizeMake(widthOfLabel, NSIntegerMax)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
            }
        }
    }
    
    return height;
}

- (CGFloat)priceOfSelections
{
    if (self.typeModels.count == 0)
    {
        return 0.0;
    }
    
    if (self.multiSelection)
    {
        CGFloat price = 0.0;
//        for (NSIndexPath *indexPath in self.selectedIndexPaths)
//        {
//            TypeModel *model = self.typeModels[indexPath.row];
//            price += [model priceOfSelecltion];
//        }
        
        for (TypeModel *model in self.typeModels)
        {
            if (model.selected)
            {
                price += [model priceOfSelecltion];
            }
        }
        
        return price;
    }
    
    TypeModel *model = self.typeModels[self.selectedTypeIndex];
    return [model priceOfSelecltion];
}

- (NSString *)descriptionOfSelection
{
    if (self.isInspectionRequired)
    {
        return self.serviceTitle;
    }
    NSMutableString *mutString = [[NSMutableString alloc] init];
    if (self.multiSelection)
    {
        [mutString appendFormat:@"%@ (",self.serviceTitle];
        
        for (int i = 0; i < self.typeModels.count; i++)
        {
            TypeModel *model = self.typeModels[i];
            
            if (model.selected)
            {
//                OptionModel *option = model.optionModels[model.selectedOptionIndex];
//                [mutString appendFormat:@"%@ - %@",model.serviceTitle, option.serviceTitle];
                [mutString appendFormat:@"%@",model.serviceTitle];

                if (i < self.typeModels.count - 1)
                {
                    [mutString appendFormat:@", "];
                }
            }
        }
        
        [mutString appendString:@")"];

        return mutString;
    }
    
    TypeModel *model = self.typeModels[self.selectedTypeIndex];
//    OptionModel *option = model.optionModels[model.selectedOptionIndex];
//    NSString *description = [NSString stringWithFormat:@"%@(%@ - %@)", self.serviceTitle, model.serviceTitle, [option descriptionOfSelection]];
    NSString *description = [NSString stringWithFormat:@"%@ (%@)", self.serviceTitle, model.serviceTitle];

    return description;
}

- (NSInteger)maxServiceDuration
{
    NSInteger maxDuration = 0;
    
    if (self.multiSelection)
    {
        for (TypeModel *model in self.typeModels)
        {
            if (model.selected)
            {
                NSInteger modelMax = [model maxServiceDuration];
                if (maxDuration < modelMax)
                {
                    maxDuration = modelMax;
                }
            }
        }
    }else
    {
        TypeModel *model = self.typeModels[self.selectedTypeIndex];
        maxDuration = [model maxServiceDuration];
    }
    
    
    return maxDuration;
}

- (BOOL)isAnySelectionMade
{
    if (self.multiSelection)
    {
        for (TypeModel *typeModel in self.typeModels)
        {
            if (typeModel.selected)
            {
                return YES;
            }
        }
        return NO;
    }
    
    return (self.selectedTypeIndex >= 0);
}

@end
