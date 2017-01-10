#import "MyBookingsTableViewController.h"
#import "MyBookingsTableViewCell.h"
#import "BookingDetailViewController.h"
#import "Constant.h"
#import "Postman.h"
#import "MBProgressHUD.h"
#import "UserAddressModel.h"
#import "BookingModel.h"
#import "BookedJobModel.h"
#import "VMEnvironment.h"

#define NULL_CHECKER(X) ([X isKindOfClass:[NSNull class]] ? nil : X)

@interface MyBookingsTableViewController () 
{
    Postman *postman;
    NSMutableArray *ServiceOrderDetailsArray;
    NSDateFormatter *dateFormatter;
    BOOL pullToRefreshing;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *navigationBackBarButton;

@end

@implementation MyBookingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationBarButtonSpacing];
    postman=[[Postman alloc]init];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(pullToRefresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)pullToRefresh
{
    pullToRefreshing = YES;
    [self callApi];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=NO;
    ServiceOrderDetailsArray=[[NSMutableArray alloc]init];
    [self callApi];
}

- (IBAction)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ServiceOrderDetailsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBookingsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.bookingModel=ServiceOrderDetailsArray[indexPath.section];
    cell.dateAndTimeLabel.text=cell.bookingModel.dateAndTime;
    cell.typeOfCleaningLabel.text=cell.bookingModel.categoryName;
    cell.addressLabel.text=[NSString stringWithFormat:@"%@, %@, %@",cell.bookingModel.userAddressModel.street,cell.bookingModel.userAddressModel.city,cell.bookingModel.userAddressModel.pincode];
    cell.orderCode.text = [NSString stringWithFormat:@"Order Code: %@", cell.bookingModel.code];
    
    
    if ([@[openCode] containsObject:cell.bookingModel.orderStatusCode])
    {
        cell.tagImageView.image=[UIImage imageNamed:@"Processing-tag"];
        
    }else if ([@[confirmedCode, startCode, stopCode, IncpectionAcceptCode, InspectionStop] containsObject:cell.bookingModel.orderStatusCode])
    {
        cell.tagImageView.image=[UIImage imageNamed:@"Assigned-tag"];

    }else if ([@[IncpectionRejectCode, closedCode, PartialClose] containsObject:cell.bookingModel.orderStatusCode])
    {
        cell.tagImageView.image=[UIImage imageNamed:@"Completed-tag"];

    }else if ([@[cancelledCode] containsObject:cell.bookingModel.orderStatusCode])
    {
        cell.tagImageView.image=[UIImage imageNamed:@"Cancelled-tag"];
    }

    
    if (cell.bookingModel.isParentOrder)
    {
        cell.mainOrederStripImageView.hidden = NO;
    }else
    {
        cell.mainOrederStripImageView.hidden = YES;
    }
    tableView.tableFooterView=[UIView new];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BookingDetailViewController *detail=segue.destinationViewController;
    NSIndexPath *path=[self.tableView indexPathForSelectedRow];
    detail.model=ServiceOrderDetailsArray[path.section];
}

- (void)navigationBarButtonSpacing
{
    UIBarButtonItem *fixedbarbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedbarbutton.width=-10;
    self.navigationItem.leftBarButtonItems=@[fixedbarbutton,_navigationBackBarButton];
}

- (void)callApi
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *array=[defaults valueForKey:@"login"];
    NSString *url=[NSString stringWithFormat:@"%@%@",base_url,searchOrderURL];
    NSString *parameter=[NSString stringWithFormat:@"{\"OrderCode\":\"\",\"CustomerId\": \"%@\",\"ServiceProviderId\": \"\",\"OrderStatusCode\": \"\"}",array[3]];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processResponseData:responseObject];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [self.refreshControl endRefreshing];
    }];
}

- (void)processResponseData:(id)responseObject
{
//    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];

    NSDictionary *dict=responseObject;
    if([dict[@"Success"]integerValue]==1)
    {
        [ServiceOrderDetailsArray removeAllObjects];
        NSArray *array=dict[@"ViewModels"];
        for(NSDictionary *dictionary in array)
        {
            if(![dictionary[@"OrderStatusCode"] isEqualToString:rescheduleCode])
            {
                BookingModel *model=[[BookingModel alloc]init];
                
                NSString *dateTimeString= NULL_CHECKER(dictionary[@"PlannedStartTime"]);
                NSArray *seperatedDate=[dateTimeString componentsSeparatedByString:@"T"];
                [dateFormatter setDateFormat:@"YYYY-MM-dd"];
                NSDate *date=[dateFormatter dateFromString:seperatedDate[0]];
                [dateFormatter setDateFormat:@"dd MMMM"];
                NSString *str=[dateFormatter stringFromDate:date];
                [dateFormatter setDateFormat:@"HH:mm:ss"];
                NSDate *time=[dateFormatter dateFromString:seperatedDate[1]];
                [dateFormatter setDateFormat:@"hh:mm a"];
                NSString *str1=[dateFormatter stringFromDate:time];
                
                model.code = NULL_CHECKER(dictionary[@"Code"]);
                model.date = NULL_CHECKER(dictionary[@"PlannedStartTime"]);
                model.orderStatusCode = NULL_CHECKER(dictionary[@"OrderStatusCode"]);
                model.dateAndTime = [NSString stringWithFormat:@"%@, %@",str,str1];
                model.categoryStartTime = [self dateForString:dictionary[@"CategoryStartTime"] forFormat:@"HH:mm:ss"];
                model.categoryEndTime = [self dateForString:dictionary[@"CategoryEndTime"] forFormat:@"HH:mm:ss"];
                model.plannedStartDate = [self dateForString:dictionary[@"PlannedStartTime"] forFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
                model.categoryCode = NULL_CHECKER(dictionary[@"CategoryCode"]);
                model.categoryName = NULL_CHECKER(dictionary[@"CategoryName"]);
                
                model.serviceProviderId = [NULL_CHECKER(dictionary[@"ServiceProviderId"]) integerValue];
                model.serviceProviderCode = NULL_CHECKER(dictionary[@"ServiceProviderCode"]);
                model.serviceProviderName = NULL_CHECKER(dictionary[@"ServiceProviderName"]);
                model.estPrice = [NULL_CHECKER(dictionary[@"EstPrice"]) floatValue];
                model.actPrice = [NULL_CHECKER(dictionary[@"ActPrice"]) floatValue];
                model.estHours = [NULL_CHECKER(dictionary[@"EstHours"]) floatValue];

                model.customerCode = NULL_CHECKER(dictionary[@"CustomerCode"]);
                model.customerID = [NULL_CHECKER(dictionary[@"CustomerId"]) integerValue];
                model.customerName = NULL_CHECKER(dictionary[@"CustomerName"]);
                
                model.isParentOrder = [NULL_CHECKER(dictionary[@"IsParentOrder"]) boolValue];
                model.referenceCode = NULL_CHECKER(dictionary[@"ReferenceOrderCode"]);

                model.totalOfAll = [NULL_CHECKER(dictionary[@"TotalOrderPrice"]) floatValue];
                
                model.canReschedule = [NULL_CHECKER(dictionary[@"CanReschedule"]) boolValue];
                model.isInspection = [NULL_CHECKER(dictionary[@"IsInspection"]) boolValue];

                if (NULL_CHECKER(dictionary[@"Rating"]) != [NSNull null])
                {
                    model.rating=[NULL_CHECKER(dictionary[@"Rating"])intValue];
                }
                
                NSString *address=NULL_CHECKER(dictionary[@"Address"]);
                if (address)
                {
                    NSData *JsonData=[address dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *jsonDict=[NSJSONSerialization JSONObjectWithData:JsonData options:kNilOptions error:nil];
                    model.userAddressModel=[[UserAddressModel alloc]init];
                    model.userAddressModel.street=jsonDict[@"StreetLine1"];
                    model.userAddressModel.street2=jsonDict[@"StreetLine2"];

                    model.userAddressModel.city=jsonDict[@"City"];
                    model.userAddressModel.cityCode = jsonDict[@"citycode"];

                    model.userAddressModel.pincode=jsonDict[@"Pincode"];
                }
                NSDictionary *jobDict=NULL_CHECKER(dictionary[@"Jobs"]);
                model.jobsArray = [self arrayOfJobs:jobDict[@"ViewModels"]];
                
                NSString *jsonExtra = NULL_CHECKER(dictionary[@"JSON"]);
                if (jsonExtra)
                {
                    NSData *jsonExtraData = [jsonExtra dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *jsonExtraDict = [NSJSONSerialization JSONObjectWithData:jsonExtraData
                                                                                  options:kNilOptions
                                                                                    error:nil];
                    model.extraJSONDict = jsonExtraDict;
                    model.taxForOrder = [NULL_CHECKER(jsonExtraDict[@"TaxDetails"][@"ServiceTax"]) floatValue];
                    
                    model.hasCoupon = [NULL_CHECKER(jsonExtraDict[@"CouponDetails"][@"HasCoupon"]) boolValue];
                    
                    if (model.hasCoupon)
                    {
                        NSDictionary *couponDict = jsonExtraDict[@"CouponDetails"];
                        model.couponCode = couponDict[@"CouponCode"];
                        model.couponPercentage = [couponDict[@"CouponPercent"] floatValue];
                        if (model.isParentOrder)
                        {
                            model.couponValue = [couponDict[@"CouponValue"] floatValue];
                        }else
                        {
                            CGFloat initTotal = [self initialEstPriceFromJobsFor:model];
                            initTotal += initTotal * model.taxForOrder/100;
                            model.couponValue = initTotal * model.couponPercentage / 100;
                        }
                    }
                    
                    model.discountGiven = [NULL_CHECKER(jsonExtraDict[@"DiscountDetails"]) floatValue];

                    model.dueAmount = [NULL_CHECKER(jsonExtraDict[@"TransactionDetails"][@"DueAmount"]) floatValue];
                    model.paymentsArray = NULL_CHECKER(jsonExtraDict[@"TransactionDetails"][@"PaymentDetails"]);
                    model.orderName = NULL_CHECKER(jsonExtraDict[@"JobName"]);
                }
                [ServiceOrderDetailsArray addObject:model];
            }
        }
        [self.tableView reloadData];
    }
}

- (CGFloat)initialEstPriceFromJobsFor:(BookingModel *)model
{
    CGFloat total = 0.0;
    for (BookedJobModel *jobModel in model.jobsArray)
    {
        total += jobModel.estPrice;
    }
    
    return total;
}

- (NSDate *)dateForString:(NSString *)dateString forFormat:(NSString *)format;
{
    //2015-11-02T15:00:00
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:dateString];
}

- (NSArray *)arrayOfJobs:(NSArray *)jobsResponse
{
    if ([jobsResponse isKindOfClass:[NSArray class]])
    {
        NSMutableArray *jobsArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in jobsResponse)
        {
            BookedJobModel *job = [[BookedJobModel alloc] init];
            job.jobID = [NULL_CHECKER(dict[@"Id"]) integerValue];
            job.code = NULL_CHECKER(dict[@"Code"]);
            job.orderCode = NULL_CHECKER(dict[@"OrderCode"]);
            job.categoryCode = NULL_CHECKER(dict[@"CategoryCode"]);
            job.subCategoryCode = NULL_CHECKER(dict[@"SubCategoryCode"]);
            job.serviceTypeCode = NULL_CHECKER(dict[@"ServiceTypeCode"]);
            job.optionCode = NULL_CHECKER(dict[@"OptionCode"]);
            job.categoryName = NULL_CHECKER(dict[@"CategoryName"]);
            job.subCategoryName = NULL_CHECKER(dict[@"SubCategoryName"]);
            job.serviceTypeName = NULL_CHECKER(dict[@"ServiceTypeName"]);
            job.optionName = NULL_CHECKER(dict[@"OptionName"]);

            job.hourlyRate = [NULL_CHECKER(dict[@"HourlyPrice"]) floatValue];
            job.estPrice = [NULL_CHECKER(dict[@"EstPrice"]) floatValue];
            
            NSString *durationInString = NULL_CHECKER(dict[@"Duration"]);
            NSArray *splitValues = [durationInString componentsSeparatedByString:@":"];
            if (splitValues.count == 3)
            {
                job.serviceDurationInMins = [splitValues[0] integerValue]*60 + [splitValues[1] integerValue];
            }
            
            [jobsArray addObject:job];
        }
        
        return jobsArray;
    }
    
    return nil;
}

@end

