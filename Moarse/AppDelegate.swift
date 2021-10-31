//
//  AppDelegate.swift
//  TableView
//
//  Created by Padraig O Cinneide on 2021-08-13.
//

import Cocoa

@main
private enum AppLauncher {
  static func main() {
    let delegate = AppDelegate()
    
    // This delegate is weakly held, but the AppDelegate doesn't seem to be deallocated anyway.
    // It would be nice to understand why...
    //  * maybe it is because this method blocks in NSApplicationMain for the runloop so
    //     the method doesn'texit and then the release at the end doesn't happen?
    NSApplication.shared.delegate = delegate

    // Loads the application menu
    var topLevelObjects: NSArray? = []
    Bundle.main.loadNibNamed("MainMenu", owner: self, topLevelObjects: &topLevelObjects)
    NSApplication.shared.mainMenu = topLevelObjects?.filter { $0 is NSMenu }.first as? NSMenu
    
    _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
  }
}


class AppDelegate: NSObject, NSApplicationDelegate {
  private var window: NSWindow
  
  override init() {
    window = NSWindow(
      
      // 1. The bounds come from the view controller, so the centering in the screen is not correct here.
      // 2. The `setFrameAutosaveName` below will overwrite the positioning with the users last
      // manually resized size, so this is really just a first-launch position.
      contentRect: NSScreen.main?.centeredInitalAppWindowRect() ?? .zero,
      
      styleMask: [.miniaturizable, .closable, .resizable, .titled],
      backing: .buffered,
      defer: true
    )
    
    window.title = "Moarse"
    window.setFrameAutosaveName("mainwindow.frame.autosave")
    window.contentViewController = MainVC()
    
    super.init()
  }

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    window.makeKeyAndOrderFront(nil)
  }
}


private extension NSScreen {
  func centeredInitalAppWindowRect() -> NSRect {
    let width = frame.width * 0.80
    let height = frame.height * 0.80
    let x = (frame.width - width) / 2
    let y = (frame.height - height) / 2
    
    return .init(x: x, y: y, width: width, height: height)
  }
}
