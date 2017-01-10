#import "AboutUsViewController.h"
#import "SWRevealViewController.h"
@interface AboutUsViewController ()<SWRevealViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *navigationBackBarButton;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;

@end

@implementation AboutUsViewController
{NSArray *serviceArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
       serviceArray=@[@"- Specialized Soft Services (Healthcare & Hospitality)",@"-Infection Control",@"- Patient Care",@"- Critical Areas cleaning(OT & ICU)",@"- Linen Management",@"-Specialized Stone Care",@"-Soft Services",@"-House Keeping Services",@"-Janitorial Services",@"- Horticulture",@"- Facade Cleaning",@"- Hard Services",@"- Electro Mechanical Services",@"- HVAC & Air Conditioning",@"- Plumbing"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=NO;
      [self navigationBackBarButtonSpacing];
}
-(void)navigationBackBarButtonSpacing{
     self.navigationController.navigationItem.hidesBackButton=YES;
    UIBarButtonItem *fixedbarbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedbarbutton.width=-5;
    self.navigationItem.leftBarButtonItems=@[fixedbarbutton,_navigationBackBarButton];
}
- (IBAction)SlideOut:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}
- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position{
    if (position==FrontViewPositionRight) {
        UIView *view=[[UIView alloc]initWithFrame:self.view.frame];
        [view setTag:111];
        [self.view addSubview:view];
        SWRevealViewController *revealVc=self.revealViewController;
        if (revealVc) {
            [view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            [view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
        }
    }
    else if(position==FrontViewPositionLeft){
        UIView *lower=[self.view viewWithTag:111];
        [lower removeFromSuperview];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return serviceArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *label=(UILabel*)[cell viewWithTag:10];
    label.text=serviceArray[indexPath.row];
    tableView.tableFooterView=[UIView new];
    return cell;
}
@end
