//
//  FCMessageCellTableViewCell.m
//  FreeChat
//
//  Created by Feng Junwen on 3/3/15.
//  Copyright (c) 2015 Feng Junwen. All rights reserved.
//

#import "FCMessageCell.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "UUAVAudioPlayer.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "UUImageAvatarBrowser.h"
#import "NSDate+Utils.h"
#import "AVUserStore.h"

@interface FCMessageCell () <UUAVAudioPlayerDelegate> {
    AVAudioPlayer *player;
    NSString *voiceURL;
    NSData *songData;
    
    UUAVAudioPlayer *audio;
    
    UIView *headImageBackView;
}

@end

@implementation FCMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 1、创建时间
        self.labelTime = [[UILabel alloc] init];
        self.labelTime.textAlignment = NSTextAlignmentCenter;
        self.labelTime.textColor = [UIColor grayColor];
        self.labelTime.font = ChatTimeFont;
        [self.contentView addSubview:self.labelTime];
        
        // 2、创建头像
        headImageBackView = [[UIView alloc]init];
        headImageBackView.layer.cornerRadius = 22;
        headImageBackView.layer.masksToBounds = YES;
        headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:headImageBackView];
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHeadImage.layer.cornerRadius = 20;
        self.btnHeadImage.layer.masksToBounds = YES;
        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [headImageBackView addSubview:self.btnHeadImage];
        
        // 3、创建头像下标
        self.labelNum = [[UILabel alloc] init];
        self.labelNum.textColor = [UIColor grayColor];
        self.labelNum.textAlignment = NSTextAlignmentCenter;
        self.labelNum.font = ChatTimeFont;
        [self.contentView addSubview:self.labelNum];
        
        // 4、创建内容
        self.btnContent = [UUMessageContentButton buttonWithType:UIButtonTypeCustom];
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = ChatContentFont;
        self.btnContent.titleLabel.numberOfLines = 0;
        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnContent];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UUAVAudioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];
        
    }
    return self;
}

//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(headImageDidClick:userId:)])  {
        [self.delegate headImageDidClick:self userId:self.messageFrame.message.byClient];
    }
}


- (void)btnContentClick{
    //play audio
    if (![self.messageFrame.message.imMessage isKindOfClass:[AVIMTypedMessage class]]) {
        [self.btnContent becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
        [menu setMenuVisible:YES animated:YES];
    } else {
        UIMenuController *menu = nil;
        AVIMTypedMessage *typedMessage = (AVIMTypedMessage*)self.messageFrame.message.imMessage;
        switch (typedMessage.mediaType) {
            case kAVIMMessageMediaTypeText:
                [self.btnContent becomeFirstResponder];
                menu = [UIMenuController sharedMenuController];
                [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
                [menu setMenuVisible:YES animated:YES];
                break;
            case kAVIMMessageMediaTypeImage:
                if (self.btnContent.backImageView) {
                    [UUImageAvatarBrowser showImage:self.btnContent.backImageView];
                }
                if ([self.delegate isKindOfClass:[UIViewController class]]) {
                    [[(UIViewController *)self.delegate view] endEditing:YES];
                }
                break;
            case kAVIMMessageMediaTypeAudio:
                audio = [UUAVAudioPlayer sharedInstance];
                audio.delegate = self;
                [audio playSongWithUrl:voiceURL];
                //[audio playSongWithData:songData];
                break;
            default:
                break;
        }
    }
}

- (void)UUAVAudioPlayerBeiginLoadVoice
{
    [self.btnContent benginLoadVoice];
}
- (void)UUAVAudioPlayerBeiginPlay
{
    [self.btnContent didLoadVoice];
}
- (void)UUAVAudioPlayerDidFinishPlay
{
    [self.btnContent stopPlay];
    [[UUAVAudioPlayer sharedInstance]stopSound];
}


//内容及Frame设置
- (void)setMessageFrame:(FCMessageFrame *)messageFrame{
    
    _messageFrame = messageFrame;
    AVIMMessage *message = messageFrame.message.imMessage;
    if (!message) {
        NSString *notificationText = [Message getNotificationContent:messageFrame.message];
        self.labelTime.text = notificationText;
        self.labelTime.frame = messageFrame.timeF;
        
        headImageBackView.frame = messageFrame.iconF;
        self.labelNum.frame = messageFrame.nameF;
        self.btnContent.frame = messageFrame.contentF;
        return;
    }
    
    // 1、设置时间
    NSString *sendTime = [[NSDate dateWithTimeIntervalSinceReferenceDate:message.sendTimestamp/1000] string];
    self.labelTime.text = sendTime;
    self.labelTime.frame = messageFrame.timeF;
    
    // 2、设置头像
    UserProfile *userProfile = [[AVUserStore sharedInstance] getUserProfile:message.clientId];
    NSString *userAvatarUrl = userProfile.avatarUrl;
    NSString *userName = userProfile.nickname;
    headImageBackView.frame = messageFrame.iconF;
    self.btnHeadImage.frame = CGRectMake(2, 2, ChatIconWH-4, ChatIconWH-4);
    [self.btnHeadImage setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:userAvatarUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    // 3、设置下标
    self.labelNum.text = userName;
    if (messageFrame.nameF.origin.x > 160) {
        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x - 50, messageFrame.nameF.origin.y + 3, 100, messageFrame.nameF.size.height);
        self.labelNum.textAlignment = NSTextAlignmentRight;
    }else{
        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x, messageFrame.nameF.origin.y + 3, 80, messageFrame.nameF.size.height);
        self.labelNum.textAlignment = NSTextAlignmentLeft;
    }
    
    // 4、设置内容
    
    //prepare for reuse
    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
    self.btnContent.voiceBackView.hidden = YES;
    self.btnContent.backImageView.hidden = YES;
    
    self.btnContent.frame = messageFrame.contentF;
    
    if (message.ioType == AVIMMessageIOTypeOut) {
        self.btnContent.isMyMessage = YES;
        [self.btnContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, ChatContentBottom, ChatContentLeft);
    }else{
        self.btnContent.isMyMessage = NO;
        [self.btnContent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, ChatContentBottom, ChatContentRight);
    }
    
    if (![message isKindOfClass:[AVIMTypedMessage class]]) {
        [self.btnContent setTitle:message.content forState:UIControlStateNormal];
    } else {
        switch (((AVIMTypedMessage*)message).mediaType) {
            case kAVIMMessageMediaTypeText:
                [self.btnContent setTitle:((AVIMTextMessage*)message).text forState:UIControlStateNormal];
                break;
            case kAVIMMessageMediaTypeImage:
                self.btnContent.backImageView.hidden = NO;
                [self.btnContent.backImageView setImageWithURL:[NSURL URLWithString:((AVIMImageMessage*)message).file.url]];
                break;
            case kAVIMMessageMediaTypeAudio:
                self.btnContent.voiceBackView.hidden = NO;
                self.btnContent.second.text = [NSString stringWithFormat:@"%.1f's ",((AVIMAudioMessage*)message).duration];
                voiceURL = ((AVIMAudioMessage*)message).file.url;
                break;
                
            default:
                break;
        };
    }

    //背景气泡图
    UIImage *normal;
    if (message.ioType == AVIMMessageIOTypeOut) {
        normal = [UIImage imageNamed:@"chatto_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
    } else {
        normal = [UIImage imageNamed:@"chatfrom_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
    }
    
    [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
    [self.btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];
}

@end
