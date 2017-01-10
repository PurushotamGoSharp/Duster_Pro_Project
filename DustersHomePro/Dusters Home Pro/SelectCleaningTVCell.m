#import "SelectCleaningTVCell.h"

@implementation SelectCleaningTVCell

- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];   
}
- (IBAction)deleteRowButtonAction:(id)sender {
  UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Delete Address?" message:@"Do you want to Delete the Address?" delegate:self
                                           cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertview show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
      [self.delegate deleteCell:self];
    }
    else
        [alertView removeFromSuperview];
}
@end
