#import "SubCategory.h"
#import "SubcategoryTypeModel.h"
#import "Constant.h"
#import "Postman.h"
#import "SubcategoryTypeModel.h"
@implementation SubCategory
{
    Postman *postman;
    NSMutableArray *servicesArray,*servicesCodeArray;
    SubcategoryTypeModel *model;
}
-(void)getServiceType:(NSArray*)subCategoryCode{
    postman =[[Postman alloc]init];
    servicesArray=[[NSMutableArray alloc]init];
    servicesCodeArray=[[NSMutableArray alloc]init];
    for (NSString *url in subCategoryCode) {
        [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self parseResponseObject:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}
-(void)parseResponseObject:(id)responseObject{
    NSDictionary *responseDict=responseObject;
    NSDictionary *viewDict=responseDict[@"ViewModels"];
    if ([viewDict[@"Status"] intValue]==1) {
        NSDictionary *serviceTypes=viewDict[@"ServiceType"];
    for (NSDictionary *dict in serviceTypes[@"ViewModels"]) {
      model =[[SubcategoryTypeModel alloc]init];
        model.serviceTitle=dict[@"Name"];
        model.code=dict[@"Code"];
        [servicesArray addObject:model];
        [servicesCodeArray addObject:model.code];
    }
        [model getTypeOfServices:serviceTypes withServiceCodeArray:servicesCodeArray];
}
}
@end
