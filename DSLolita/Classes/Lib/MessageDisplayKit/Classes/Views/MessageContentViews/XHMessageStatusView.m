//
//  XHMessageStatusView.m
//  LeanChat
//
//  Created by lzw on 14/12/30.
//  Copyright (c) 2014年 AVOS. All rights reserved.
//

#import "XHMessageStatusView.h"

@implementation XHMessageStatusView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        //self.backgroundColor=[UIColor redColor];
        _indicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGPoint centerPoint=self.center;
        CGFloat x=self.bounds.size.width-_indicatorView.bounds.size.width+(_indicatorView.bounds.size.width/2)-kXHStatusViewPadding;
        centerPoint.x=x;
        _indicatorView.center=centerPoint;
        
        _indicatorView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [self addSubview:_indicatorView];

        CGFloat sentX=CGRectGetWidth(self.frame)-kXHStatusViewSentWidth;
        _sentView=[[UILabel alloc] initWithFrame:CGRectMake(sentX, self.frame.origin.y, kXHStatusViewSentWidth, kXHStatusViewSentHeight)];
        _sentView.font=[UIFont systemFontOfSize:10];
        _sentView.textAlignment=NSTextAlignmentCenter;
        _sentView.layer.cornerRadius=3;
        _sentView.layer.masksToBounds=YES;

        //[_sentView sizeToFit];
        [_sentView setText:@"sent"];
        [_sentView setBackgroundColor:[UIColor colorWithRed:249/255.0 green:140/255.0 blue:140/255.0 alpha:1]];
        //[_sentView setBackgroundColor:[UIColor greenColor]];
        [_sentView setTextColor:[UIColor whiteColor]];
        [self addSubview:_sentView];
        
        CGFloat retryX=CGRectGetWidth(self.frame)-kXHStatusViewRetryButtonSize-kXHStatusViewPadding;
        
        _retryButton=[[UIButton alloc] initWithFrame:CGRectMake(retryX, 0, kXHStatusViewRetryButtonSize,kXHStatusViewRetryButtonSize)];
        //_retryButton.center=self.center;
        [_retryButton setBackgroundImage:[UIImage imageNamed:@"messageSendFail"] forState:UIControlStateNormal];
        [self addSubview:_retryButton];
    }
    return self;
}

-(void)setStatus:(XHMessageStatus)status{
    _status=status;
    //_status=XHMessageStatusFailed;
    _indicatorView.hidden=YES;
    _sentView.hidden=YES;
    _retryButton.hidden=YES;
    switch (_status) {
        case XHMessageStatusSending:
            _indicatorView.hidden=NO;
            [_indicatorView startAnimating];
            break;
        case XHMessageStatusSent:
            _sentView.hidden=NO;
            break;
        case XHMessageStatusReceived:
            break;
        case XHMessageStatusFailed:
            _retryButton.hidden=NO;
            break;
        default:
            break;
    }
}

-(void)dealloc{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
