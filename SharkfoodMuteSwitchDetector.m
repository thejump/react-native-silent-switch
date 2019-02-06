#import "HASilentSwitchDetector.h"

void MuteSoundPlaybackComplete(SystemSoundID ssID, void *clientData)
{
    //Completion
    NSDictionary *soundCompletion = CFBridgingRelease(clientData);

    //Mute
    NSTimeInterval interval = [soundCompletion[@"interval"] doubleValue];
    NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - interval;
    BOOL isMute = elapsed < 0.2; // mute.caf is .2s long...

    //Then
    HASilentSwitchDetectorBlock then = soundCompletion[@"then"];
    then(YES, isMute);

    //Cleanup
    SystemSoundID soundID = [soundCompletion[@"soundID"] integerValue];
    AudioServicesRemoveSystemSoundCompletion(soundID);
    AudioServicesDisposeSystemSoundID(soundID);
}

@implementation HASilentSwitchDetector

+ (void)ifMute:(HASilentSwitchDetectorBlock)then
{
    //Check
    if ( !then ) {
        return;
    }

    //Create
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"mute" withExtension:@"caf"];
    SystemSoundID soundID;
    if ( AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID) == kAudioServicesNoError ) {
        //UI Sound
        UInt32 yes = 1;
        AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(soundID), &soundID,sizeof(yes), &yes);

        //Callback
        NSDictionary *soundCompletion = @{@"then" : [then copy], @"soundID" : @(soundID), @"interval" : @([NSDate timeIntervalSinceReferenceDate])};
        AudioServicesAddSystemSoundCompletion(soundID, CFRunLoopGetMain(), kCFRunLoopDefaultMode, MuteSoundPlaybackComplete, (void *)CFBridgingRetain(soundCompletion));

        //Play
        AudioServicesPlaySystemSound(soundID);
    } else {
        //Fail
        then(NO, NO);
    }
}

@end
