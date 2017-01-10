#import "TotalCostDetailView.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "TaxManager.h"
#import "Postman.h"

#define COUPON_VALIDATION_API @"http://115.249.140.234:8034/CouponService.svc/IsCouponValid?"

@interface TotalCostDetailView () <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *more;

@property (strong, nonatomic) IBOutlet UIImageView *moreImageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIView *costDetailView;
@property (assign, nonatomic) IBOutlet TotalCostDetailTableViewCell *customCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponHeightConst;
@property (weak, nonatomic) IBOutlet UITextField *couponTextField;
@property (weak, nonatomic) IBOutlet UILabel *successfullyAppliedStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *successCouponView;

@end

@implementation TotalCostDetailView
{
    UIView *view;
    UIControl  *alphaView;
    CGFloat frameforXibViewHeight;
    BOOL shownDetails;
    
    CGFloat taxAmount;
    Postman *postman;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])){
        UIView *subView = [[[NSBundle mainBundle] loadNibNamed:@"TotalCostDetail"
                                                         owner:self
                                                       options:nil] objectAtIndex:0];
        [self addSubview: subView];
        subView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = NSDictionaryOfVariableBindings(subView);
        
        NSArray *constrains = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[subView]-(0)-|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:views];
        [self addConstraints:constrains];
        
        constrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[subView]-(0)-|"
                                                             options:kNilOptions
                                                             metrics:nil
                                                               views:views];
        [self addConstraints:constrains];
        
        [[TaxManager sharedInstance] currentTax:^(BOOL success, CGFloat tax) {
            if (success)
            {
                taxAmount = tax;
            }else
            {
                taxAmount = [[NSUserDefaults standardUserDefaults] floatForKey:kCURRENT_TAX_KEY];
            }
        }];
        
        self.tableView.tableFooterView = [UIView new];
        self.couponHeightConst.constant = 0;
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 30;
        
        self.couponTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Promotional/Voucher code" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]; ;
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.catModel.hasAppliedCoupon)
    {
        return _detailArray.count?self.detailArray.count+2:0;
    }
    return _detailArray.count?self.detailArray.count+1:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TotalCostDetailTableViewCell *cell = (TotalCostDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TotalCostDetailTableViewCell" owner:self options:nil];
        cell = _customCell;
        _customCell = nil;
    }
    
    if (indexPath.row < self.detailArray.count)
    {
        TotalCostDetailModel *model = _detailArray[indexPath.row];
        cell.dataLabel.text = model.serviceName;
        cell.costLabel.text = [NSString stringWithFormat:@"%@%.2f", kRUPPEE_SYMBOL,model.cost];
    }else if (indexPath.row == self.detailArray.count)
    {
        cell.dataLabel.text = [NSString stringWithFormat:@"Tax (%.1f%%)",taxAmount];
        cell.costLabel.text = [NSString stringWithFormat:@"%@%.2f", kRUPPEE_SYMBOL,[self totalWithoutTax] * taxAmount/100];
    }else
    {
        cell.dataLabel.text = [NSString stringWithFormat:@"%@ offer (%.1f%%)",self.catModel.couponCode,self.catModel.couponDiscountPercentage];
        cell.costLabel.text = [NSString stringWithFormat:@"-%@%.2f", kRUPPEE_SYMBOL,self.catModel.couponDiscountValue];
    }

    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 30;
//}

- (void)setUpForShowDetails
{
    _costDetailView.hidden=NO;
    _more.selected=YES;
    _moreImageView.image=[UIImage imageNamed:@"More-button-selected"];
    shownDetails = YES;
}

- (void)setUpForHideDetails
{
    _costDetailView.hidden=YES;
    _more.selected=NO;
    _moreImageView.image=[UIImage imageNamed:@"More-button"];
    shownDetails = NO;
}

- (void)setCatModel:(CategroyModel *)catModel
{
    _catModel = catModel;
    
    if (catModel.hasAppliedCoupon)
    {
        [self showSuccessCouponStatusView];
    }else
    {
        [self hideSuccessCouponStatusView];
    }
}

- (void)setShowCouponEntry:(BOOL)showCouponEntry
{
    _showCouponEntry = showCouponEntry;
    if (showCouponEntry)
    {
        self.couponHeightConst.constant = 40;
    }else
    {
        self.couponHeightConst.constant = 0;
    }
    
    CGFloat height = [self heightOfView];
    [self.delegateForHeightofCostDetailView getHeightOfCostDetailView:height];
}

- (IBAction)more1:(id)sender
{
    if (self.detailArray.count > 0 && !self.more.isSelected)
    {
        [self setUpForShowDetails];
        CGFloat height = [self heightOfViewFor:YES];
        [self.delegateForHeightofCostDetailView getHeightOfCostDetailView:height];
        
    }else if (self.more.isSelected)
    {
        [self close:nil];
    }
}

- (IBAction)close:(id)sender
{
    [self setUpForHideDetails];
    CGFloat height = [self heightOfViewFor:NO];
    [self.delegateForHeightofCostDetailView getHeightOfCostDetailView:height];
}

- (CGFloat)heightOfView
{
    return [self heightOfViewFor:shownDetails];
}

- (CGFloat)heightOfViewFor:(BOOL)state
{
    if (state)
    {
        CGFloat height = self.tableView.contentSize.height + 121;
        
        if (height>269)
        {
            height = 269;
        }
        if (self.showCouponEntry)
            height += 40;
        
        return height;
    }
    
    if (self.showCouponEntry)
        return 44 + 40;
    
    return 44;
}

- (void)updateView
{
    self.totalCost.text = [NSString stringWithFormat:@"%@%.2f", kRUPPEE_SYMBOL,[self totalCostAfterDisount]];
    [self.tableView reloadData];
//    [self.delegateForHeightofCostDetailView getHeightOfCostDetailView:[self heightOfView]];
}

- (CGFloat)totalCostOfSerivce
{
    CGFloat sum = [self totalWithoutTax];
    sum += sum * taxAmount/100;
    return sum;
}

- (CGFloat)totalCostAfterDisount
{
    if (self.catModel.hasAppliedCoupon)
    {
        CGFloat total =  [self totalCostOfSerivce] - self.catModel.couponDiscountValue;
        return total;
    }
    
    return [self totalCostOfSerivce];
}

- (CGFloat)totalWithoutTax
{
    CGFloat sum = 0.0;
    for (TotalCostDetailModel *model in self.detailArray)
    {
        sum += model.cost;
    }

    return sum;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegateForHeightofCostDetailView showingKeyboardFor:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegateForHeightofCostDetailView hideKeyboardFor:textField];
}

- (IBAction)applyCoupon:(UIButton *)sender
{
    [self endEditing:YES];
    if (postman == nil)
    {
        postman = [[Postman alloc] init];
    }
    if ([self.delegateForHeightofCostDetailView respondsToSelector:@selector(applyingCoupon)])
    {
        [self.delegateForHeightofCostDetailView applyingCoupon];
    }
    
    NSString *parameter = [NSString stringWithFormat:@"{\"CouponCode\":\"%@\"}", self.couponTextField.text];
    [postman post:COUPON_VALIDATION_API withParameters:parameter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [self parseCouponResponse:responseObject];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if ([self.delegateForHeightofCostDetailView respondsToSelector:@selector(failedToApplyCoupon:)])
              {
                  [self.delegateForHeightofCostDetailView failedToApplyCoupon:nil];
              }
          }];
}

- (void)parseCouponResponse:(id)response
{
    if ([response[@"Status"] boolValue])
    {
        self.catModel.hasAppliedCoupon = YES;
        self.catModel.couponDiscountPercentage = [response[@"CouponValue"] integerValue];
        self.catModel.couponDiscountValue = [self totalCostOfSerivce] * self.catModel.couponDiscountPercentage/100;
        self.catModel.couponCode = self.couponTextField.text;
        self.couponTextField.text = @"";
        
        [self showSuccessCouponStatusView];
        
        [self.tableView reloadData];
        [self updateView];
        
        if ([self.delegateForHeightofCostDetailView respondsToSelector:@selector(successfullyAppledCoupun:)])
        {
            [self.delegateForHeightofCostDetailView successfullyAppledCoupun:[response[@"CouponValue"] integerValue]];
        }
    }else
    {
        if ([self.delegateForHeightofCostDetailView respondsToSelector:@selector(failedToApplyCoupon:)])
        {
            [self.delegateForHeightofCostDetailView failedToApplyCoupon:response[@"Message"]];
        }
    }
}

- (void)showSuccessCouponStatusView
{
    self.successfullyAppliedStatusLabel.text = [NSString stringWithFormat:@"Promotional code %@ Accepted (%@%.2f)",self.catModel.couponCode, kRUPPEE_SYMBOL, self.catModel.couponDiscountValue];
    self.successCouponView.hidden = NO;
}

- (void)hideSuccessCouponStatusView
{
    self.successCouponView.hidden = YES;
}

@end
