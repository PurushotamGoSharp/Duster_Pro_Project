#import <UIKit/UIKit.h>
#import "UserAddressModel.h"

@interface BookingModel : NSObject

@property (strong, nonatomic) NSString *code;
@property (assign, nonatomic) NSInteger bookID;
@property (strong, nonatomic) NSString *orderName;

@property (strong, nonatomic) NSString *categoryCode;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSDate *categoryStartTime;
@property (strong, nonatomic) NSDate *categoryEndTime;

@property (strong, nonatomic) NSString *orderStatusCode;
@property (strong, nonatomic) NSDate *plannedStartDate;
@property (strong, nonatomic) NSDate *actualStartDate;
@property (strong, nonatomic) NSDate *actualEndTime;

@property (assign, nonatomic) CGFloat estPrice;
@property (assign, nonatomic) CGFloat actPrice;
@property (strong, nonatomic) NSArray *paymentsArray;

@property (assign, nonatomic) CGFloat dueAmount;//due of current Order alone
- (CGFloat)dueOfAllRelatedOrder;//it will give total due of Parent + all Child orders

@property (assign, nonatomic) CGFloat estHours;
@property (assign, nonatomic) CGFloat taxForOrder;

@property (assign, nonatomic) BOOL hasCoupon;
@property (assign, nonatomic) CGFloat couponPercentage;
@property (assign, nonatomic) CGFloat couponValue;
@property (strong, nonatomic) NSString *couponCode;

@property (assign, nonatomic) CGFloat discountGiven;

@property (assign, nonatomic) NSInteger serviceProviderId;
@property (strong, nonatomic) NSString *serviceProviderName;
@property (strong, nonatomic) NSString *serviceProviderCode;
@property (strong, nonatomic) NSString *serviceProviderMobile;
@property (strong, nonatomic) NSString *serviceProviderAdress;
@property (strong, nonatomic) NSArray *imageData;
@property (strong, nonatomic) UIImage *serviceProviderImage;

@property (assign, nonatomic) NSInteger customerID;
@property (strong, nonatomic) NSString *customerCode;
@property (strong, nonatomic) NSString *customerName;

@property (assign, nonatomic) NSInteger rating;

@property (strong, nonatomic) NSDictionary *extraJSONDict;

@property (assign, nonatomic) CGFloat totalOfAll;//Total of related order (Parent + Children)
- (CGFloat)totalAmount;//Total of the current Order
- (CGFloat)totalAfterDiscount; //Total of the current Order
- (CGFloat)paidAmount;

@property(strong,nonatomic) NSString *dateAndTime;
@property(strong,nonatomic) UserAddressModel *userAddressModel;
@property(strong,nonatomic) NSString *date;
@property(strong,nonatomic) NSArray *jobsArray;

@property (assign, nonatomic) BOOL isParentOrder;
@property (strong, nonatomic) NSString *referenceCode;
@property(strong,nonatomic) NSArray *relatedOrders;//this will include Parent + Children orders(VALID ONLY FOR PARENT ORDER)
- (BOOL)hasAnyChildOrders;
- (CGFloat)estPriceOfChildOrders;//(VALID ONLY FOR PARENT ORDER)

@property (assign, nonatomic) BOOL canReschedule;

@property (assign, nonatomic) BOOL isInspection;
- (CGFloat)discountOfAlRelatedOnes;

@end
