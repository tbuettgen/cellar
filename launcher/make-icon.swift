// Draws Cellar's 1024px app icon: a sheet of cells on a wine-red tile.
// Usage: swift make-icon.swift out.png
import AppKit

let size: CGFloat = 1024
let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "icon.png"

let image = NSImage(size: NSSize(width: size, height: size))
image.lockFocus()
let ctx = NSGraphicsContext.current!.cgContext

// Tile (macOS icon grid: 824px body inset 100px).
let tile = NSRect(x: 100, y: 100, width: 824, height: 824)
let tilePath = NSBezierPath(roundedRect: tile, xRadius: 185, yRadius: 185)
ctx.saveGState()
let shadow = NSShadow()
shadow.shadowColor = NSColor.black.withAlphaComponent(0.35)
shadow.shadowBlurRadius = 28
shadow.shadowOffset = NSSize(width: 0, height: -12)
shadow.set()
NSColor(red: 0.45, green: 0.08, blue: 0.20, alpha: 1).setFill()
tilePath.fill()
ctx.restoreGState()
NSGradient(colors: [
  NSColor(red: 0.64, green: 0.15, blue: 0.30, alpha: 1),
  NSColor(red: 0.34, green: 0.05, blue: 0.16, alpha: 1),
])!.draw(in: tilePath, angle: -90)

// Sheet.
let sheet = NSRect(x: 232, y: 250, width: 560, height: 524)
let sheetPath = NSBezierPath(roundedRect: sheet, xRadius: 48, yRadius: 48)
NSColor(red: 0.99, green: 0.97, blue: 0.95, alpha: 1).setFill()
sheetPath.fill()

let cols = 3, rows = 4
let cw = sheet.width / CGFloat(cols), rh = sheet.height / CGFloat(rows)

// Header row tint.
ctx.saveGState()
sheetPath.addClip()
NSColor(red: 0.95, green: 0.84, blue: 0.86, alpha: 1).setFill()
NSRect(x: sheet.minX, y: sheet.maxY - rh, width: sheet.width, height: rh).fill()
ctx.restoreGState()

// Grid lines.
let grid = NSBezierPath()
for c in 1..<cols {
  grid.move(to: NSPoint(x: sheet.minX + CGFloat(c) * cw, y: sheet.minY))
  grid.line(to: NSPoint(x: sheet.minX + CGFloat(c) * cw, y: sheet.maxY))
}
for r in 1..<rows {
  grid.move(to: NSPoint(x: sheet.minX, y: sheet.minY + CGFloat(r) * rh))
  grid.line(to: NSPoint(x: sheet.maxX, y: sheet.minY + CGFloat(r) * rh))
}
grid.lineWidth = 10
NSColor(red: 0.45, green: 0.08, blue: 0.20, alpha: 0.28).setStroke()
grid.stroke()

// Selected cell, gold.
let sel = NSRect(x: sheet.minX + cw, y: sheet.minY + rh, width: cw, height: rh).insetBy(dx: 2, dy: 2)
let selPath = NSBezierPath(roundedRect: sel, xRadius: 10, yRadius: 10)
NSColor(red: 0.98, green: 0.78, blue: 0.30, alpha: 0.35).setFill()
selPath.fill()
selPath.lineWidth = 16
NSColor(red: 0.93, green: 0.64, blue: 0.13, alpha: 1).setStroke()
selPath.stroke()

image.unlockFocus()

let rep = NSBitmapImageRep(data: image.tiffRepresentation!)!
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: out))
