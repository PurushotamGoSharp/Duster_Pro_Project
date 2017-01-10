#import "GetImageModel.h"
#import "Constant.h"
#import "Postman.h"
#import "VMEnvironment.h"

@implementation GetImageModel
{
    Postman *postman;
}

- (void)getJsonData:(NSArray *)documentDetail
        onComplete:(void (^)(UIImage *image))successBlock
           onError:(void (^)(NSError *error))errorBlock {
    if (documentDetail.count)
    {
        NSDictionary *dict=[documentDetail lastObject];
        NSString *code= dict[@"Code"];
        NSString *fileName=dict[@"FileName"];
        NSString *extension=[fileName pathExtension];
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) ;
        NSString *pathForImage = [path[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",code,extension]];
        BOOL fileExist=[[NSFileManager defaultManager]fileExistsAtPath:pathForImage];
//        NSLog(@"%@",pathForImage);
        if (fileExist) {
            UIImage *image=[UIImage imageWithContentsOfFile:pathForImage];
            successBlock(image);
        }
        else{
            postman=[[Postman alloc]init];
            NSString *url=[NSString stringWithFormat:@"%@%@%@",base_url,getImageOfCategoryURL,code];
            [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                UIImage *image = [self processForImage:responseObject withCode:code];
                successBlock(image);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                errorBlock(error);
            }];
        }
        
    }else
    {
        errorBlock(nil);
    }
}

-(UIImage*)processForImage:(id)responseObject withCode:(NSString*)code{
    NSDictionary *dict=responseObject;
    if ([dict[@"Success"] integerValue]==1) {
        NSString *fileName = dict[@"FileName"];
        NSString *extension = [fileName pathExtension];
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) ;
        NSString *pathForImage = [path[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",code,extension]];
        NSString *str=[dict[@"Base64Model"]objectForKey:@"Image"];
        NSData *imgData = [[NSData alloc]initWithBase64EncodedString:str options:0];
        [imgData writeToFile:pathForImage atomically:YES];
        UIImage *image=[UIImage imageWithData:imgData];
        return image;
    }
    else return nil;
}
@end
