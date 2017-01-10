#import "CarpentryViewController.h"
#import "TotalCostDetailView.h"
#import "SelectCleaningTimeViewController.h"
#import "SubCategoryModel.h"
#import "NetworkHandler.h"
#import "TypeModel.h"
#import "SubCategoryModel.h"
#import "OptionModel.h"
#import "MBProgressHUD.h"

@interface CarpentryViewController ()<heightOfCostDetailView, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *navigationBackBarButton;
@property (strong, nonatomic) IBOutlet TotalCostDetailView *totalCostView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *totalCostDetailHeight;
@property (strong, nonatomic) IBOutlet UILabel *serviceTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CarpentryViewController
{
    NSIndexPath *selectedIndexPath;
    TypeModel *typeModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationBackBarButtonSpacing];
    self.title=_categoryModel.name;
    _serviceTypeLabel.text=[NSString stringWithFormat:@"%@ %@",self.title,@"service"];
    _descriptionLabel.text=[NSString stringWithFormat:@"This service is available based on inspection. Once you book this service, our serviceman will inspect the element and evaluate the estimated time to finish the work. Charges are calculated during the inspection time. Minimum inspection time period for a service is 2hr. Our representative may inspect and fix within the minimum time period."];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    SubCategoryModel *subCat = [self.categoryModel.allSubCategories firstObject];
    self.categoryModel.selectedSubCats = @[subCat];
    
    typeModel = [subCat.typeModels firstObject];
    subCat.selectedTypeIndex = 0;
    typeModel.selected = YES;
//    selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    _categoryModel.selectedSubCats = self.categoryModel.allSubCategories;
    _totalCostView.delegateForHeightofCostDetailView = self;
//    self.totalCostView.detailArray = [self.categoryModel totalCostDetailObjects];
    [self.totalCostView updateView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor=[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    //    self.navigationController.navigationBarHidden=NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    

}

- (void)navigationBackBarButtonSpacing
{
    UIBarButtonItem *fixedbarbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedbarbutton.width=-10;
    self.navigationItem.leftBarButtonItems=@[fixedbarbutton,_navigationBackBarButton];
}
- (IBAction)popViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getHeightOfCostDetailView:(CGFloat)frameHeight{
    self.totalCostDetailHeight.constant=frameHeight;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SelectCleaningTimeViewController *selectVc=segue.destinationViewController;
    selectVc.category=_categoryModel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (selectedIndexPath)
    {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return typeModel.optionModels.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    if (indexPath.section == 1)
    {
        OptionModel *option = typeModel.optionModels[selectedIndexPath.row];

        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        UILabel *label = (UILabel *) [cell viewWithTag:101];
        label.text = option.insepectionDescription;
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        OptionModel *option = typeModel.optionModels[indexPath.row];

        UILabel *label = (UILabel *) [cell viewWithTag:101];
        label.text = option.serviceTitle;
        UIImageView *radioButton = (UIImageView *) [cell viewWithTag:100];
        
        if ([selectedIndexPath isEqual:indexPath])
        {
            radioButton.image = [UIImage imageNamed:@"Radio-selected"];
        }else {
            radioButton.image = [UIImage imageNamed:@"Radio-unselected"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != typeModel.optionModels.count)
    {
        selectedIndexPath = indexPath;
        typeModel.selectedOptionIndex = indexPath.row;
        [tableView reloadData];
        
        self.totalCostView.detailArray = [self.categoryModel totalCostDetailObjects];
        [self.totalCostView updateView];

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(8, 5, 320, 20);
    myLabel.font = [UIFont systemFontOfSize:16];
    if (section == 0)
    {
        myLabel.text = [NSString stringWithFormat:@"%@ services:", self.categoryModel.name];
    }else
    {
        myLabel.text = @"Description:";
    }
//     = [self tableView:tableView titleForHeaderInSection:section];

    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (IBAction)moveToSelectTImeVC:(UIButton *)sender
{
    if (selectedIndexPath)
    {
        [self performSegueWithIdentifier:@"InspectionToSelectionSegue" sender:nil];
    }else
    {
        [self toastMessage:@"Please select an option."];
    }
}

- (void)toastMessage:(NSString *)message
{
    MBProgressHUD *hubHUD=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hubHUD.mode=MBProgressHUDModeText;
    hubHUD.detailsLabelText= message;
    hubHUD.detailsLabelFont=[UIFont systemFontOfSize:15];
    hubHUD.margin=20.f;
    hubHUD.yOffset=150.f;
    hubHUD.removeFromSuperViewOnHide = YES;
    [hubHUD hide:YES afterDelay:1];
}


@end
