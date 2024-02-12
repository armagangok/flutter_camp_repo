import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
       let channel = FlutterMethodChannel(name: "nativeChannel",
                                                 binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          
          switch call.method {
              case "getBatteryLevel":
                  guard call.method == "getBatteryLevel" else {
                    result(FlutterMethodNotImplemented)
                    return
                  }
                  BatteryInfoHelper.receiveBatteryLevel(result: result)
              case "getDeviceInfo":
                  guard call.method == "getDeviceInfo" else {
                    result(FlutterMethodNotImplemented)
                    return
                  }
                    DeviceInfoHelper.getDeviceInfo(result:result)
              default:
                  return
          }

        
      })
      
    
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   
}


/*import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let nativeChannel = FlutterMethodChannel(name: "nativeChannel", binaryMessenger: controller.binaryMessenger)
        let batteryChannel = FlutterMethodChannel(name: "nativeChannel", binaryMessenger: controller.binaryMessenger)
        
        
        batteryChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            guard call.method == "getBatteryLevel" else {
                result(FlutterMethodNotImplemented)
                return
            }
            BatteryInfoHelper.getBatteryLevel(result: result)
        })
        

    }

}




*/

class DeviceInfoHelper {
    static func getDeviceInfo(result: FlutterResult) {
        let uiDevice =  UIDevice.current
        
        let  osVersion = uiDevice.name;
        let  deviceId = uiDevice.identifierForVendor?.uuidString;
        
        let mapData = [
            "osVersion":osVersion,
            "deviceId":deviceId
        ]

        result(mapData)
    }
}

class BatteryInfoHelper {
    static func receiveBatteryLevel(result: FlutterResult) {
      let device = UIDevice.current
      device.isBatteryMonitoringEnabled = true
      if device.batteryState == UIDevice.BatteryState.unknown {
        result(FlutterError(code: "UNAVAILABLE",
                            message: "Battery level not available.",
                            details: nil))
      } else {
        result(Int(device.batteryLevel * 100))
      }
    }
}

