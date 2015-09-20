import Cocoa

class RightClickStatusItemView: NSControl {
    
    var statusItem: NSStatusItem!
    var image: NSImage!
    var alternateImage: NSImage!
    var mouseDown = false
    var leftClickAction: Selector?
    var rightClickAction: Selector?
    
    init(statusItem: NSStatusItem) {
        
        let rect: NSRect! = statusItem.button!.bounds;
        super.init(frame: rect)
        
        
        self.statusItem = statusItem
        self.image = statusItem.image
        
        // Default alternate image is inverted image
        
        let ciImage: CIImage = CIImage(data: self.image.TIFFRepresentation)
        let filter: CIFilter = CIFilter(name: "CIColorInvert")
        filter.setDefaults()
        filter.setValue(ciImage, forKey: "inputImage")
        let output: CIImage = filter.valueForKey("outputImage") as! CIImage
        let rep: NSCIImageRep = NSCIImageRep(CIImage: output)
        alternateImage = NSImage(size: rep.size)
        alternateImage.addRepresentation(rep)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeImage(image: NSImage) {
        self.image = image
        
        // Default alternate image is inverted image
        
        let ciImage: CIImage = CIImage(data: self.image.TIFFRepresentation)
        let filter: CIFilter = CIFilter(name: "CIColorInvert")
        filter.setDefaults()
        filter.setValue(ciImage, forKey: "inputImage")
        let output: CIImage = filter.valueForKey("outputImage") as! CIImage
        let rep: NSCIImageRep = NSCIImageRep(CIImage: output)
        self.alternateImage = NSImage(size: rep.size)
        self.alternateImage.addRepresentation(rep)
        
        self.display();
    }
    
    override func drawRect(dirtyRect: NSRect) {
        statusItem.drawStatusBarBackgroundInRect(self.bounds, withHighlight: mouseDown)
        
        let imageRect = NSInsetRect(self.bounds, 4.0, 2.0)
        let appearance = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") ?? "Light"
        
        if mouseDown || appearance == "Dark" {
            self.alternateImage.drawInRect(imageRect, fromRect: NSZeroRect, operation:NSCompositingOperation.CompositeSourceOver, fraction: 1)
        } else {
            self.image.drawInRect(imageRect, fromRect: NSZeroRect, operation:NSCompositingOperation.CompositeSourceOver, fraction: 1)
        }
        
    }
    
    override func mouseUp(event: NSEvent) {
        mouseDown = false
        self.display()
    }
    
    override func mouseDown(event: NSEvent) {
        mouseDown = true
        self.display()
        NSApplication.sharedApplication().sendAction(leftClickAction!, to: self.target, from: self)
    }
    
    override func rightMouseUp(event: NSEvent) {
        mouseDown = false
        self.display()
    }
    
    override func rightMouseDown(event: NSEvent) {
        mouseDown = true
        self.display()
        NSApplication.sharedApplication().sendAction(rightClickAction!, to: self.target, from: self)
    }
}
