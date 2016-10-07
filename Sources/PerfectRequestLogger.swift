import PerfectLib
import PerfectHTTP
import PerfectNet
import Foundation

public class RequestLogger {
	struct LogRequestFilter: HTTPRequestFilter {
		func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {

			request.scratchPad["start"] = Date()

			// TODO Could add a request ID here

			callback(.continue(request, response))
		}
	}

	struct LogResponseFilter: HTTPResponseFilter {
		func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
			let hostname = response.request.serverName
			let method = response.request.method
			let requestURL = response.request.uri
			let remoteAddress = response.request.remoteAddress.host
			let start = response.request.scratchPad["start"] as! Date
			let protocolVersion = response.request.protocolVersion
			let status = response.status.code
			let length = response.bodyBytes.count
			let requestProtocol = response.request.connection is PerfectNet.NetTCPSSL ? "HTTPS" : "HTTP"

			let interval = start.timeIntervalSinceNow * -1

			Log.info(message: "[\(hostname)] \(start) \"\(method) \(requestURL) \(requestProtocol)/\(protocolVersion.0).\(protocolVersion.1)\" from \(remoteAddress) - \(status) \(length)B in \(interval)s")

			callback(.continue)
		}

		func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
			callback(.continue)
		}
	}

	public init() {
		// Do nothing
	}

	public func requestFilter() -> HTTPRequestFilter {
		return LogRequestFilter()
	}

	public func responseFilter() -> HTTPResponseFilter {
		return LogResponseFilter()
	}
}
