#import "SlideOutMentTableViewController.h"
#import "DustProHomeViewController.h"
#import "LoginViewController.h"
#import "Constant.h"
#import "SWRevealViewController.h"

@interface SlideOutMentTableViewController ()
@property (strong, nonatomic) IBOutlet UIView *logoutView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SlideOutMentTableViewController
{
    NSArray *slideOutItems;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    slideOutItems=@[@"Home",@"About Us",@"Rate APP",@"Change Password"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.view.backgroundColor=[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1];
    self.navigationController.navigationBarHidden=YES;
    _logoutView.backgroundColor=[UIColor clearColor];
    [_tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
     UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor=[UIColor clearColor];
    [cell setBackgroundView:bgColorView];
    
    if (indexPath.row==0) {
         cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    else{
   cell =[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    UILabel *label=(UILabel*)[cell viewWithTag:10];
    label.text=slideOutItems[indexPath.row-1];
    }
    tableView.tableFooterView=[UIView new];
  
//    bgColorView.backgroundColor = [UIColor colorWithRed:0 green:0.62 blue:0.32 alpha:1];
//    [cell setSelectedBackgroundView:bgColorView];
       return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:
            [self performSegueWithIdentifier:@"Home" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"AboutUs" sender:nil];
            break;
        case 4:
            [self performSegueWithIdentifier:@"ChangePasswordSegue" sender:nil];
            break;
    default:
            break;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 140;
    }
    else return 44;
}

- (IBAction)logout:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:@"" forKey:@"login"];
    [defaults setObject:@"" forKey:@"UserCodeKey"];
    [defaults setBool:NO forKey:kLOGGED_IN_KEY];
    
    for (UIViewController *viewC in self.revealViewController.navigationController.viewControllers)
    {
        if ([viewC isKindOfClass:[LoginViewController class]])
        {
            [self.revealViewController.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    
    LoginViewController *loginVC =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewControllerID"];
    [self.revealViewController.navigationController setViewControllers:@[loginVC] animated:YES];
    _logoutView.backgroundColor=[UIColor colorWithRed:0 green:0.62 blue:0.32 alpha:1];
}
@end
