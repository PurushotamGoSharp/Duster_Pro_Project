#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GetImageModel : NSObject
-(void)getJsonData:(NSArray *)documentDetail
        onComplete:(void (^)(UIImage *image))successBlock
           onError:(void (^)(NSError *error))errorBlock;
@end
