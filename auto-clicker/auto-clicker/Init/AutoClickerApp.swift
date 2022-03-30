//
//  AutoClickerApp.swift
//  auto-clicker
//
//  Created by Ben Tindall on 12/05/2021.
//

import Foundation
import SwiftUI
import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.mainWindow {
            window.titlebarAppearsTransparent = true

            let customToolbar = NSToolbar()
            customToolbar.showsBaselineSeparator = false
            window.toolbar = customToolbar
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationWillUpdate(_ notification: Notification) {
        if let menu = NSApplication.shared.mainMenu {
            if let file = menu.items.first(where: { $0.title == "File"}) {
                menu.removeItem(file);
            }
            if let edit = menu.items.first(where: { $0.title == "Edit"}) {
                menu.removeItem(edit);
            }
            if let window = menu.items.first(where: { $0.title == "Window"}) {
                menu.removeItem(window);
            }
            if let view = menu.items.first(where: { $0.title == "View"}) {
                menu.removeItem(view);
            }
            if let help = menu.items.first(where: { $0.title == "Help"}) {
                menu.removeItem(help);
            }
        }
    }
}

@main
struct AutoClickerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var themeService = ThemeService()
    
    @State private var keepWindowOnTop: Bool = false

    var body: some Scene {
//        Settings {
//            EmptyView()
//        }
        
        WindowGroup {
            ZStack {
                self.themeService.active.backgroundColour.ignoresSafeArea()
                
                MainView()
            }
            .frame(minWidth: WindowStateService.width, minHeight: WindowStateService.height)
            .frame(maxWidth: WindowStateService.width, maxHeight: WindowStateService.height)
            .environmentObject(self.themeService)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandMenu("Options") {
                Toggle("Keep window on top", isOn: self.$keepWindowOnTop)
                    .keyboardShortcut("k")
            }
        }
        .onChange(of: self.keepWindowOnTop) { isOn in
            WindowStateService.toggleKeepWindowOnTop(isOn)
        }
    }
}
