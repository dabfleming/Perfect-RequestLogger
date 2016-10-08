import PerfectLib
import PerfectHTTP
import PerfectNet
import Foundation

public class RequestLogger: HTTPRequestFilter, HTTPResponseFilter {

	var randomID: String
	var sequence: UInt32

	public init() {
		// Generate random string to prefix request IDs
		randomID = randomAlphaNumericString(length: 8)
		// Initialize a request count
		sequence = 0
	}

	// Implement HTTPRequestFilter
	public func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {

		// Store request start time
		request.scratchPad["start"] = Date()

		// Store a unique request ID, this can be used in other logging to correlate to the request log
		sequence += 1
		request.scratchPad["requestID"] = "\(randomID)-\(sequence)"

		callback(.continue(request, response))
	}

	// Implement HTTPResponseFilter
	public func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
		let hostname = response.request.serverName
		let requestID = response.request.scratchPad["requestID"] as! String
		let method = response.request.method
		let requestURL = response.request.uri
		let remoteAddress = response.request.remoteAddress.host
		let start = response.request.scratchPad["start"] as! Date
		let protocolVersion = response.request.protocolVersion
		let status = response.status.code
		let length = response.bodyBytes.count
		let requestProtocol = response.request.connection is PerfectNet.NetTCPSSL ? "HTTPS" : "HTTP"

		let interval = start.timeIntervalSinceNow * -1

		Log.info(message: "[\(hostname)/\(requestID)] \(start) \"\(method) \(requestURL) \(requestProtocol)/\(protocolVersion.0).\(protocolVersion.1)\" from \(remoteAddress) - \(status) \(length)B in \(interval)s")

		callback(.continue)
	}

	// Implement HTTPResponseFilter
	public func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
		callback(.continue)
	}
}

// http://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift
func randomAlphaNumericString(length: Int) -> String {

	let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	let allowedCharsCount = UInt32(allowedChars.characters.count)
	var randomString = ""

	for _ in 0..<length {
		let randomNum = Int(arc4random_uniform(allowedCharsCount))
		let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
		let newCharacter = allowedChars[randomIndex]
		randomString += String(newCharacter)
	}

	return randomString
}
