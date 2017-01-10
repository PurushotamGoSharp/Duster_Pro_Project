#import "BookingModel.h"
#import "BookedJobModel.h"

@implementation BookingModel

- (NSString *)orderName
{
    if (self.isInspection) {
        return _orderName;
    }
    
    NSMutableString *mutName = [[NSMutableString alloc] init];
    NSInteger counter = 0;
    for (BookedJobModel *aJob in self.jobsArray)
    {
        counter++;
        [mutName appendFormat:@"%@ - %@ - %@", aJob.subCategoryName, aJob.serviceTypeName, aJob.optionName];
        if (counter != self.jobsArray.count)
        {
            [mutName appendString:@", "];
        }
    }
    
    return mutName;
}

- (CGFloat)totalOfAll
{
    if (!self.isParentOrder)
    {
        return [self totalAfterDiscount];
    }
    return _totalOfAll;
}

- (CGFloat)totalAmount
{
    CGFloat total = self.estPrice + self.estPrice*self.taxForOrder/100;
    return total;
}

- (CGFloat)totalAfterDiscount
{
    CGFloat total = [self totalAmount] - self.couponValue;
    
    return total;
}

- (CGFloat)dueOfAllRelatedOrder
{
    if (self.isParentOrder)
    {
        return self.totalOfAll - [self paidAmount];
    }
    
    return 0;
}

- (CGFloat)paidAmount
{
    CGFloat paidAmount = 0;
    NSArray *paymentsArray = self.extraJSONDict[@"TransactionDetails"][@"PaymentDetails"];

    for (NSDictionary *payment in paymentsArray)
    {
        paidAmount += [payment[@"Amount"] floatValue];
    }
    
    return paidAmount;
}

- (BOOL)hasAnyChildOrders
{
    if (self.isParentOrder)
    {
        return (self.totalOfAll - self.actPrice) > 0.01;
    }
    
    return NO;
}

- (CGFloat)estPriceOfChildOrders
{
    if (self.relatedOrders.count == 0)
    {
        return 0.0;
    }
    
    CGFloat estChildPrice = 0.0f;
    for (BookingModel *aModel in self.relatedOrders)
    {
        estChildPrice += aModel.estPrice;
    }
    
    estChildPrice -= self.estPrice;
    
    return estChildPrice;
}

- (CGFloat)discountOfAlRelatedOnes
{
    CGFloat discount = 0.0f;
    for (BookingModel *aModel in self.relatedOrders)
    {
        discount += aModel.discountGiven;
    }
    return discount;
}

@end
