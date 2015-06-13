//
//  LoginViewController.m
//  Lolita
//
//  Created by 赛 丁 on 15/5/19.
//  Copyright (c) 2015年 赛 丁. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "DSTabBarController.h"



@interface LoginViewController () <UITextFieldDelegate>{
    
    __weak IBOutlet UITextField *txtFieldUsername;
    __weak IBOutlet UITextField *txtFieldPassword;
    __weak IBOutlet UIButton *btnLogin;
    __weak IBOutlet UIButton *btnSignUp;
    
    UIView *viewLoading;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [txtFieldUsername setTextColor:[UIColor whiteColor]];
    [txtFieldPassword setTextColor:[UIColor whiteColor]];
}


#pragma mark - check user details
-(NSString *)checkUserDetails {
    NSCharacterSet *whiteNewChars = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString *username = [txtFieldUsername.text stringByTrimmingCharactersInSet:whiteNewChars];
    NSString *password = [txtFieldPassword.text stringByTrimmingCharactersInSet:whiteNewChars];
    
    NSString *message = @"";
    
    if ([username length] < 3){
        message = [NSString stringWithFormat:@"用户名太短啦"];
    }
    if ([password length] < 6){
        if ([message length]) message = [NSString stringWithFormat:@"%@, ",message];
        message = [NSString stringWithFormat:@"%@请谨慎设置密码",message];
    }
    
    return message;
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == txtFieldUsername)
        [txtFieldUsername becomeFirstResponder];
    else{
        [textField resignFirstResponder];
        [self buttonLoginTouched:btnLogin];
    }
    
    return (textField == txtFieldPassword);
}
- (IBAction)buttonForgotPasswordTouched:(id)sender {
    //
}

- (IBAction)buttonLoginTouched:(UIButton *)sender {
    
    NSString *errorMessage = [self checkUserDetails];
    if (![errorMessage length]){
        
        NSCharacterSet *whiteNewChars = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *username = [txtFieldUsername.text stringByTrimmingCharactersInSet:whiteNewChars];
        NSString *password = [txtFieldPassword.text stringByTrimmingCharactersInSet:whiteNewChars];
        
        //viewLoading = [_LolitaFunctions showLoadingViewWithText:@"登录中" inView:self.view];
        
        [AVUser logInWithUsernameInBackground:username password:password
                                        block:^(AVUser *user , NSError *error){
                                            //[_LolitaFunctions hideLoadingView:viewLoading];
                                            if (user != nil){
                                                
                                                DSTabBarController *vc = [[DSTabBarController alloc] init];
                                                // 切换控制器
                                                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                                                window.rootViewController = vc;
                                                
                                                NSLog(@"登陆成功");
                                            }else{
                                                NSString *errMsg = [error userInfo][@"error"];
                                                [[[UIAlertView alloc] initWithTitle:@"登录失败"
                                                                           message:[errMsg capitalizedString]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil, nil] show];
                                            }
                                        }];
        
        
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"登录失败"
                                   message:errorMessage
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil] show];
    }
    
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView *viewTouched = [[touches anyObject] view];
    if(![viewTouched isKindOfClass:[UITextField class]]){
        [txtFieldUsername resignFirstResponder];
        [txtFieldPassword resignFirstResponder];
    }
}














@end
