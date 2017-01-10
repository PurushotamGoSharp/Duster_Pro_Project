#import "DatePicker.h"
#import "AppDelegate.h"

@implementation DatePicker
{
    UIView *view;
    NSDateFormatter *formater;
    NSString *date;
    UIControl  *alphaView;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    view=[[[NSBundle mainBundle]loadNibNamed:@"DatePickerView" owner:self options:nil]lastObject];
     [self initializeView];
    [self addSubview:view];
    view.frame=self.bounds;
    _datePicker.datePickerMode=1;
    return self;
}
-(void)initializeView
{
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
    _doneButton.layer.cornerRadius=5;
    _cancelButton.layer.cornerRadius=5;
    formater=[[NSDateFormatter alloc]init];
    [formater setTimeZone:[NSTimeZone localTimeZone]];
    [formater setDateFormat:@"dd MMM yyyy"];
    date=[formater stringFromDate:self.datePicker.date];
}
- (IBAction)datePickerAction:(id)sender {
    formater=[[NSDateFormatter alloc]init];
    [formater setTimeZone:[NSTimeZone localTimeZone]];
    [formater setDateFormat:@"dd MMM yyyy"];
    date=[formater stringFromDate:self.datePicker.date];
}
-(void)alphaViewInitialize{
    if (alphaView == nil)
    {
        alphaView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        [alphaView addSubview:view];
    }
     _datePicker.minimumDate=[NSDate date];
    view.center = alphaView.center;
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
     [alphaView addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [appDel.window addSubview:alphaView];
}

- (IBAction)cancelButtonAction:(id)sender
{
    [alphaView removeFromSuperview];
}

- (IBAction)doneButtonAction:(id)sender
{
    [self.delegate selectingDatePicker:date];
    [alphaView removeFromSuperview];
}

@end

