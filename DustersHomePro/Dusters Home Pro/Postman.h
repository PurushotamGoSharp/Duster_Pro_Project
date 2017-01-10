#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
@interface Postman : NSObject
@property(strong,nonatomic)AFHTTPRequestOperationManager *manager;
- (void)post:(NSString *)URLString withParameters:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)put:(NSString *)URLString withParameters:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)get:(NSString *)URLString withParameters:(NSString *)parameter success:(void(^)(AFHTTPRequestOperation *operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
