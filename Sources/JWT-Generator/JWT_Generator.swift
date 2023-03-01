import ArgumentParser
import Foundation

private struct PrivateKey {
    let id: String
    let content: Data
}

@main
public struct JWT: ParsableCommand {
    public init() { }

    @Flag(name: .shortAndLong, help: "Print verbose messages.")
    private var verbose: Bool = false
    
    @Option(name: .long, help: "Your issuer ID from the API Keys page in App Store Connect; for example, 57246542-96fe-1a63-e053-0824d011072a.")
    private var iss: String
    
    @Option(name: .long, help: "The key ID of the key you want to use to sign the token; for example, 5ABCD2EF12. By default, the tool tries to read it from the file name. If you use a different file name than AuthKey_<key ID>.p8, you must specify it manually with --kid option.")
    private var kid: String? = nil
    
    @Option(name: .shortAndLong, help: "Specify the path to your private key file. By default, the tool looks for a file named AuthKey_<key ID>.p8 in ./private_keys, ~/private_keys, and ~/.private_keys.")
    private var privateKeyPath: String? = nil
    
    public func run() throws {
        guard let privateKey = findPrivateKey() else {
            print("Private Key not found")
            return
        }
        
        let token = iTunesJWT(kid: privateKey.id, iss: iss)
        do {
            let jwt = try token.jwt(privateKey: privateKey.content)
            log("Key ID: \(privateKey.id)")
            log("Key Length: \(privateKey.content.count) Byte")
            print(jwt)
        } catch {
            print(error)
        }
    }
    
    private func findPrivateKey() -> PrivateKey? {
        let ppFile = privateKeyPath ?? findFileInDirectory(FileManager.default, directoryPull: ["./private_keys", "~/private_keys", "~/.private_keys"])
        
        if let file = ppFile {
            log("PK file found at: \(file)")
            guard let pkContent = FileManager.default.contents(atPath: file) else {
                print("Can't read key content")
                return nil
            }
            
            guard let keyId = kid ?? file.keyId else {
                print("You should specify key ID with --kid option.")
                return nil
            }
            
            return PrivateKey(id: keyId, content: pkContent)
        } else {
            print("File not found")
            return nil
        }
    }
    
    private func findFileInDirectory(_ fileManager: FileManager, directoryPull: [String]) -> String? {
        if directoryPull.isEmpty {
            return nil
        }
        let currentPath = directoryPull[0]
        log("Looking for PK file in \(currentPath)")
        
        let enumerator = fileManager.enumerator(atPath: currentPath)
        if let file = enumerator?
            .map({ "\($0)" })
            .first(where: { $0.isMatchPattern(String.RegEx.authKeyFile) }) {
            
            return currentPath + "/" + file
        } else {
            return findFileInDirectory(fileManager, directoryPull: Array<String>(directoryPull.dropFirst()))
        }
    }
    
    private func log(_ message: String) {
        if verbose {
            print(message)
        }
    }
}

