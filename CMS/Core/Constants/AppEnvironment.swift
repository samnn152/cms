import Foundation

enum AppEnvironment {
	private static let envFileURL: URL = {
		URL(fileURLWithPath: #filePath)
			.deletingLastPathComponent()
			.deletingLastPathComponent()
			.deletingLastPathComponent()
			.deletingLastPathComponent()
			.appendingPathComponent(".env")
	}()

	static func string(for key: String) -> String? {
		if let processValue = sanitized(ProcessInfo.processInfo.environment[key]) {
			return processValue
		}

		#if DEBUG
		return envFileValues[key]
		#else
		return nil
		#endif
	}

	#if DEBUG
	private static let envFileValues: [String: String] = loadEnvFile()

	private static func loadEnvFile() -> [String: String] {
		guard let contents = try? String(contentsOf: envFileURL, encoding: .utf8) else {
			return [:]
		}

		var values: [String: String] = [:]

		for rawLine in contents.components(separatedBy: .newlines) {
			let line = rawLine.trimmingCharacters(in: .whitespacesAndNewlines)

			if line.isEmpty || line.hasPrefix("#") {
				continue
			}

			let parts = line.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
			guard parts.count == 2 else {
				continue
			}

			let key = String(parts[0]).trimmingCharacters(in: .whitespacesAndNewlines)
			let value = sanitized(String(parts[1]))

			if !key.isEmpty, let value {
				values[key] = value
			}
		}

		return values
	}
	#endif

	private static func sanitized(_ value: String?) -> String? {
		guard var trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmed.isEmpty else {
			return nil
		}

		if trimmed.hasPrefix("\""), trimmed.hasSuffix("\""), trimmed.count >= 2 {
			trimmed.removeFirst()
			trimmed.removeLast()
		}

		return trimmed.isEmpty ? nil : trimmed
	}
}
