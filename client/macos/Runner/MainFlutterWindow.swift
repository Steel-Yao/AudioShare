import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    let contentSize = NSSize(width: 900, height: 720)
    self.setContentSize(contentSize)
    self.styleMask.insert(.resizable)
    self.contentMinSize = NSSize(width: 360, height: 520)
    self.center()

    RegisterGeneratedPlugins(registry: flutterViewController)
    super.awakeFromNib()
  }
}
