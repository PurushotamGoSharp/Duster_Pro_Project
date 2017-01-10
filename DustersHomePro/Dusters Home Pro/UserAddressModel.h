
#import <Foundation/Foundation.h>
@interface UserAddressModel : NSObject
@property(strong,nonatomic)NSString *code;
@property(strong,nonatomic)NSString *address;
@property(strong,nonatomic)NSString *pincode;
@property(assign,nonatomic)NSInteger userID;
@property(strong,nonatomic)NSString *street;
@property(strong,nonatomic)NSString *street2;

@property(strong,nonatomic)NSString *city;
@property(strong,nonatomic)NSString *country;
@property(strong,nonatomic)NSNumber *ID;
@property(strong,nonatomic)NSString *cityCode;
@property(strong,nonatomic)NSString *area;

@end
