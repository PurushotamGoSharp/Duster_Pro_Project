#import "BookingSummaryView.h"
#import "AppDelegate.h"
#import "TotalCostDetailModel.h"
@implementation BookingSummaryView
{
    UIView *xibView;
    UIControl *alphaView;
    NSDateFormatter *dateFormatter;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"BookingSummaryView" owner:self options:nil] firstObject];
    [self addSubview:view];
    [view setFrame:[self bounds]];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"view":view};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[view]-(0)-|"
                                                                   options:kNilOptions
                                                                   metrics:nil
                                                                     views:views];
    [self addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
                                                          options:kNilOptions
                                                          metrics:nil
                                                            views:views];
    [self addConstraints:constraints];
    
    NSLayoutConstraint *heightConst = [NSLayoutConstraint constraintWithItem:self
                                                             attribute:(NSLayoutAttributeHeight)
                                                             relatedBy:NSLayoutRelationLessThanOrEqual
                                                                toItem:nil
                                                             attribute:kNilOptions
                                                            multiplier:1.0
                                                              constant:frame.size.height];
    [self addConstraint:heightConst];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:(NSLayoutAttributeWidth)
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:kNilOptions
                                                                 multiplier:1.0
                                                                   constant:frame.size.width];
    [self addConstraint:width];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    

    return self;
}
- (void)initialize
{
    
}

- (void)showView
{
    AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.center = appDel.window.center;
    [_proceedToPayButton setTitle:_buttonTitle forState:UIControlStateNormal];

    BOOL allocationHappened = NO;
    
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:self];
        [alphaView addTarget:self
                      action:@selector(backToBooking)
            forControlEvents:(UIControlEventTouchUpInside)];
        
        allocationHappened = YES;
    }
    
    self.center = alphaView.center;
    [appDel.window addSubview:alphaView];
    
    NSDictionary *viewDict = @{@"alphaView":alphaView, @"self": self, @"superView": appDel.window};
    
    NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[alphaView]-0-|"
                                                                    options:kNilOptions
                                                                    metrics:nil
                                                                      views:viewDict];
    NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[alphaView]-0-|"
                                                                    options:kNilOptions
                                                                    metrics:nil
                                                                      views:viewDict];
    [appDel.window addConstraints:constraintsH];
    [appDel.window addConstraints:constraintsV];
    
    if (allocationHappened)
    {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                      attribute:(NSLayoutAttributeCenterX)
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:alphaView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0
                                                                       constant:0];
        [alphaView addConstraint:constraint];
        
        constraint = [NSLayoutConstraint constraintWithItem:self
                                                  attribute:(NSLayoutAttributeCenterY)
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:alphaView
                                                  attribute:NSLayoutAttributeCenterY
                                                 multiplier:1.0
                                                   constant:-20];
        [alphaView addConstraint:constraint];
    }
    
    [self defaultValues];
    [self.scrollView layoutIfNeeded];
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews)
        contentRect = CGRectUnion(contentRect, view.frame);

    self.scrollViewHeightConst.constant = contentRect.size.height;
    [alphaView layoutIfNeeded];
}

- (void)defaultValues
{
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    self.dateLabel.text = self.selectTimeAndDate[1];
    NSString *startTime = self.selectTimeAndDate[0];
    dateFormatter.dateFormat = @"hh:mm a";
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    NSDate *endDate = [startDate dateByAddingTimeInterval:[self.categoryModel maxServiceDuration]*60];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", startTime, [dateFormatter stringFromDate:endDate]];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *array=[defaults valueForKey:@"login"];
    self.mobileNumber.text=array[1];
    self.contactPerson.text=array[0];
    self.address.text=[NSString stringWithFormat:@"%@, %@, %@",self.userModel.street,self.userModel.city,self.userModel.pincode];
    self.itemTypeLabel.text = [self.categoryModel descriptionOfSelection];
    _costLabel.text=[NSString stringWithFormat:@"%@",_totalCostString];
}

- (IBAction)proceedToPay:(id)sender
{
    [self.delegateForPayNow makeOrder];
    [alphaView removeFromSuperview];
}

- (void)backToBooking
{
  [alphaView removeFromSuperview];
}
- (IBAction)backToService:(id)sender
{
    [alphaView removeFromSuperview];
    [self.delegate backToService];
}
@end
