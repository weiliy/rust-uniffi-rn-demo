@objc(DemoRn)
class DemoRn: NSObject {

  @objc(multiply:withB:withResolver:withRejecter:)
  func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    resolve(a*b)
  }

  @objc(add:withB:withResolver:withRejecter:)
  func add(a: UInt64, b: UInt64, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    let it = add(a, b)
    resolve(it)
  }
}
