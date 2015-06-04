//
//  UUAVAudioPlayer.m
//  BloodSugarForDoc
//
//  Created by shake on 14-9-1.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import "UUAVAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "AVOSCloud/AVOSCloud.h"


@interface UUAVAudioPlayer ()<AVAudioPlayerDelegate>
{
    AVAudioPlayer *player;
}
@end

@implementation UUAVAudioPlayer

+ (UUAVAudioPlayer *)sharedInstance
{
    static UUAVAudioPlayer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });    
    return sharedInstance;
}

+(NSString*)dataCachePath {
    NSString *root = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cacheDir = [root stringByAppendingPathComponent:@"cacheMsgData"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    return cacheDir;
}

-(void)playSongWithUrl:(NSString *)songUrl
{
    __weak typeof(self) ws = self;
    NSURL *url = [NSURL URLWithString:songUrl];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSString *cacheFile = [[UUAVAudioPlayer dataCachePath] stringByAppendingPathComponent:url.path];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cacheFile isDirectory:NO]) {
            NSData *data = [NSData dataWithContentsOfURL:url];
            [data writeToFile:cacheFile atomically:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *songData = [NSData dataWithContentsOfFile:cacheFile];
            [ws playSongWithData:songData];
        });
    });
}

-(void)playSongWithData:(NSData *)songData
{
    [self.delegate UUAVAudioPlayerDidFinishPlay];

    if (player) {
        [player stop];
        player.delegate = nil;
        player = nil;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"VoicePlayHasInterrupt" object:nil];
    NSError *playerError;
    player = [[AVAudioPlayer alloc]initWithData:songData fileTypeHint:@"mp3" error:&playerError];
    if (nil == player) {
        NSLog(@"failed to init AudioPlayer. error: %@", playerError.description);
    }
    player.volume = 1.0f;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    player.delegate = self;
    [player play];
    [self.delegate UUAVAudioPlayerBeiginPlay];

}



- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.delegate UUAVAudioPlayerDidFinishPlay];
}

- (void)stopSound
{
    if (player && player.isPlaying) {
        [player stop];
    }
}

@end