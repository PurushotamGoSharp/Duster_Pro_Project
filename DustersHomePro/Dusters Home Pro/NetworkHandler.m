#import "NetworkHandler.h"
#import "Postman.h"
#import "Constant.h"
#import "SubCategoryModel.h"
#import "TypeModel.h"
#import "OptionModel.h"
#import "GetImageModel.h"
#import "VMEnvironment.h"

#define NULL_CHECKER(X) ([X isKindOfClass:[NSNull class]] ? nil : X)


@implementation NetworkHandler
{
    Postman *postMan;
}

- (id)init
{
    if (self = [super init])
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    postMan = [[Postman alloc] init];
}

- (void)getSubCatergoiesFor:(NSString *)categoryCode withCompletionBlock:(void (^)(BOOL success, NSArray *subCategories))completionHandler
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@/%@%@",base_url,getAllCategoriesURL,categoryCode,getAllSubCategoriesUnderCategoryURL];
    
    [postMan get:URLString withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = [self parseResponseObject:responseObject];
        
        if (array)
        {
            completionHandler(YES, array);
        }else {
            completionHandler(NO, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionHandler(NO, nil);
    }];
}

- (NSArray *)parseResponseObject:(NSDictionary *)response
{
    if ([response[@"Success"] boolValue])
    {
        NSArray *viewModelArray = response[@"ViewModels"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:viewModelArray.count];
        
        GetImageModel *getImageModel=[[GetImageModel alloc]init];

        for (NSDictionary *dict in viewModelArray) {
            if ([dict[@"Status"] boolValue]) {
                SubCategoryModel *model = [[SubCategoryModel alloc]init];
                NSDictionary *serviceType = dict[@"ServiceType"];
                model.code = dict[@"Code"];
                model.serviceTitle = dict[@"Name"];
                model.typeModels = [self typeModelsForArray:serviceType[@"ViewModels"]];
                model.documentDetails=dict[@"DocumentDetails"];
                model.isInspectionRequired=[dict[@"IsInspectionrequired"] boolValue];
                if (model.documentDetails.count>0) {
                    [getImageModel getJsonData:model.documentDetails onComplete:^(UIImage *image) {
                        if (image)
                        {
                            model.imageOfSubCategory=image;
                        }
                    } onError:^(NSError *error) {
                        NSLog(@"%@",error);
                    }];
                }

                
                if (dict[@"JSON"]!=[NSNull null]) {
                    NSString *jsonStringForMultiSelect=dict[@"JSON"];
                    NSDictionary *checkMultiselectionDict=[NSJSONSerialization JSONObjectWithData:[jsonStringForMultiSelect dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                    if ([checkMultiselectionDict[@"DisplayType"] isEqualToString:@"Multi Select"]){
                        model.multiSelection = YES;
                    }else  model.multiSelection = NO;
                    
                    model.isInspectionRequired = [checkMultiselectionDict[@"IsInspectionrequired"] boolValue];
                    model.insepectionDescription = checkMultiselectionDict[@"Description"];

                }
                 if (model.typeModels)
                {
                    [array addObject:model];
                }else
                {
                }
            }
        }
        return  array;
    }

    return nil;
}

- (NSArray *)typeModelsForArray:(NSArray *)dictArray
{
    if (dictArray.count == 0)
        return nil;
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in dictArray) {
        if ([dict[@"Status"] boolValue])
        {
            TypeModel *typeModel = [[TypeModel alloc]init];
            typeModel.code = dict[@"Code"];
            typeModel.serviceTitle = dict[@"Name"];
            typeModel.optionModels = [self optionModelsForArray:dict[@"Options"][@"ViewModels"]];
            //        typeModel.isInspectionRequired=[dict[@"IsInspectionrequired"] boolValue];
            NSString *jsonString = NULL_CHECKER(dict[@"JSON"]);
            if (jsonString)
            {
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                                         options:kNilOptions
                                                                           error:nil];
                typeModel.isInspectionRequired = [jsonDict[@"IsInspectionrequired"] boolValue];
                typeModel.insepectionDescription = jsonDict[@"Description"];
            }
            if (typeModel.optionModels)
            {
                [array addObject:typeModel];
            }
        }

    }
    
    if (array.count == 0)
    {
        return nil;
    }
    
    return array;
}

- (NSArray *)optionModelsForArray:(NSArray *)dictArray
{
    if (dictArray.count == 0)
        return nil;
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in dictArray) {
        if ([dict[@"Status"] boolValue])
        {
            OptionModel *model = [[OptionModel alloc]init];
            model.code = dict[@"Code"];
            model.serviceTitle = dict[@"Name"];
            NSString *jsonString = NULL_CHECKER(dict[@"JSON"]);
            if (jsonString)
            {
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                                         options:kNilOptions
                                                                           error:nil];
                model.isInspectionRequired = [jsonDict[@"IsInspectionrequired"] boolValue];
                model.insepectionDescription = jsonDict[@"Description"];
            }
            NSString *serviceDutation = NULL_CHECKER(dict[@"ServiceDuration"]);
            NSArray *durationArray = [serviceDutation componentsSeparatedByString:@":"];
            if (durationArray.count == 3)
            {
                model.serviceDurationInMin = [durationArray[0] integerValue] * 60 + [durationArray[1] integerValue];
            }
            model.servicePrice = [NULL_CHECKER(dict[@"ServicePrice"]) floatValue];
            [array addObject:model];

        }
    }
    return array;
}

@end
