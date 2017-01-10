
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CategroyModel : NSObject

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *documentDetails;
@property(strong,nonatomic)NSString *DayStartTime;
@property(strong,nonatomic)NSString *DayEndTime;

@property (strong, nonatomic) NSArray *allSubCategories;
@property (strong, nonatomic) NSArray *selectedSubCats;
@property(strong,nonatomic) UIImage *imageOfCategory;
@property(assign,nonatomic) BOOL isInspectionRequired;

@property (assign, nonatomic) BOOL hasAppliedCoupon;
@property (assign, nonatomic) CGFloat couponDiscountValue;
@property (assign, nonatomic) CGFloat couponDiscountPercentage;
@property(strong,nonatomic) NSString *couponCode;

@property (strong, nonatomic) NSString *orderCode;

- (NSArray *)totalCostDetailObjects;
- (NSInteger)maxServiceDuration;
- (NSString *)descriptionOfSelection;

- (CGFloat)totalWithoutTax;
- (CGFloat)totalCostAfterDisount;
- (CGFloat)totalCostOfSerivce;

- (BOOL)isAnySelectionMade;

@end
