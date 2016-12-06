//
//  SoundManager.m
//  EnglishStudy
//
//  Created by admin on 1/24/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

SoundManager *_sharedSoundManager = nil;

+ (SoundManager *)sharedManager
{
    if( _sharedSoundManager != nil )
        return _sharedSoundManager;
    
    _sharedSoundManager = [[SoundManager alloc] init];
    
    return _sharedSoundManager;
}

+ (void)playSoundFile:(NSString *)strFile ofType:(NSString *)strExt
{
    [[SoundManager sharedManager] playSoundFile:strFile ofType:strExt];
}

+ (void)playSoundMP3File:(NSString *)strFile
{
    [SoundManager playSoundFile:strFile ofType:@"mp3"];
}

+ (void)playPageEffectSound
{
    [SoundManager playSoundFile:@"page" ofType:@"mp3"];
}

+ (void)playSuccessSound
{
    [SoundManager playSoundFile:@"success" ofType:@"mp3"];
}

+ (void)playErrorSound
{
    [SoundManager playSoundFile:@"fail" ofType:@"mp3"];
}

- (void)playSoundFile:(NSString *)strFile ofType:(NSString *)strExt
{
    NSString    *soundFilePath = [[NSBundle mainBundle] pathForResource:strFile ofType:strExt];
    NSURL       *soundUrl = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    
    _mp3Player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error: nil];
    [_mp3Player prepareToPlay];
    [_mp3Player play];
}

@end
