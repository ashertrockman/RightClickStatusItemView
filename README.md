# RightClickStatusItemView

An NSStatusItemView replacement that supports right click menus. You can have one menu show for a left click, and another show for a right click.
By default, the alternate image is set to the inverted image.

Example usage:

```swift
let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)

func applicationDidFinishLaunching(aNotification: NSNotification) {
    let icon = NSImage(named: "AppImage");
    icon?.setTemplate(true);
    statusItem.image = icon
    
    let view: RightClickStatusItemView = RightClickStatusItemView(statusItem: statusItem);
    view.leftClickAction = Selector("toggleLeftMenu:")
    view.rightClickAction = Selector("toggleRightMenu:")
    statusItem.view = view;
}
```

