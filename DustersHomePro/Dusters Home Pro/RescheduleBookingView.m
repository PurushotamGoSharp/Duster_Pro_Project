#import "RescheduleBookingView.h"
#import "AppDelegate.h"
#import "BookedJobModel.h"
#import "TaxManager.h"
#import "VMEnvironment.h"

@implementation RescheduleBookingView
{
    UIView *xibView;
    UIControl *alphaView;
    DatePicker *picker;
    SelectTime *timePicker;
    Postman *postman;
    NSDateFormatter *formater;
    NSMutableArray *timeStringArray;
    NSInteger currentValue;
    NSArray *dateTimeArray;
    
    
    NSDate *selectedDateWithoutTime;
    NSDate *selectedTimeWithoutDate;
    NSDate *selectedDate;
}


- (IBAction)datePickerLabel:(id)sender
{
    
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    xibView=[[[NSBundle mainBundle]loadNibNamed:@"RescheduleBookingView" owner:self options:nil]lastObject];
    [self addSubview:xibView];
    [self initialize];
    return self;
}

- (void)initialize
{
    xibView.layer.cornerRadius = 10;
    _cancelButton.layer.cornerRadius=5;
    _rescheduleButton.layer.cornerRadius=5;
    formater=[[NSDateFormatter alloc]init];
    postman=[[Postman alloc]init];
}

- (void)showXibView
{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc]initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addTarget:self action:@selector(cancel:) forControlEvents:(UIControlEventTouchDown)];
        [alphaView addSubview:xibView];
    }
    
    xibView.center = alphaView.center;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window addSubview:alphaView];
    
    [formater setDateFormat:@"dd MMM yyyy"];
    _datePickerLabel.text = [formater stringFromDate:self.model.plannedStartDate];
    selectedDateWithoutTime = self.model.plannedStartDate;
    selectedDate = self.model.plannedStartDate;
    
    [self allocateTimeSlots];
    
    [formater setDateFormat:@"hh:mm a"];
    self.timeLabel.text = [formater stringFromDate:self.model.plannedStartDate];
    selectedTimeWithoutDate = [self timeWithOutDate:self.model.plannedStartDate];
}

-(NSDate *)timeWithOutDate:(NSDate *)datDate {
    if( datDate == nil ) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}
- (IBAction)selectDate:(id)sender
{
    picker= [[DatePicker alloc] initWithFrame:CGRectMake(50,50,300,220)];
    [picker alphaViewInitialize];
    picker.delegate=self;
    [picker.datePicker setMinimumDate:[NSDate date]];
    picker.datePicker.date = selectedDateWithoutTime;
}

- (IBAction)cancel:(id)sender
{
    [alphaView removeFromSuperview];
}

- (IBAction)reschedule:(id)sender
{
    if (selectedTimeWithoutDate == nil || selectedDateWithoutTime == nil)
    {
        [self toastMessage:@"Please choose a Timeslot"];
        return;
    }
    
    NSDate *scheduledDate = [self combineDate:selectedDateWithoutTime andTime:selectedTimeWithoutDate];
    selectedDate = scheduledDate;
    
    if ([selectedDate isEqualToDate:self.model.plannedStartDate])
    {
        [self toastMessage:@"Order cannot be rescheduled for same slot"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:alphaView animated:YES];

    [self.delegate refreshModel:self.model.code with:^(BOOL success, BookingModel *bookingModel) {
        [MBProgressHUD hideAllHUDsForView:alphaView animated:NO];

        if (success)
        {
            self.model = bookingModel;
            
            if (self.model.canReschedule)
            {
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                NSMutableArray *array=[defaults valueForKey:@"login"];
                
                //2015-09-15 07:05:11
                formater.dateFormat = @"YYYY-MM-dd HH:mm:ss";
                NSString *dateString = [formater stringFromDate:scheduledDate];
                NSString *url=[NSString stringWithFormat:@"%@%@/%@",base_url,rescheduleOrderURL,self.model.code];
                NSString *parameter=[NSString stringWithFormat:@"{\"CustomerId\": \"%@\",\"NewPlannedStartTime\": \"%@\",\"OrderStatusCode\": \"ONHU76\",\"UserID\": \"%@\"}",array[3],dateString,array[3]];
                [MBProgressHUD showHUDAddedTo:alphaView animated:YES];
                [postman put:url withParameters:parameter
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         [MBProgressHUD hideAllHUDsForView:alphaView animated:YES];
                         [self processResponeData:responseObject];
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [MBProgressHUD hideAllHUDsForView:alphaView animated:YES];
                     }];

            }else
            {
                [self toastMessage:@"This order can not be rescheduled"];
            }
        }else
        {
            [self toastMessage:@"Some error occured. Please try again."];
        }
    }];
    
}

- (void)toastMessage:(NSString *)message
{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:alphaView animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.detailsLabelText= message;
    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:1];
}

- (void)processResponeData:(id)responseObject
{
    NSDictionary *dictionary=responseObject;
    if([dictionary[@"Success"]boolValue])
    {
//        formater.dateFormat = @"dd MMM YY, hh:mm a";
//        NSString *message = [NSString stringWithFormat:@"Successfully rescheduled to %@.", [formater stringFromDate:selectedDate]];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Successful" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//        [alert show];
        
        [alphaView removeFromSuperview];
        [self.delegate popToMyBooking];

    }else
    {
        [self toastMessage:dictionary[@"Message"]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [alphaView removeFromSuperview];
        [self.delegate popToMyBooking];
    }
}

- (void)selectingDatePicker:(NSString *)date
{
    self.datePickerLabel.text = date;
    selectedDateWithoutTime = picker.datePicker.date;
    [self allocateTimeSlots];
}

- (IBAction)selectTime:(id)sender
{
    if (timeStringArray.count == 0)
    {
        return;
    }
    if (timePicker==nil)
    {
        timePicker=[[SelectTime alloc]initWithFrame:CGRectMake(40, 150,237,180)];
    }
    timePicker.selectTimeArray=timeStringArray;
    [timePicker alphaInitialize];
    timePicker.delegate=self;
}

- (void)SelectTime:(NSString *)string
{
    _timeLabel.text = string;
    [formater setDateFormat:@"hh:mm a"];
    selectedTimeWithoutDate = [formater dateFromString:string];
}

- (CGFloat)getMaxDuration
{
    CGFloat maxDuration = 0;
    
    for (BookedJobModel *job in self.model.jobsArray)
    {
        if (maxDuration < job.serviceDurationInMins)
        {
            maxDuration = job.serviceDurationInMins;
        }
    }
    
    return maxDuration;
}

- (BOOL)isToday:(NSDate *)aDate;
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:aDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    return [today isEqualToDate:otherDate];
}

- (NSDate *)combineDate:(NSDate *)date andTime:(NSDate *)time
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
    NSDateComponents *timeComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:time];
    
    NSDateComponents *newComponents = [[NSDateComponents alloc]init];
    newComponents.timeZone = [NSTimeZone systemTimeZone];
    [newComponents setDay:[dateComponents day]];
    [newComponents setMonth:[dateComponents month]];
    [newComponents setYear:[dateComponents year]];
    [newComponents setHour:[timeComponents hour]];
    [newComponents setMinute:[timeComponents minute]];
    
    NSDate *combDate = [calendar dateFromComponents:newComponents];
    
    return combDate;
}

- (void)allocateTimeSlots
{
    timeStringArray = [[NSMutableArray alloc]init];
    
    NSDate *timeSlotStart = [self combineDate:selectedDateWithoutTime andTime:self.model.categoryStartTime];
    NSDate *maxValidDateForBooking = [self.model.categoryEndTime dateByAddingTimeInterval:-[self getMaxDuration]*60];
    maxValidDateForBooking = [self combineDate:selectedDateWithoutTime andTime:maxValidDateForBooking];
    NSMutableArray *timeSlotArray = [[NSMutableArray alloc] init];
    while ([timeSlotStart compare:maxValidDateForBooking] != NSOrderedDescending)
    {
        [timeStringArray addObject:[formater stringFromDate:timeSlotStart]];
        [timeSlotArray addObject:timeSlotStart];
        timeSlotStart = [timeSlotStart dateByAddingTimeInterval:60*60];
    }
    
    timeStringArray = [self filterInvalidTimeSlots:timeSlotArray];
    
    if (timeStringArray.count == 0)
    {
        _timeLabel.text = @"No Timeslots Available";
        selectedTimeWithoutDate = nil;
    } else
    {
        _timeLabel.text = timeStringArray[0];
        [formater setDateFormat:@"hh:mm a"];
        selectedTimeWithoutDate = [formater dateFromString:timeStringArray[0]];
    }
}

- (NSMutableArray *)filterInvalidTimeSlots:(NSArray *)timeSlots
{
    formater.dateFormat = @"hh:mm a";
    NSMutableArray *stringArray = [[NSMutableArray alloc] init];
    
    if ([self isToday:selectedDateWithoutTime])
    {
        NSDate *minValidDate = [[NSDate date] dateByAddingTimeInterval:[[TaxManager sharedInstance] minSecsBeforeBooking]];
        for (NSDate *slot in timeSlots)
        {
            if ([slot compare:minValidDate] != NSOrderedAscending)
            {
                [stringArray addObject:[formater stringFromDate:slot]];
            }
        }
    }else
    {
        for (NSDate *slot in timeSlots)
        {
            [stringArray addObject:[formater stringFromDate:slot]];
        }
    }
    
    return stringArray;
}

@end
