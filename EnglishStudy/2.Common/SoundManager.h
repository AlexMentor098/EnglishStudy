//
//  SoundManager.h
//  EnglishStudy
//
//  Created by admin on 1/24/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundManager : NSObject
{
    AVAudioPlayer   *_mp3Player;
}

+ (SoundManager *)sharedManager;

+ (void)playSoundFile:(NSString *)strFile ofType:(NSString *)strExt;

+ (void)playSoundMP3File:(NSString *)strFile;

+ (void)playPageEffectSound;

+ (void)playSuccessSound;

+ (void)playErrorSound;

- (void)playSoundFile:(NSString *)strFile ofType:(NSString *)strExt;

@end
