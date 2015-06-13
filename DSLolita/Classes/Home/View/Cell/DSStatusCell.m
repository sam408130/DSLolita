//
//  DSStatusCell.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/26.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSStatusCell.h"
#import "DSStatusDetailView.h"
#import "DSStatusToolbar.h"
#import "DSStatusFrame.h"
#import "DSStatusDetailFrame.h"
#import "DSStatusOriginalFrame.h"
#import "DSStatus.h"
#import "DSUser.h"
#import "NSString+Additions.h"


@interface DSStatusCell()

@property (nonatomic , weak) DSStatusToolbar *toolbar;
@property (nonatomic , assign) BOOL drawed;

@end


@implementation DSStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tablView {
    
    static NSString *ID = @"statusCell";
    DSStatusCell *cell = [tablView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DSStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加Feed具体内容
        [self setupDetailView];
        //添加工具条
        [self setupToolbar];
        //cell设置
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        //self.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
    
}



- (void)setupDetailView {
    
    DSStatusDetailView *detailView = [[DSStatusDetailView alloc] init];
    [self.contentView addSubview:detailView];
    self.detailView = detailView;
}


- (void)setupToolbar {
    
    DSStatusToolbar *toolbar = [[DSStatusToolbar alloc] init];
    
    [toolbar.commentsBtn addTarget:self action:@selector(commentsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar.attitudesBtn addTarget:self action:@selector(attitudesBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar.messageBtn addTarget:self action:@selector(messageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar.repostsBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:toolbar];
    self.toolbar = toolbar;
}


- (void)commentsBtnClicked:(UIButton *)sender{
    
    if ([_delegate respondsToSelector:@selector(didCommentButtonClicked:indexPath:)]){
        [_delegate didCommentButtonClicked:sender indexPath:self.indexpath];
    }
}

- (void)attitudesBtnClicked:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(didLikeButtonClicked:indexPath:)]){
        [_delegate didLikeButtonClicked:sender indexPath:self.indexpath];
    }
}

- (void)messageBtnClicked:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(didMessageButtonClicked:indexPath:)]){
        [_delegate didMessageButtonClicked:sender indexPath:self.indexpath];
    }
}


- (void)shareBtnClicked:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(didShareButtonClicked:indexPath:)]){
        
        [_delegate didShareButtonClicked:sender indexPath:self.indexpath];
    }
}

- (void)setStatusFrame:(DSStatusFrame *)statusFrame {
    
    _statusFrame = statusFrame;
    
    self.detailView.detailFrame = statusFrame.statusDetailFrame;
    self.toolbar.frame = statusFrame.statusToolbarFrame;
    self.toolbar.status = statusFrame.status;
    
    
}









@end
