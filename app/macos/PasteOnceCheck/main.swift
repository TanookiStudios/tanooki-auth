// Driver for scripts/check-paste-once.sh (compiled together with Runner/PasteOnce.swift, not part of the app).
//   serve <pasteboard> <code> [plain]  puts <code> on a private named pasteboard (as PasteOnce does, or a
//                                      plain copy with "plain") and answers paste requests for 5 s
//   read <pasteboard>                  prints what a paste gets, or "<empty>"
import AppKit

let args = CommandLine.arguments
let board = NSPasteboard(name: NSPasteboard.Name(args[2]))
if args[1] == "serve" {
  let once = PasteOnce(pasteboard: board)
  if args.count > 4 {
    board.clearContents()
    board.setString(args[3], forType: .string)
  } else {
    once.copy(args[3])
  }
  print("ready")
  fflush(stdout)
  RunLoop.main.run(until: Date().addingTimeInterval(5))
  board.releaseGlobally()
} else {
  print(board.string(forType: .string) ?? "<empty>")
}
