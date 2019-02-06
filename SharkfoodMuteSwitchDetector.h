#import <AudioToolbox/AudioToolbox.h>

typedef void(^HASilentSwitchDetectorBlock)(BOOL success, BOOL silent);

@interface HASilentSwitchDetector : NSObject

+ (void)ifMute:(HASilentSwitchDetectorBlock)then;

@end
