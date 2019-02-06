    
#import "RCTSilentSwitch.h"
#import "SharkfoodMuteSwitchDetector.h"
@implementation RCTSilentSwitch

RCT_EXPORT_MODULE()


RCT_EXPORT_METHOD(     resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
 [HASilentSwitchDetector ifMute:^(BOOL success, BOOL silent) {
    if ( success ) {
        NSString *result=silent?@"true":@"false";
       
        resolve(result);

    }
}];
 
}

@end
