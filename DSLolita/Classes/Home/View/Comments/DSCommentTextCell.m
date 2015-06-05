//
//  DSCommentTextCell.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/3.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSCommentTextCell.h"


@interface DSCommentTextCell()<UITextFieldDelegate>
    
@property (nonatomic , weak) UITextField *inputText;
@property (nonatomic , weak) UIButton *sendButton;

@end

@implementation DSCommentTextCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"CommentTextCell";
    DSCommentTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell){
        
        cell = [[DSCommentTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }

    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        self.cellType = @"CommentText";
        // 1.添加输入框
        [self setupTextView];
        
        // 2.添加发送按钮
        [self setupSendButton];
    }
    
    return self;
}


- (void)setupTextView {
    
    UITextField *textField = [[UITextField alloc] init];
    
    CGFloat cellX = DSStatusCellInset;
    CGFloat cellY = DSStatusCellInset;
    CGFloat cellW = (self.width - 3 *cellX) *0.7;
    CGFloat cellH = self.height - 2 *cellX;
    textField.frame = CGRectMake(cellX, cellY, cellW, cellH);
    textField.placeholder = @"写的什么吧!";
    textField.font = [UIFont systemFontOfSize:14];
    self.inputText = textField;
    [self addSubview:textField];
}




- (void)setupSendButton {
    
    UIButton *sendButton = [[UIButton alloc] init];
    CGFloat buttonX = CGRectGetMaxX(self.inputText.frame) + DSStatusCellInset;
    CGFloat buttonY = DSStatusCellInset;
    CGFloat buttonW = self.width - buttonX - DSStatusCellInset;
    CGFloat buttonH = self.height - 2*DSStatusCellInset;
    sendButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:sendButton];
    self.sendButton = sendButton;
}

- (void)sendButtonClicked:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(sendButtonDidPressed:)]){
        
        [_delegate sendButtonDidPressed:sender];
        
    }
    
    
}



#pragma mark - uitextfielddelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.inputText){
        [textField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        [self sendButtonClicked:self.sendButton];
    }
    
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView *viewTouched = [[touches anyObject] view];
    if(![viewTouched isKindOfClass:[UITextField class]]){
        [self.inputText resignFirstResponder];
    }
}


@end
