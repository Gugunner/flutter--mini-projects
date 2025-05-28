import Flutter
import UIKit
import BackgroundTasks


enum Channels: String {
    case dbCleaning = "com.local-persistence-form-sample.dev/db.cleaning"
}

enum ChannelMethods: String {
    case scheduleDBCleaning = "scheduleCleanDB"
    case executeClean = "cleanDB"
}

@main
@objc class AppDelegate: FlutterAppDelegate {

    let cleanHandlerIdentifier = "com.example.localPersistenceFormSample.dev.db_cleaning"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {
          registerBackgroundTask()
          let controller: FlutterViewController = window?.rootViewController as! FlutterViewController;
          let dbCleanChannel = FlutterMethodChannel(
            name: Channels.dbCleaning.rawValue,
            binaryMessenger: controller.binaryMessenger
          )

          dbCleanChannel.setMethodCallHandler({
              [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
              guard call.method == ChannelMethods.scheduleDBCleaning.rawValue else {
                  result(FlutterMethodNotImplemented)
                  return
              }
              self?.scheduleDatabaseCleaning(result)
          })
          GeneratedPluginRegistrant.register(with: self)
          return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }
    }

//MARK: - Background Tasks
extension AppDelegate {
    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: cleanHandlerIdentifier, using: nil) { [weak self] task in
            self?.handleDatabaseCleaning(with: task as! BGProcessingTask)
        }
    }
}


//MARK: - Database cleaning
extension AppDelegate {

    private func handleDatabaseCleaning(with task: BGProcessingTask) {
        task.expirationHandler = {
            print("Background Database Cleaning expired")
            task.setTaskCompleted(success: false)
        }
        Task {
            let timeout = DispatchWorkItem {
                task.setTaskCompleted(success: false)
            }

            DispatchQueue.global().asyncAfter(deadline: .now() + 25, execute: timeout)

            if let controller = window?.rootViewController as? FlutterViewController {
                let channel = FlutterMethodChannel(
                    name: Channels.dbCleaning.rawValue,
                    binaryMessenger: controller.binaryMessenger
                )
                channel
                    .invokeMethod(
                        ChannelMethods.executeClean.rawValue,
                        arguments: nil
                    ) { result in
                    timeout.cancel()
                    if let code = result as? Int, code > 0 {
                        print("Flutter clean task succeeded with code: \(code)")
                        task.setTaskCompleted(success: true)
                    } else {
                        print("Flutter clean task failed or returned 0.")
                        task.setTaskCompleted(success: false)
                    }
                }
            } else {
                print("FlutterViewController not found")
                task.setTaskCompleted(success: false)
            }
        }
    }

    func scheduleDatabaseCleaning(_ result: FlutterResult) {
        let request = BGProcessingTaskRequest(
            identifier: cleanHandlerIdentifier
        )
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = true
        do {
            try BGTaskScheduler.shared.submit(request)
            result(true)
        } catch {
            print(error)
            result(FlutterError(code: "UNAVAILABLE", message: "BGTask could not be submitted.", details: nil))
        }

    }
}
