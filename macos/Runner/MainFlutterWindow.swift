import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController
    
    // Set fixed window size
    let windowWidth: CGFloat = 1400
    let windowHeight: CGFloat = 900
    
    // Calculate center position
    if let screen = NSScreen.main {
      let screenRect = screen.visibleFrame
      let newOriginX = screenRect.origin.x + (screenRect.width - windowWidth) / 2
      let newOriginY = screenRect.origin.y + (screenRect.height - windowHeight) / 2
      
      self.setFrame(
        NSRect(x: newOriginX, y: newOriginY, width: windowWidth, height: windowHeight),
        display: true
      )
    } else {
      self.setContentSize(NSSize(width: windowWidth, height: windowHeight))
    }
    
    // Disable window resizing by removing the resizable style mask
    self.styleMask.remove(.resizable)
    
    // Set minimum and maximum size to the same value (additional safeguard)
    self.minSize = NSSize(width: windowWidth, height: windowHeight)
    self.maxSize = NSSize(width: windowWidth, height: windowHeight)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
