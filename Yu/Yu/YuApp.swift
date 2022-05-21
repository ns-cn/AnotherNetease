//
//  YuApp.swift
//  Yu
//
//  Created by tangyujun on 2022/5/21.
//
import SwiftUI

@main
struct YuApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup{
            ContentView()
        }
        .windowToolbarStyle(.expanded)
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            CommandGroup(replacing: .appVisibility, addition: {
                
            })
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate{
    
    // status bar item
    var statusItem: NSStatusItem?
    // popover
    var popOver = NSPopover()
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApp.hide(nil)
        return false
    }
    
    func applicationWillUpdate(_ notification: Notification) {
        print("applicationWillUpdate")
    }
    func applicationDidUpdate(_ notification: Notification){
        print("applicationDidUpdate")
    }
    func application(_ application: NSApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        print("application willContinueUserActivityWithType: \(userActivityType)")
        return true
    }
    func application(_ application: NSApplication, didUpdate userActivity: NSUserActivity) {
        print("application userActivity: \(userActivity)")
    }
    func applicationWillHide(_ notification: Notification) {
        print("applicationWillHide")
    }
    func applicationDidHide(_ notification: Notification) {
        print("applicationDidHide")
    }
    func applicationWillUnhide(_ notification: Notification) {
        print("applicationWillUnhide")
    }
    func applicationDidUnhide(_ notification: Notification) {
        print("applicationDidUnhide")
    }
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("applicationDidFinishLaunching")
    }
    func applicationWillResignActive(_ notification: Notification) {
        print("applicationWillResignActive")
    }
    func applicationDidChangeOcclusionState(_ notification: Notification) {
        print("applicationDidChangeOcclusionState")
        if let window = NSApp.windows.first, window.isMiniaturized {
            NSWorkspace.shared.runningApplications.first(where: {
                $0.activationPolicy == .regular
            })?.activate(options: .activateAllWindows)
        }
    }
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        print("windowShouldClose")
        return false
    }
    func applicationWillBecomeActive(_ notification: Notification) {
        print("applicationWillBecomeActive")
        if let window = NSApp.windows.first {
            window.deminiaturize(nil)
        }
    }
    func applicationDidBecomeActive(_ notification: Notification) {
        print("applicationDidBecomeActive")
        if let window = NSApp.windows.first {
            window.deminiaturize(nil)
        }
    }
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        print("applicationShouldHandleReopen")
        if !flag {
            for window: AnyObject in sender.windows {
                if window.frameAutosaveName == "Main Window" {
                window.makeKeyAndOrderFront(self)
                }
            }
            return true
        }
        return true
    }
    
    func createStatusBar(){
        // menu view
        let menuView = ContentView()
        // create popOver
        popOver.behavior = .transient
        popOver.animates = true
        // Settnig empty view controller
        // and setting view as swiftUI view
        // with the help of hosting controller
        popOver.contentViewController = NSViewController()
        popOver.contentViewController?.view = NSHostingView(rootView: menuView)
        
        // also making view as main view
        popOver.contentViewController?.view.window?.makeKey()
        
        //create status bar button
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let menuButton = statusItem?.button{
            menuButton.image = NSImage(systemSymbolName: "music.quarternote.3", accessibilityDescription: nil)
            menuButton.action = #selector(MenuButtonToggle)
        }
    }
    
    // Button action
    @objc func MenuButtonToggle(sender: AnyObject){
        // for sfaer side
        
        if popOver.isShown{
            popOver.performClose(sender)
        }else{
            // show popover
            if let menuButton = statusItem?.button{
                print(statusItem!.length)
                // top get button location for popover
                self.popOver.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .minY)
            }
        }
    }
    
}
