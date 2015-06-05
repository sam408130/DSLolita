//
//  DSSessionStateView.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/5.
//  Copyright (c) 2015年 samDing. All rights reserved.
//


#import "DSSessionStateView.h"
#import "DSReachability.h"

@interface DSSessionStateView()

@property DSIM* im;

@property DSNotify* notify;

@end

@implementation DSSessionStateView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:1];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, self.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), self.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"会话断开，请检查网络";
        [self addSubview:label];
    }
    return self;
}

-(instancetype)initWithWidth:(CGFloat)width{
    return [self initWithFrame:CGRectMake(0, 0, width, kCDSessionStateViewHight)];
}

-(void)observeSessionUpdate{
    _im=[DSIM sharedInstance];
    _notify=[DSNotify sharedInstance];
    [_notify addSessionObserver:self selector:@selector(sessionUpdated)];
    [self sessionUpdated];
}

+ (BOOL)connected
{
    DSReachability *reachability = [DSReachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)sessionUpdated
{
    //[self connected]==NO ||
    if([_im isOpened]==NO){
        if([_delegate respondsToSelector:@selector(onSessionBrokenWithStateView:)])
            [_delegate onSessionBrokenWithStateView:self];
    }else{
        if([_delegate respondsToSelector:@selector(onSessionFineWithStateView:)]){
            [_delegate onSessionFineWithStateView:self];
        }
    }
}

-(void)dealloc{
    [_notify removeSessionObserver:self];
}

@end
