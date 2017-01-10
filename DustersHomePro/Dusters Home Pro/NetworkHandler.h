#import <Foundation/Foundation.h>

@interface NetworkHandler : NSObject

- (void)getSubCatergoiesFor:(NSString *)categoryCode withCompletionBlock:(void (^)(BOOL success, NSArray *subCategories))completionHandler;

- (NSArray *)parseResponseObject:(NSDictionary *)response;


@end
