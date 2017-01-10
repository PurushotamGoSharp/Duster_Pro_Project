#import "SubcategoryTypeModel.h"
#import "SubcategoryOptionModel.h"
@implementation SubcategoryTypeModel

-(void)getTypeOfServices:(NSDictionary*)serviceType withServiceCodeArray:(NSArray*)servicesCodeArray{
    NSMutableArray *optionArray=[[NSMutableArray alloc]init];
    for (NSDictionary *serviceDict in serviceType[@"ViewModels"]) {
        if ([servicesCodeArray containsObject:serviceDict[@"Code"]]) {
            if ([serviceDict[@"Status"] intValue]==1) {
                NSDictionary *optionDict=serviceDict[@"Options"];
                for (NSDictionary *dict in optionDict[@"ViewModels"]) {
                    SubcategoryOptionModel *model=[[SubcategoryOptionModel alloc]init];
                    model.code=dict[@"Code"];
                    model.serviceTitle=dict[@"Name"];
                    [optionArray addObject:model];
                }
            }
        }
    }
}
@end
