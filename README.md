# Perfect-RequestLogger
Swift Package Manager (SPM) module which provides request logging filters for use with the [Perfect](hhttp://perfect.org/) framework for server-side Swift.

## Example Log Output

```
[INFO] [servername/WuAyNIIU-1] 2016-10-07 21:49:04 +0000 "GET /one HTTP/1.1" from 127.0.0.1 - 200 64B in 0.000436007976531982s
[INFO] [servername/WuAyNIIU-2] 2016-10-07 21:49:06 +0000 "GET /two HTTP/1.1" from 127.0.0.1 - 200 64B in 0.000207006931304932s
[INFO] [servername/WuAyNIIU-3] 2016-10-07 21:49:07 +0000 "GET /three HTTP/1.1" from 127.0.0.1 - 200 66B in 0.00014495849609375s
```

## Use

Add the following dependency to the `Package.swift` file:

```swift
.Package(url: "https://github.com/dabfleming/Perfect-RequestLogger.git", majorVersion: 0, minor: 2)
```

Import `PerfectRequestLogger`.

Modify your server setup:

```swift
// Instantiate a logger
let myLogger = RequestLogger()

// Add the filters
// Request filter at high priority to be executed first
server.setRequestFilters([(myLogger, .high)])
// Response filter at low priority to be executed last
server.setResponseFilters([(myLogger, .low)])
```
