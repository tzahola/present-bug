# present-bug
Demonstration project of a bug in UIViewController presentViewController:animated:completion: on iOS 8.3. 

Usage:

1. Start the app on a device with iOS 8.3 (iOS 8.1 also works, haven't tried w/ older versions)
2. Wait until the app stops producing `kCFRunLoop ...` log lines (i.e. the main runloop goes to sleep):
```objc
   ... more lines
   2015-06-11 18:24:51.214 UIActivityViewControllerTest[526:45580] kCFRunLoopBeforeSources
   2015-06-11 18:24:51.214 UIActivityViewControllerTest[526:45580] kCFRunLoopBeforeWaiting
   2015-06-11 18:25:00.001 UIActivityViewControllerTest[526:45580] kCFRunLoopAfterWaiting
   2015-06-11 18:25:00.008 UIActivityViewControllerTest[526:45580] kCFRunLoopBeforeTimers
   2015-06-11 18:25:00.009 UIActivityViewControllerTest[526:45580] kCFRunLoopBeforeSources
   2015-06-11 18:25:00.010 UIActivityViewControllerTest[526:45580] kCFRunLoopBeforeWaiting
```
   The last line should be `kCFRunLoopBeforeWaiting`

3. Tap on the first row; this calls `presentViewController:animated:completion` to present a completely blank view controller w/ red background
4. Notice how the red view controller failed to appear
5. Tap anywhere on the screen, or shake the device, or wait until the clock on the status bar updates: the view controller should appear now
6. Tap anywhere on the red view controller to dismiss it
7. Tap on the second row; this calls `presentViewController:animated:completion:` and then calls `CFRunLoopWakeUp(CFRunLoopGetCurrent())`
8. Notice how this time, no matter what the main runloop's state was, the view controller was presented correctly. 

Rdar: http://openradar.appspot.com/19563577
