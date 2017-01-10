#import "SelectCleaningTimeViewController.h"
#import "DatePicker.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "Postman.h"
#import "UserAddressModel.h"
#import "PayNowViewController.h"
#import "SelectCityClass.h"
#import "TaxManager.h"
#import "SelectCityModel.h"
#import "VMEnvironment.h"

@interface SelectCleaningTimeViewController ()<getCityProtocol>
@property (weak, nonatomic) IBOutlet UILabel *assignTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *barButtonItemButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonItem;
@property (strong, nonatomic) IBOutlet UITextField *streetTF;
@property (strong, nonatomic) IBOutlet UITextField *apartmentTF;
@property (strong, nonatomic) IBOutlet UITextField *areaTF;
@property (strong, nonatomic) IBOutlet UITextField *pincodeTF;
@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UILabel *datePickerLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *addAddressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureOutlet;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *addAddressButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelAdressButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalCostDetailHeight;
@property (weak, nonatomic) IBOutlet TotalCostDetailView *totalCostDetailView;
@property (weak, nonatomic) IBOutlet UIButton *showAddAddress;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *mobileNo;
@property (weak, nonatomic) IBOutlet UILabel *emailId;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableviewHeight;
@property (strong, nonatomic) IBOutlet UIView *proceedView;
@property (weak, nonatomic) IBOutlet UIView *dropDownView;
@property (weak, nonatomic) IBOutlet UITableView *dropdownTabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropDownHeightconstrant;
@property (weak, nonatomic) IBOutlet UIView *alphaView;

@end

@implementation SelectCleaningTimeViewController
{
    DatePicker *picker;
    UIView *activeField;
    NSIndexPath *selectedIndex;
    NSMutableArray *addressLabelArray;
    SelectCleaningTVCell *cell;
    Postman *postman;
    SelectTime *selTime;
    UserAddressModel *userModel;
    NSNumber *recentlyAddedAddress;
    NSInteger serviceDuration;
    NSDateFormatter *formater;
    NSMutableArray *timeArray;
    BOOL viewAppeared;
    SelectCityClass *selectCity;
    NSString *cityCodefromcity;
    NSMutableArray *dropdownArr;
    SelectCityModel *cityModel;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    postman=[[Postman alloc]init];
    [self removeNavigationBarLeftSpace];
    self.view.backgroundColor=[UIColor colorWithRed:.85 green:.84 blue:.84 alpha:1];
    [self textFieldPadding];
    [self registerForKeyboardNotifications];
    selectedIndex=nil;
    addressLabelArray = [[NSMutableArray alloc] init];
    self.totalCostDetailView.delegateForHeightofCostDetailView=self;
    self.totalCostDetailView.catModel = self.category;
    recentlyAddedAddress=nil;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    self.tableview.estimatedRowHeight = 71;
    self.cityTF.userInteractionEnabled = NO;
    [self defaultValues];
    [self allocateTimeSlots];
    [self callGetAddressAPI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _cancelAdressButton.layer.cornerRadius=5;
    _addAddressButton.layer.cornerRadius=5;
    self.title=_category.name;
    
    viewAppeared = YES;
    self.dropDownView.hidden = YES;
    self.alphaView.hidden = YES;
    self.totalCostDetailView.showCouponEntry = YES;
    [self serviceData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)defaultValues
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *array=[defaults valueForKey:@"login"];
    self.name.text=array[0];
    self.mobileNo.text=array[1];
    self.emailId.text=array[2];
    formater =[[NSDateFormatter alloc]init];
    [formater setTimeZone:[NSTimeZone localTimeZone]];
    [formater setDateFormat:@"dd MMM yyyy"];
    _datePickerLabel.text=[formater stringFromDate:[NSDate date]];
    [self checkAvailablityOfDate:[NSDate date]
                            with:^(BOOL sucess) {
                                if (sucess)
                                {
                                    [self allocateTimeSlots];
                                }else
                                {
                                    timeArray =[[NSMutableArray alloc]init];
                                    _assignTimeLabel.text=@"No Timeslots Available";
                                }
                            }];
}

- (IBAction)barButtonItemButtonActio:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)removeNavigationBarLeftSpace
{
    UIBarButtonItem *negativeSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpace.width=-10;
    self.navigationItem.leftBarButtonItems=@[negativeSpace,self.barButtonItem];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.dropdownTabel]) {
        return dropdownArr.count;
    } else {
        return addressLabelArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.dropdownTabel])
    {
        cityModel = dropdownArr[indexPath.row];
        UITableViewCell *cell1 =[tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell1.textLabel.text = cityModel.cityName;
        
        return cell1;
        
    } else {
     
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.amodel=addressLabelArray[indexPath.row];
        
        cell.streetLabel.text = [NSString stringWithFormat:@"%@,%@,%@ - %@", cell.amodel.street, cell.amodel.area,cell.amodel.city, cell.amodel.pincode];
        cell.delegate=self;
        cell.radioButtonImage.image=[UIImage imageNamed:@"Radio-unselected"];
        if (recentlyAddedAddress!=nil) {
            if (cell.amodel.ID==recentlyAddedAddress) {
                cell.radioButtonImage.image=[UIImage imageNamed:@"Radio-selected"];
                selectedIndex=indexPath;
                userModel=cell.amodel;
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.dropdownTabel]){
        
        return 40;
    }
    else if([self.tableview isEqual:tableView])
    {
        return UITableViewAutomaticDimension;
    }
    return 71;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.dropdownTabel]) {
        cityModel = dropdownArr[indexPath.row];
        
        self.cityTF.text = cityModel.cityName;
        cityCodefromcity = cityModel.cityCode;
        self.dropDownView.hidden=YES;
        self.alphaView.hidden = YES;
    
    } else {
        if(selectedIndex)
        {
            SelectCleaningTVCell *selectedCell = (SelectCleaningTVCell *)[tableView cellForRowAtIndexPath:selectedIndex];
            selectedCell.radioButtonImage.image=[UIImage imageNamed:@"Radio-unselected"];
            selectedIndex=nil;
        }
        if(![selectedIndex isEqual:indexPath])
        {
            SelectCleaningTVCell *cell1=(SelectCleaningTVCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell1.radioButtonImage.image=[UIImage imageNamed:@"Radio-selected"];
            userModel=addressLabelArray[indexPath.row];
            selectedIndex=indexPath;
            recentlyAddedAddress=nil;
        }
    }
}

- (void)tableContentSize
{
    // Force the table view to calculate its height
    
    [self.dropdownTabel layoutIfNeeded];
    
    CGFloat tableHeight = self.dropdownTabel.contentSize.height;
    
    if (tableHeight<=280) {
        self.dropDownHeightconstrant.constant = tableHeight+44;
    } else {
       self.dropDownHeightconstrant.constant = 324;
    }
}

- (IBAction)cancelButtonAction:(id)sender
{
    self.areaTF.text=@"";
    self.streetTF.text=@"";
    self.pincodeTF.text=@"";
    self.addAddressView.hidden=YES;
    _showAddAddress.enabled=YES;
    _viewHeight.constant=0;
    [self.tableview reloadData];
    _tableviewHeight.constant=self.tableview.contentSize.height;
}

- (IBAction)addAddressButtonAction:(id)sender
{
    if ([self.apartmentTF.text isEqualToString:@""])
    {
        [self toastMessage:@"Please enter Buildings/Apartments."];
        return;
    }
    
    if ([self.streetTF.text isEqualToString:@""])
    {
        [self toastMessage:@"Please enter Street."];
        return;
    }
    
    if ([self.areaTF.text isEqualToString:@""])
    {
        [self toastMessage:@"Please enter Area."];
        return;
    }
    
    if ([self.cityTF.text isEqualToString:@""])
    {
        [self toastMessage:@"Please select a City."];
        return;
    }
    
    if ([self.pincodeTF.text isEqualToString:@""])
    {
        [self toastMessage:@"Please enter Pincode."];
        return;
    }
    
    if (self.pincodeTF.text.length < 6)
    {
        [self toastMessage:@"Please provide a 6 digit Pincode."];
        return;
    }
    
    [self callApiForAddAddress];
}

- (IBAction)selectCityButtonAction:(id)sender
{
    self.dropDownView.hidden = NO;
    self.alphaView.hidden = NO;
    dropdownArr =[[NSMutableArray alloc]init];
    
    [self callApiForallCity];
}

- (void)getCityName:(NSString *)cityName and:(NSString *)cityCode
{
    self.cityTF.text = cityName;
    cityCodefromcity = cityCode;
}

- (IBAction)hidingalphaViewAndDropdown:(id)sender
{
    self.dropDownView.hidden=YES;
    self.alphaView.hidden = YES;
}

-(void)callApiForAddAddress
{
    NSString *buildingAndStreet =[self.apartmentTF.text stringByAppendingString: self.streetTF.text];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *array=[defaults valueForKey:@"login"];
    NSString *url=[NSString stringWithFormat:@"%@%@",base_url,addAddressURL];
    NSString *parameter=[NSString stringWithFormat:@"{\"Address\": {\"StreetLine1\": \"%@\",\"StreetLine2\": \"%@\",\"City\": \"%@\",\"State\": \"\",\"Country\":\"India\",\"Pincode\": \"%@\",\"citycode\":\"%@\",},\"Status\": 1,\"UserID\": %@}",buildingAndStreet,self.areaTF.text,self.cityTF.text,self.pincodeTF.text,cityCodefromcity,array[3]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        {
            [self parsingResponseData:responseObject];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

- (void)parsingResponseData:(id)responseObject
{
    NSLog(@"%@",responseObject);
    NSDictionary *dictionary=responseObject;
    int success=[dictionary[@"Success"]intValue];
    if(success==1)
    {
        self.addAddressView.hidden=YES;
        self.viewHeight.constant=0;
        _showAddAddress.enabled=YES;
        [self toastMessage:dictionary[@"Message"]];
        recentlyAddedAddress=dictionary[@"Address"];
        [self callGetAddressAPI];
    }
    else
    {
        [self toastMessage:dictionary[@"Message"]];
    }
}

- (void)callGetAddressAPI
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *array=[defaults valueForKey:@"login"];
    NSString *url=[NSString stringWithFormat:@"%@%@/%@",base_url,getAddressURL,array[3]];
    [postman get:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processingDataForGettingAddress:responseObject];
        [self.tableview reloadData];
        NSLog(@"%f", self.tableview.contentSize.height);
        _tableviewHeight.constant = self.tableview.contentSize.height;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(void)processingDataForGettingAddress:(NSDictionary *)responseObject
{
    [addressLabelArray removeAllObjects];
    NSDictionary *dictionary=responseObject;
    if([dictionary[@"Success"]boolValue])
    {
        NSMutableArray *array1=dictionary[@"ViewModels"];
        for(NSDictionary *dict in array1)
        {
            
            UserAddressModel *model=[[UserAddressModel alloc]init];
            model.userID=[dict[@"UserId"]integerValue];
            model.code=dict[@"Code"];
            NSString *JSONString = dict[@"Address"];
            NSData *jsonData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
            model.street=jsonDict[@"StreetLine1"];
            model.street2=jsonDict[@"StreetLine2"];
            model.area = jsonDict[@"StreetLine2"];
            model.pincode=jsonDict[@"Pincode"];
            model.city=jsonDict[@"City"];
            model.cityCode = jsonDict[@"citycode"];
            model.ID=dict[@"Id"];
            [addressLabelArray addObject:model];
        }
        [self checkCountOfTableView];
    }
}

- (void)toastMessage:(NSString *)message
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode=MBProgressHUDModeText;
    hud.detailsLabelText= message;
    hud.detailsLabelFont=[UIFont systemFontOfSize:15];
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (IBAction)tapGestureMethod:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)datePicker:(id)sender {
    if(picker==nil)
        picker= [[DatePicker alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+7.5, self.view.frame.origin.y+230,self.view.frame.size.width-15,220)];
    [picker.datePicker setMinimumDate:[NSDate date]];
    [picker alphaViewInitialize];
    picker.delegate=self;
}

- (IBAction)proceedToPay:(id)sender {
    if ([_assignTimeLabel.text isEqualToString:@"Select time slot"] | [_assignTimeLabel.text isEqualToString:@"No Timeslots Available"]) {
        [self toastMessage:@"Please choose a Timeslot"];
        
    } else if (selectedIndex==nil) {
        [self toastMessage:@"Please select your address"];
    }
    else {
        [self performSegueWithIdentifier:@"payAmount" sender:nil];
        self.streetTF.text=@"";
        self.areaTF.text=@"";
        self.pincodeTF.text=@"";
        _apartmentTF.text=@"";
    }
}
- (void)selectingDatePicker:(NSString *)date
{
    self.datePickerLabel.text = date;
    //    NSString *timeLabel = self.assignTimeLabel.text;
    formater.dateFormat = @"dd MMM yyyy";
    
    [self checkAvailablityOfDate:[formater dateFromString:date]
                            with:^(BOOL sucess) {
                                if (sucess)
                                {
                                    [self allocateTimeSlots];
                                }else
                                {
                                    timeArray =[[NSMutableArray alloc]init];
                                    _assignTimeLabel.text=@"No Timeslots Available";
                                    [self toastMessage:@"No Timeslots Available"];
                                }
                            }];
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

- (void)checkAvailablityOfDate:(NSDate *)date with:(void (^)(BOOL sucess))completionHandler
{
    if (date == nil) {
        completionHandler(NO);
        return;
    }
    
    NSDate *dateToCheck = date;
    if ([self isToday:date])
    {
        dateToCheck = [NSDate date];
    }
    
    formater.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSString *dateString = [formater stringFromDate:dateToCheck];
    
    NSString *paramter = [NSString stringWithFormat:@"{\"PlannedStartTime\":\"%@\",\"CategoryCode\": \"%@\"}", dateString, self.category.code];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",base_url, kAVAILABLITY_OF_SLOTS_URL];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [postman post:urlString withParameters:paramter
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
              
              if ([responseObject[@"Success"] boolValue])
              {
                  completionHandler(YES);
              }else
              {
                  completionHandler(NO);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [MBProgressHUD hideHUDForView:self.navigationController.view animated:NO];
              completionHandler(NO);
          }];
}

- (void)callApiForallCity
{
    NSString *urlString =[NSString stringWithFormat:@"%@%@",base_url,getLocationURL];
    
    [MBProgressHUD showHUDAddedTo:self.dropDownView animated:YES];
    [postman get:urlString withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *responseData =[operation responseData];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        [self parsingResponseDataa:responseDict];
        [MBProgressHUD hideAllHUDsForView:self.dropDownView animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.dropDownView animated:YES];
    }];
}

- (void)parsingResponseDataa:(NSDictionary *)resposeDict
{
    
    NSLog(@"%@",resposeDict);
    NSMutableArray *cityArr = resposeDict[@"ViewModels"];
    for (NSDictionary *aDict in cityArr) {
        if ([aDict[@"Status"]boolValue]) {
            cityModel =[[SelectCityModel alloc]init];
            cityModel.cityName = aDict[@"Name"];
            cityModel.cityCode = aDict[@"Code"];
            [dropdownArr addObject:cityModel];
        }
    }
    [self.dropdownTabel reloadData];
    [self tableContentSize];
}

- (void)textFieldPadding
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 48)];
    _areaTF.leftView=view;
    _areaTF.leftViewMode=3;
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 48)];
    _streetTF.leftView=view1;
    _streetTF.leftViewMode=3;
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 48)];
    _pincodeTF.leftView=view2;
    _pincodeTF.leftViewMode=3;
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 48)];
    _apartmentTF.leftView=view3;
    _apartmentTF.leftViewMode=3;
    UIView *view4=[[UIView alloc]initWithFrame:CGRectMake(0, 0,5, 48)];
    _cityTF.leftView=view4;
    _cityTF.leftViewMode=3;
    
    self.streetTF.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"Street" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.8 green:0.8 blue:.8 alpha:1],NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    self.pincodeTF.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Pincode"attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:0.8 green:0.8 blue:.8 alpha:1],  NSFontAttributeName : [UIFont systemFontOfSize:15]} ];
    self.areaTF.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Area"  attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:0.8 green:0.8 blue:.8 alpha:1],NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    self.apartmentTF.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Apartment/Building"  attributes:@{ NSForegroundColorAttributeName: [UIColor colorWithRed:0.8 green:0.8 blue:.8 alpha:1],NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    
self.cityTF.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"City" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.8 green:0.8 blue:.8 alpha:1],NSFontAttributeName : [UIFont systemFontOfSize:15]}];


}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets =UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *expectedString = [textField.text mutableCopy];
    [expectedString replaceCharactersInRange:range withString:string];

    if ([textField isEqual:self.pincodeTF])
    {
        if (expectedString.length > 6) {
            return NO;
        }
        return [self numerticOnly:expectedString];
    }else if ([textField isEqual:self.apartmentTF] || [textField isEqual:self.streetTF] || [textField isEqual:self.areaTF])
    {
        if (expectedString.length > 80) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)numerticOnly:(NSString *)string
{
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    return [alphaNums isSupersetOfSet:inStringSet];
}

- (IBAction)showAddAddressButton:(id)sender
{
    self.streetTF.text=@"";
    self.areaTF.text=@"";
    self.pincodeTF.text=@"";
    _apartmentTF.text=@"";
    [self viewWillAppear:YES];
    recentlyAddedAddress=nil;
    if(addressLabelArray.count>=3)
    {
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode=MBProgressHUDModeText;
        hud.labelText = @"Only 3 addresses are accepted.";
        hud.margin = 10.f;
        hud.yOffset = 80.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
        
    }
    else{
        self.viewHeight.constant=278;
        [self.scrollView layoutIfNeeded];
        self.addAddressView.hidden=NO;
        _showAddAddress.enabled=NO;
        [self.scrollView scrollRectToVisible:self.proceedView.frame animated:YES];
    }
}

-(void)deleteCell:(UITableViewCell *)Cell
{
    NSIndexPath *path=[self.tableview indexPathForCell:Cell];
    UserAddressModel *model =addressLabelArray[path.row];
    NSString *url=[NSString stringWithFormat:@"%@%@",base_url,deleteAddress];
    NSString *parameter=[NSString stringWithFormat:@"{\"Code\": \"%@\",\"UserId\": \"%ld\"}",model.code,(long)model.userID];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [postman post:url withParameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self parsingResponseData1:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)parsingResponseData1:(id)responseObject
{
    NSDictionary *dict=responseObject;
    if([dict[@"Success"]intValue]==1)
    {
        [self toastMessage:dict[@"Message"]];
        [self callGetAddressAPI];
        
    }
    else  [self toastMessage:dict[@"Message"]];
}

- (IBAction)SelectTimeButtonAction:(id)sender
{
    if (timeArray.count>0) {
        if(selTime==nil)
            selTime =[[SelectTime alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+100, self.view.frame.origin.y+100, self.view.frame.size.width-100,self.view.frame.size.height-100)];
        selTime.selectTimeArray=timeArray;
        [selTime alphaInitialize];
        selTime.delegate=self;
    }
}

- (void)SelectTime:(NSString *)string
{
    self.assignTimeLabel.text=string;
}

- (void)getHeightOfCostDetailView:(CGFloat)frameHeight
{
    self.totalCostDetailHeight.constant=frameHeight;
    [self.scrollView layoutIfNeeded];
    
    if (!viewAppeared)
    {
        CGRect bottomRect = CGRectMake(1, self.scrollView.contentSize.height-1, 1, 1);
        [self.scrollView scrollRectToVisible:bottomRect animated:YES];
    }else
    {
        viewAppeared = NO;
    }
}

- (void)showingKeyboardFor:(UITextField *)textField
{
    activeField = self.proceedView;
}

- (void)hideKeyboardFor:(UITextField *)textField
{
    activeField = nil;
}

- (void)applyingCoupon
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)successfullyAppledCoupun:(NSInteger)discount
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [self toastMessage:@"Coupon applied successfully"];
}

- (void)failedToApplyCoupon:(NSString *)errorMessage
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    
    if (errorMessage == nil) {
        [self toastMessage:@"Failed to apply coupon"];
    }else
    {
        [self toastMessage:errorMessage];
    }
}

- (void)serviceData
{
    self.totalCostDetailView.detailArray=[self.category totalCostDetailObjects];
    [self.totalCostDetailView updateView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PayNowViewController *payNow = segue.destinationViewController;
    payNow.userAddressModel=userModel;
    payNow.selectedTimeAndDate=@[self.assignTimeLabel.text,self.datePickerLabel.text];
    payNow.categoryModel=self.category;
}

- (void)checkCountOfTableView
{
    self.viewHeight.constant=0;
    self.addAddressView.hidden=YES;
    if (addressLabelArray.count==0) {
        _addAddressView.hidden=NO;
        _viewHeight.constant=278;
        _showAddAddress.enabled=NO;
        _streetTF.text=@"";
        _pincodeTF.text=@"";
        _areaTF.text=@"";
        _cancelAdressButton.enabled=NO;
        selectedIndex=nil;
        _tableviewHeight.constant=0;
    }
    else{
        _cancelAdressButton.enabled=YES;
        _tableviewHeight.constant=_tableview.contentSize.height;
    }
}

- (void)allocateTimeSlots
{
    timeArray =[[NSMutableArray alloc]init];
    [formater setDateFormat:@"dd MMM yyyy"];
    
    //Get the Min secs for Booking from current time.
    NSDate *minDateToBook = [[NSDate date] dateByAddingTimeInterval:[[TaxManager sharedInstance] minSecsBeforeBooking]];
    NSString *currentDateString = [formater stringFromDate:minDateToBook];
    
    serviceDuration= [_category maxServiceDuration];
    
    [formater setDateFormat:@"HH:mm:ss"];
    NSDate *startTime = [formater dateFromString:_category.DayStartTime];
    NSDate *endTime = [formater dateFromString:_category.DayEndTime];
    NSDate *newEndDate =[endTime dateByAddingTimeInterval:-serviceDuration*60];
    NSString *currentString = [formater stringFromDate:minDateToBook];
    NSDate *currentTime = [formater dateFromString:currentString];
    if ([_datePickerLabel.text isEqualToString:currentDateString])
    {
        if ([[startTime dateByAddingTimeInterval:serviceDuration*60] compare:endTime] == NSOrderedAscending)
        {
            [formater setDateFormat:@"hh:mm a"];

            while ([startTime compare:newEndDate] == NSOrderedAscending | [startTime compare:newEndDate] == NSOrderedSame )
            {
                if ([startTime compare:currentTime] == NSOrderedDescending)
                {
                    NSString *str1 = [formater stringFromDate:startTime];
                    [timeArray addObject:str1];
                }
                startTime = [startTime dateByAddingTimeInterval:1*60*60];
            }
            if (timeArray.count>0)
            {
                _assignTimeLabel.text=timeArray[0];
            }
            else _assignTimeLabel.text=@"No Timeslots Available";
        }
        else {
            _assignTimeLabel.text=@"No Timeslots Available";
        }
    }
    else {
        if ([[startTime dateByAddingTimeInterval:serviceDuration*60] compare:endTime]==NSOrderedAscending) {
            
            [formater setDateFormat:@"hh:mm a"];

            while ([startTime compare:newEndDate]==NSOrderedAscending | [startTime compare:newEndDate]==NSOrderedSame ) {
                NSString *str1=[formater stringFromDate:startTime];
                [timeArray addObject:str1];
                startTime= [startTime dateByAddingTimeInterval:1*60*60];
            }
            if (timeArray.count>0) {
                _assignTimeLabel.text=timeArray[0];
            }
            else _assignTimeLabel.text=@"No Timeslots Available";
        }
        else {
            _assignTimeLabel.text=@"No Timeslots Available";
        }
    }
}

@end
