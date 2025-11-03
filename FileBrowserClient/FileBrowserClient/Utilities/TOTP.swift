//
//  TOTP.swift
//  FileBrowserClient
//
//  Created by Vignesh Rao on 11/2/25.
//

import Foundation
import CryptoKit

// MARK: - Base32 Decode (RFC 4648)
func base32Decode(_ base32: String) -> Data? {
    let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ234567")
    var bits = ""
    var output = Data()
    let cleaned = base32.uppercased().replacingOccurrences(of: "=", with: "")
    
    for char in cleaned {
        guard let index = alphabet.firstIndex(of: char) else { return nil }
        let value = alphabet.distance(from: alphabet.startIndex, to: index)
        bits += String(value, radix: 2).leftPadding(toLength: 5, withPad: "0")
    }
    
    // Walk the bit string in 8-bit chunks
    var i = bits.startIndex
    while i < bits.endIndex {
        let end = bits.index(i, offsetBy: 8, limitedBy: bits.endIndex) ?? bits.endIndex
        let byteBits = String(bits[i..<end])
        if byteBits.count == 8, let byte = UInt8(byteBits, radix: 2) {
            output.append(byte)
        }
        i = end
    }
    
    return output
}

extension String {
    func leftPadding(toLength: Int, withPad: String) -> String {
        if self.count < toLength {
            return String(repeating: withPad, count: toLength - self.count) + self
        }
        return self
    }
}

// MARK: - TOTP Generator
func generateTOTP(secret: String,
                  time: Date = Date(),
                  digits: Int = 6,
                  period: TimeInterval = 30,
                  algorithm: HMAC<Insecure.SHA1>.Type = HMAC<Insecure.SHA1>.self) -> String? {
    
    guard let keyData = base32Decode(secret) else { return nil }
    let counter = UInt64(floor(time.timeIntervalSince1970 / period))
    
    var bigEndianCounter = counter.bigEndian
    let counterData = Data(bytes: &bigEndianCounter, count: MemoryLayout<UInt64>.size)
    
    let hmac = HMAC<Insecure.SHA1>.authenticationCode(for: counterData, using: SymmetricKey(data: keyData))
    let hash = Data(hmac)
    
    let offset = Int(hash.last! & 0x0f)
    let truncatedHash = hash.subdata(in: offset..<(offset + 4))
    var number = truncatedHash.withUnsafeBytes { $0.load(as: UInt32.self) }
    number = UInt32(bigEndian: number) & 0x7fffffff
    
    let otp = number % UInt32(pow(10, Float(digits)))
    return String(format: "%0*u", digits, otp)
}
