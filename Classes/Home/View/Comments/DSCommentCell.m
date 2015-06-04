//
//  DSCommentCell.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/3.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSCommentCell.h"
#import "DSCommentDetailView.h"
#import "DSCommentDetailFrame.h"
#import "DSCommentCellFrame.h"
@implementation DSCommentCell







+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"CommentCell";
    DSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell){
        cell = [[DSCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }

    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        // 添加comment内容
        [self setupCommentDetailView];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}


- (void)setupCommentDetailView{
    
    DSCommentDetailView *detailView = [[DSCommentDetailView alloc] init];
    [self.contentView addSubview:detailView];
    self.commentDetailView = detailView;
    
}



- (void)setCommentFrame:(DSCommentCellFrame *)commentFrame {
    
    _commentFrame = commentFrame;
    
    self.commentDetailView.commentDetailFrame = commentFrame.commentDetailFrame;
    self.commentDetailView.commentDetailFrame.commentData = commentFrame.commentData;
    
}







- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
