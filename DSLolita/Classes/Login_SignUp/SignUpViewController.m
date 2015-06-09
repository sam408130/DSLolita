//
//  SignUpViewController.m
//  Lolita
//
//  Created by 赛 丁 on 15/5/19.
//  Copyright (c) 2015年 赛 丁. All rights reserved.
//

#import "SignUpViewController.h"
#import <AddressBook/AddressBook.h>


@interface SignUpViewController () <UITextFieldDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate>{
    
    __weak IBOutlet UIImageView *imgViewProfile;
    __weak IBOutlet LolitaTextField *txtFieldEmail;
    __weak IBOutlet LolitaTextField *txtFieldUsername;
    __weak IBOutlet LolitaTextField *txtFieldPassword;
    __weak IBOutlet LolitaTextField *txtFieldPhone;
    __weak IBOutlet UIButton *btnSignUp;
    __weak IBOutlet UITextView *txtViewPolicy;

    UIView *viewLoading;
    BOOL toUploadImage;
    BOOL photoUploaded;
    
    NSArray *arrContacts;
    CGRect frameDefault;
    
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSignUpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSignUpView {
    
    frameDefault = self.view.frame;
    
    [self setTitle:@"注册"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [txtFieldEmail setLeftViewMode:UITextFieldViewModeAlways];
    [txtFieldEmail setLeftView:[_LolitaFunctions leftViewForTextFieldWithImage:@"email"]];
    
    [txtFieldUsername setLeftViewMode:UITextFieldViewModeAlways];
    [txtFieldUsername setLeftView:[_LolitaFunctions leftViewForTextFieldWithImage:@"user_grey"]];
    
    [txtFieldPassword setLeftViewMode:UITextFieldViewModeAlways];
    [txtFieldPassword setLeftView:[_LolitaFunctions leftViewForTextFieldWithImage:@"password_grey"]];
    
    [txtFieldPhone setLeftViewMode:UITextFieldViewModeAlways];
    [txtFieldPhone setLeftView:[_LolitaFunctions leftViewForTextFieldWithImage:@"phone"]];
    
    [btnSignUp setBackgroundColor:[_LolitaFunctions colorWithR:36 g:164 b:193 alpha:1.0f]];
    [btnSignUp.layer setCornerRadius:3.0f];
    
    [imgViewProfile.layer setBorderColor:[UIColor colorWithWhite:220/255.0f alpha:1.0f].CGColor];
    [imgViewProfile.layer setBorderWidth:3.0f];
    
    [imgViewProfile.layer setCornerRadius:imgViewProfile.frame.size.width/2.0f];
}


- (void)resetTextFields {
    [txtFieldEmail setText:nil];
    [txtFieldUsername setText:nil];
    [txtFieldPassword setText:nil];
    [txtFieldPhone setText:nil];
}

#pragma mark - resign responders

-(void)resignRespondersForTextFields {
    [UIView animateWithDuration:0.24
                     animations:^{
                         [self.view setFrame:frameDefault];
                     }
                     completion:nil];
    
    [txtFieldEmail resignFirstResponder];
    [txtFieldUsername resignFirstResponder];
    [txtFieldPassword resignFirstResponder];
    [txtFieldPhone resignFirstResponder];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = -textField.tag * textField.frame.size.height;
    [UIView animateWithDuration:0.24
                     animations:^{
                         [self.view setFrame:newFrame];
                     }completion:^(BOOL finished){
                         
                     }];

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == txtFieldEmail)
        [txtFieldUsername becomeFirstResponder];
    else if (textField == txtFieldUsername)
        [txtFieldPassword becomeFirstResponder];
    else if (textField == txtFieldPassword)
        [txtFieldPhone becomeFirstResponder];
    else
        [self resignRespondersForTextFields];
    return YES;
    
}

#pragma mark - check user details

- (BOOL)checkPhoneNumber:(NSString *)phoneNumber {
    
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSRange inputRange = NSMakeRange(0, [phoneNumber length]);
    NSArray *matches = [detector matchesInString:phoneNumber options:0 range:inputRange];
    
    BOOL verified = NO;
    
    if ([matches count] != 0) {
        // found match but we need to check if it matched the whole string
        NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
        
        if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length) {
            // it matched the whole string
            verified = YES;
        }
        else {
            // it only matched partial string
            verified = NO;;
        }
    }
    
    return verified;
}


-(NSString *)checkUserDetails {
    
    NSCharacterSet *whithNewChars = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *email = [txtFieldEmail.text stringByTrimmingCharactersInSet:whithNewChars];
    NSString *username = [txtFieldUsername.text stringByTrimmingCharactersInSet:whithNewChars];
    NSString *password = [txtFieldPassword.text stringByTrimmingCharactersInSet:whithNewChars];
    NSString *phone = [txtFieldPhone.text stringByTrimmingCharactersInSet:whithNewChars];
    
    
    BOOL phoneVerified = [self checkPhoneNumber:phone];

    NSString *message = @"";
    
    if (![_LolitaFunctions validateEmail:email]) {
        message = @"邮箱格式有误";
    }
    
    if ([username length] < 6) {
        if ([message length]) message = [NSString stringWithFormat:@"%@, ", message];
        message = [NSString stringWithFormat:@"%@用户名太短啦", message];
    }
    if ([password length] < 6) {
        if ([message length]) message = [NSString stringWithFormat:@"%@, ", message];
        message = [NSString stringWithFormat:@"%@请谨慎设置密码", message];
    }
    if (!phoneVerified) {
        if ([message length]) message = [NSString stringWithFormat:@"%@, ", message];
        message = [NSString stringWithFormat:@"%@Invalid phone number", message];
    }
    return message;
}



- (void)signUpSuccess {
    [_LolitaFunctions hideLoadingView:viewLoading];
    [self resetTextFields];
    [self.navigationController popViewControllerAnimated:YES];
    
    NSString *message = @"注册成功";
    if (!photoUploaded){
        message = [NSString stringWithFormat:@"%@,但头像没有上传成功",message];
    }
    
    [[[UIAlertView alloc] initWithTitle:@"注册" message:message
                              delegate:nil
                     cancelButtonTitle:@"确定"
                      otherButtonTitles:nil, nil] show];
    
}

- (void)checkIfToUploadImage {
    if(toUploadImage) {
        AVUser *currentUser = [AVUser currentUser];
        NSString *strImageName = [NSString stringWithFormat:@"%@.png",currentUser.objectId];
        
        NSData *imageData = UIImagePNGRepresentation(imgViewProfile.image);
        AVFile *imageFile = [AVFile fileWithName:strImageName data:imageData];
        
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (!error) {
                photoUploaded  = YES;
                [currentUser setObject:imageFile forKey:@"avatar"];
                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded , NSError *error){
                    if (!error){
                        photoUploaded = YES;
                    }else{
                        photoUploaded = NO;
                    }
                    
                    [self signUpSuccess];
                }];
            }
        }];
    }
    
}


- (IBAction)buttonSignUpTouched:(id)sender {
    
    NSString *errorMessage = [self checkUserDetails];
    if (![errorMessage length]){
        
        NSCharacterSet *whiteNewChars = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *email = [txtFieldEmail.text stringByTrimmingCharactersInSet:whiteNewChars];
        NSString *username = [txtFieldUsername.text stringByTrimmingCharactersInSet:whiteNewChars];
        NSString *password = [txtFieldPassword.text stringByTrimmingCharactersInSet:whiteNewChars];
        NSString *phone = [txtFieldPhone.text stringByTrimmingCharactersInSet:whiteNewChars];
        
        
        AVUser *user = [AVUser user];
        [user setUsername:username];
        [user setPassword:password];
        [user setEmail:email];
        user[@"phone"] = phone;
        
        
        //viewLoading = [_LolitaFunctions showLoadingViewWithText:@"正在注册" inView:self.view];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded , NSError *error) {
            if (!error){
                [self checkIfToUploadImage];
            }
            else{
                //[_LolitaFunctions hideLoadingView:viewLoading];
                [[[UIAlertView alloc] initWithTitle:@"注册失败"
                                           message:[error userInfo][@"error"]
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil, nil] show];
            }
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"注册失败"
                                   message:errorMessage
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil] show];
    }
    
}


- (IBAction)buttonChoosePhotoTapped:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    //if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        //picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //else
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerController Delegage 

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    toUploadImage = YES;
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imgViewProfile.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Touch Mechods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UIView *viewTouched = [[touches anyObject] view];
    if (![viewTouched isKindOfClass:[UITextField class]]){
        [self resignFirstResponder];
    }
}



@end
