
import Foundation

public class FolderMonitor {

	enum State {
		case on, off
	}

	private let source: DispatchSourceFileSystemObject
	private let descriptor: CInt
	private let qq: DispatchQueue = DispatchQueue.main
	private var state: State = .off

	/// Creates a folder monitor object with monitoring enabled.
	public init(url: URL, handler: @escaping () -> Void) {

		state = .off
		descriptor = open((url as NSURL).fileSystemRepresentation, O_EVTONLY)

		source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: descriptor, eventMask: .write, queue: qq)

		source.setEventHandler(handler: handler)
		start()
	}

	/// Starts sending notifications if currently stopped
	public func start() {
		if state == .off {
			state = .on
			source.resume()
		}
	}

	/// Stops sending notifications if currently enabled
	public func stop() {
		if state == .on {
			state = .off
			source.suspend()
		}
	}

	deinit {
		close(descriptor)
		source.cancel()
	}
}
