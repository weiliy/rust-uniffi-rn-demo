#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(DemoRn, NSObject)

RCT_EXTERN_METHOD(
    multiply:(float)a withB:(float)b
    add:(NSUInteger)a withB:(NSUInteger)b
    withResolver:(RCTPromiseResolveBlock)resolve
    withRejecter:(RCTPromiseRejectBlock)reject
)


+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
