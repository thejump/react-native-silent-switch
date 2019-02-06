    
#import "RCTSilentSwitch.h"

@implementation RCTSilentSwitch

RCT_EXPORT_MODULE()


RCT_EXPORT_METHOD(     resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
 [HASilentSwitchDetector ifMute:^(BOOL success, BOOL silent) {
    if ( success ) {
        resolve(silent);

    }
}];
 
}

@end
