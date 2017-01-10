#import "CategroyModel.h"
#import "TotalCostDetailModel.h"
#import "SubCategoryModel.h"
#import "TaxManager.h"
#import "Constant.h"
#import "TypeModel.h"
#import "OptionModel.h"

@implementation CategroyModel
{
    CGFloat taxAmount;
}

- (instancetype)init
{
    self = [super init];
    
    [[TaxManager sharedInstance] currentTax:^(BOOL success, CGFloat tax) {
        if (success)
        {
            taxAmount = tax;
        }else
        {
            taxAmount = [[NSUserDefaults standardUserDefaults] floatForKey:kCURRENT_TAX_KEY];
        }
    }];
    
    return self;
}

- (NSArray *)totalCostDetailObjects
{
    if (self.selectedSubCats.count)
    {
        if (self.isInspectionRequired)
        {
            TotalCostDetailModel *model = [[TotalCostDetailModel alloc] init];
            model.cost = [self totalWithoutTax];
            model.serviceName = [self descriptionOfSelection];

            return @[model];
        }
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.selectedSubCats.count];
        for (SubCategoryModel *subCat in self.selectedSubCats)
        {
            if (subCat.multiSelection)
            {
                for (TypeModel *aType in subCat.typeModels)
                {
                    if (aType.selected)
                    {
                        TotalCostDetailModel *model = [[TotalCostDetailModel alloc] init];
                        model.cost = [aType priceOfSelecltion];
                        model.serviceName = [NSString stringWithFormat:@"%@ (%@)", subCat.serviceTitle, aType.serviceTitle];
                        [array addObject:model];
                    }
                }
            }else
            {
                TotalCostDetailModel *model = [[TotalCostDetailModel alloc] init];
                model.cost = [subCat priceOfSelections];
                model.serviceName = [subCat descriptionOfSelection];
                [array addObject:model];
            }
        }
        
        return array;
    }
    
    return nil;
}

- (CGFloat)totalWithoutTax
{
    CGFloat total = 0.0;
    for (SubCategoryModel *subCat in self.selectedSubCats)
    {
        total += [subCat priceOfSelections];
    }
    
    return total;
}


- (CGFloat)totalCostOfSerivce
{
    CGFloat sum = [self totalWithoutTax];
    sum += sum * taxAmount/100;
    return sum;
}

- (CGFloat)totalCostAfterDisount
{
    if (self.hasAppliedCoupon)
    {
        CGFloat total =  [self totalCostOfSerivce] - self.couponDiscountValue;
        return total;
    }
    
    return [self totalCostOfSerivce];
}

//- (CGFloat)totalWithoutTax
//{
//    CGFloat sum = 0.0;
//    for (TotalCostDetailModel *model in self.detailArray)
//    {
//        sum += model.cost;
//    }
//    
//    return sum;
//}


- (NSInteger)maxServiceDuration
{
    NSInteger maxDuration = 0;
    
    for (SubCategoryModel *category in self.selectedSubCats)
    {
        NSInteger categoryMax = [category maxServiceDuration];
        if (maxDuration < categoryMax)
        {
            maxDuration = categoryMax;
        }
    }
    
    return maxDuration;
}

- (NSString *)descriptionOfSelection
{
    if (self.isInspectionRequired)
    {
//        SubCategoryModel *selectedSub = [self.selectedSubCats firstObject];//if inspection, always take the first element of array of sub elemnts
//        TypeModel *typeModel = [selectedSub.typeModels firstObject];
//        OptionModel *optionModel = typeModel.optionModels[typeModel.selectedOptionIndex];
//        NSString *name = [NSString stringWithFormat:@"%@ (%@)", self.name, [optionModel descriptionOfSelection]];
        NSString *name = [NSString stringWithFormat:@"%@ (Inspection)", self.name];

        return name;
    }
    NSMutableString *mutString = [[NSMutableString alloc] init];
    
    for (int i = 0; i < self.selectedSubCats.count; i++)
    {
        SubCategoryModel *subCat = self.selectedSubCats[i];
        
        if (subCat.multiSelection)
        {
            for (TypeModel *aType in subCat.typeModels)
            {
                if (aType.selected)
                {
//                    TotalCostDetailModel *model = [[TotalCostDetailModel alloc] init];
//                    model.cost = [subCat priceOfSelections];
//                    model.serviceName = [NSString stringWithFormat:@"%@ (%@)", subCat.serviceTitle, aType.serviceTitle];
                    [mutString appendString:[NSString stringWithFormat:@"%@ (%@)\n", subCat.serviceTitle, aType.serviceTitle]];
                }
            }
        }else {
            [mutString appendString:[subCat descriptionOfSelection]];
            if (i < self.selectedSubCats.count - 1)
            {
                [mutString appendString:@"\n"];
            }
        }
    }

    return mutString;
}

- (BOOL)isAnySelectionMade
{
    for (SubCategoryModel *subCat in self.selectedSubCats)
    {
        if (![subCat isAnySelectionMade])
        {
            return NO;
        }
    }
    
    return self.selectedSubCats.count > 0;
}

@end
