//@ pragma UseQApplication
//@ pragma RespectSystemStyle

import QtQuick
import Quickshell

import "./Bar"
import "./Services"

ShellRoot {
    // Multi-Monitor Bars
    Variants {
        model: Quickshell.screens

        delegate: BarWindow {}
    }

    // Future App Launcher Window (Single instance or centered on active screen)
    // LauncherWindow {}

    // Headless notification catcher
    NotificationSink {}
}
