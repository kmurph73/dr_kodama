//
//  MacAppDelegate.swift
//  DrKodamaMac
//
//  Created by Kyle Murphy on 2026.
//

import Cocoa
import SpriteKit

class MacAppDelegate: NSObject, NSApplicationDelegate {
  var window: NSWindow!
  var gameViewController: MacGameViewController!

  func applicationDidFinishLaunching(_ notification: Notification) {
    NSApp.setActivationPolicy(.regular)
    assessState()
    setupMainMenu()

    let windowSize = NSSize(width: 400, height: 720)
    window = NSWindow(
      contentRect: NSRect(origin: .zero, size: windowSize),
      styleMask: [.titled, .closable, .miniaturizable],
      backing: .buffered,
      defer: false
    )
    window.title = "Dr. Kodama"
    window.center()

    gameViewController = MacGameViewController()
    window.contentViewController = gameViewController
    window.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
  }

  func setupMainMenu() {
    let mainMenu = NSMenu()

    let appMenuItem = NSMenuItem()
    mainMenu.addItem(appMenuItem)

    let appMenu = NSMenu()
    appMenu.addItem(withTitle: "About Dr. Kodama", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
    appMenu.addItem(NSMenuItem.separator())
    appMenu.addItem(withTitle: "Quit Dr. Kodama", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
    appMenuItem.submenu = appMenu

    let windowMenuItem = NSMenuItem()
    mainMenu.addItem(windowMenuItem)

    let windowMenu = NSMenu(title: "Window")
    windowMenu.addItem(withTitle: "Close", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")
    windowMenu.addItem(withTitle: "Minimize", action: #selector(NSWindow.performMiniaturize(_:)), keyEquivalent: "m")
    windowMenuItem.submenu = windowMenu

    NSApp.mainMenu = mainMenu
    NSApp.windowsMenu = windowMenu
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}
