#import "SecondVC.h"

@interface SecondVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@end

@implementation SecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationTextField.delegate = self;
}


- (IBAction)changeLocationPressed:(id)sender {
    [self.locationTextField resignFirstResponder];
    NSUInteger index = [self.locationTextField.text integerValue];
    
    [self.commonDelegate changeBROptionsButtonLocaitonTo:index animated:YES];
}

#pragma mark - UItextField 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.locationTextField resignFirstResponder];
    return YES;
}

@end
