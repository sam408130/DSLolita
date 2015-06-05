//
//  DSConvNameVC.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSConvNameVC.h"
#import "DSUtils.h"

@interface DSConvNameVC ()

@property (strong, nonatomic) IBOutlet UITableViewCell *tableCell;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property DSIM* im;

@property DSNotify* notify;

@end

@implementation DSConvNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"群聊名称";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveName:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop                                                                                          target:self                                                                                          action:@selector(backPressed)];
    self.nameTextField.text=_conv.displayName;
    _im=[DSIM sharedInstance];
    _notify=[DSNotify sharedInstance];
}

-(void)backPressed{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveName:(id)sender{
    if(_nameTextField.text.length>0){
        AVIMConversationUpdateBuilder* updateBuilder=[_conv newUpdateBuilder];
        [updateBuilder setName:_nameTextField.text];
        [_conv update:[updateBuilder dictionary] callback:^(BOOL succeeded, NSError *error) {
            if([DSUtils filterError:error]){
                [_notify postConvNotify];
                [self backPressed];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _tableCell;
}


@end
