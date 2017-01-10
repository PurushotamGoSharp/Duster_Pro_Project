//
//  PaymentSummary.m
//  Dusters Home Pro
//
//  Created by vmoksha mobility on 06/11/15.
//  Copyright © 2015 shruthib. All rights reserved.
//

#import "PaymentSummary.h"
#import "AppDelegate.h"
#import "PaymentSummaryTableViewCell.h"
#import "Constant.h"
#import "Postman.h"
#import "MBProgressHUD.h"

@interface PaymentSummary () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalValue;
@property (weak, nonatomic) IBOutlet UIButton *proceedToPayBotton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHieghtConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proceedButtonHeightConst;
@property (weak, nonatomic) IBOutlet UILabel *dueAmountLabel;
@property (weak, nonatomic) IBOutlet UIView *dueAmountContainer;
@property (weak, nonatomic) IBOutlet UIView *paidAmountContainer;
@property (weak, nonatomic) IBOutlet UILabel *payedAmountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paidAmountHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dueAmountHeightConst;

@end

@implementation PaymentSummary
{
    UIControl *alphaView;
    NSInteger numberOfCells;
    Postman *postman;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"PaymentSummary" owner:self options:nil] firstObject];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PaymentSummaryTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    return self;
}

- (void)initialize
{
    
}

- (void)show
{
    AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.center = appDel.window.center;
    
    BOOL allocationHappened = NO;
    
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:self];
        [alphaView addTarget:self
                      action:@selector(hide)
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
    
    
    if ([self shouldShowPayUI])
    {
        self.proceedButtonHeightConst.constant = 40;
        self.proceedToPayBotton.hidden = NO;
        [self.proceedToPayBotton setTitle:[NSString stringWithFormat:@"Proceed to Pay (%@%.2f)",kRUPPEE_SYMBOL,[self.bookingModel dueOfAllRelatedOrder]] forState:(UIControlStateNormal)];
    }else
    {
        self.proceedButtonHeightConst.constant = 0;
        self.proceedToPayBotton.hidden = YES;
    }
    
    if ([self hasDue])
    {
        self.dueAmountLabel.text = [NSString stringWithFormat:@"%@%.2f", kRUPPEE_SYMBOL,[self.bookingModel dueOfAllRelatedOrder]];
        self.dueAmountHeightConst.constant = 34.0;

    }else
    {
        self.dueAmountHeightConst.constant = 0.0;
    }
    
    if ([self.bookingModel paidAmount] > 0.001)
    {
        self.paidAmountHeightConst.constant = 25;
        self.payedAmountLabel.text = [NSString stringWithFormat:@"%@%.2f", kRUPPEE_SYMBOL,[self.bookingModel paidAmount]];
    }else
    {
        self.paidAmountHeightConst.constant = 0.0;
    }
    
    [self.tableView reloadData];
    self.tableViewHieghtConst.constant = self.tableView.contentSize.height;
    [alphaView layoutIfNeeded];
    self.totalValue.text = [NSString stringWithFormat:@"%@%.2f",kRUPPEE_SYMBOL,[self.bookingModel totalOfAll]];
}

- (void)hide
{
    [alphaView removeFromSuperview];
}

- (BOOL)shouldShowPayUI
{
    return (self.bookingModel.isParentOrder && [self hasDue]);
}

- (BOOL)hasDue
{
    return ([self.bookingModel dueOfAllRelatedOrder] > 0.001);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    numberOfCells = self.bookingModel.jobsArray.count + 1;
    
    if ([self.bookingModel hasAnyChildOrders])
    {
        numberOfCells++;
    }
    
    if (self.bookingModel.hasCoupon)
    {
        numberOfCells++;
    }
    
    if (self.bookingModel.discountGiven)
    {
        numberOfCells++;
    }
    
    return numberOfCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaymentSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    cell.titleLabel.font = [UIFont systemFontOfSize:14];
//    cell.amountLabel.font = [UIFont systemFontOfSize:14];
    
    NSInteger compensationForChildOrders = 0;
    
    if ([self.bookingModel hasAnyChildOrders])
    {
        compensationForChildOrders = 1;
    }
    
    if (indexPath.row < self.bookingModel.jobsArray.count)
    {
        BookedJobModel *aJob = self.bookingModel.jobsArray[indexPath.row];
        cell.titleLabel.text = [aJob nameOfJob];
        
        if (self.bookingModel.isInspection)//for inspection we are not updating Est in JOB_OBJ in when Quotes are give, only updating Est in ORDER_OBJ
        {
            cell.amountLabel.text = [NSString stringWithFormat:@"%@%.2f",kRUPPEE_SYMBOL,self.bookingModel.estPrice];
            
        }else
        {
            cell.amountLabel.text = [NSString stringWithFormat:@"%@%.2f",kRUPPEE_SYMBOL,aJob.estPrice];
        }
    }else if ((indexPath.row == self.bookingModel.jobsArray.count) && [self.bookingModel hasAnyChildOrders])
    {
        cell.titleLabel.text = @"Child Orders";
        cell.amountLabel.text = [NSString stringWithFormat:@"%@%.2f",kRUPPEE_SYMBOL,[self.bookingModel estPriceOfChildOrders]];

    } else if (indexPath.row == self.bookingModel.jobsArray.count + compensationForChildOrders)
    {
        cell.titleLabel.text = [NSString stringWithFormat:@"Tax (%.2f%%)", self.bookingModel.taxForOrder];
        cell.amountLabel.text = [NSString stringWithFormat:@"%@%.2f",kRUPPEE_SYMBOL,(self.bookingModel.estPrice + [self.bookingModel estPriceOfChildOrders])*self.bookingModel.taxForOrder/100];
    }else
    {
        if (self.bookingModel.hasCoupon)
        {
            if (indexPath.row == self.bookingModel.jobsArray.count + 1 + compensationForChildOrders)
            {
                cell.titleLabel.text = self.bookingModel.couponCode;
                cell.amountLabel.text = [NSString stringWithFormat:@"-%@%.2f", kRUPPEE_SYMBOL,self.bookingModel.couponValue];
            }
        }
        
        if (self.bookingModel.discountGiven)
        {
            if (indexPath.row == numberOfCells - 1 )
            {
                cell.titleLabel.text = @"Discount Given";
                cell.amountLabel.text = [NSString stringWithFormat:@"-%@%.2f", kRUPPEE_SYMBOL,[self.bookingModel discountOfAlRelatedOnes] ];
            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (IBAction)proceedToPay:(UIButton *)sender
{
    [self.delegate payDueBtnTapped:self];
    
    return;
}

- (void)parseUpdatePaymentResponse:(id)response
{
    if ([response[@"Success"] boolValue])
    {
        [self.delegate successfullyPayedDue:self];
        [self hide];
    }else
    {
        [self toastMessage:response[@"Message"]];
    }
}

- (void)toastMessage:(NSString *)message
{
    MBProgressHUD *hubHUD = [MBProgressHUD showHUDAddedTo:alphaView animated:YES];
    hubHUD.mode = MBProgressHUDModeText;
    hubHUD.detailsLabelText = message;
    hubHUD.detailsLabelFont = [UIFont systemFontOfSize:15];
    hubHUD.margin = 20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:1];
}

@end
