//
//  PublicKey.swift
//  Stellar
//
//  Created by Casey Fleser on 1/14/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation


// See https://raw.githubusercontent.com/stellar/js-stellar-base/master/src/generated/stellar-xdr_generated.js
//
//	xdr.typedef("AccountId", xdr.lookup("PublicKey"));
//
//	xdr.union("PublicKey", {
//	  switchOn: xdr.lookup("PublicKeyType"),
//	  switchName: "type",
//	  switches: [
//		["publicKeyTypeEd25519", "ed25519"],
//	  ],
//	  arms: {
//		ed25519: xdr.lookup("Uint256"),
//	  },
//	});
//
//	xdr.enum("PublicKeyType", {
//	  publicKeyTypeEd25519: 0,
//	});
//

enum PublicKey: XDRDecodable, CustomStringConvertible {
	case ed25519(_: String)
	
	var description		: String {
		switch self {
			case .ed25519(let addr):		return "ed25519 - \(addr)"
		}
	}

	init?(xdr: ExDR, capacity: Int = 1) {
		guard let rawValue = xdr.decodeEnum() else { return nil }
		
		switch rawValue {
			case 0:
				guard var keyBytes	= xdr.decodeBytes(32) else { return nil }
				
				keyBytes.insert(6 << 3, at: 0)
				keyBytes.append(contentsOf: PublicKey.crc(keyBytes))
				self = .ed25519(Base32Encode(data: Data(bytes: keyBytes, count: keyBytes.count)))

			default:
				return nil
		}
	}

	static func crc(_ buffer: [Int8]) -> [Int8] {
		var crc	= UInt16(0)
	
		for byte in buffer {
			var code = crc >> 8 & 0xff
			
			code ^= UInt16(UInt8(bitPattern: byte)) & 0xff
			code ^= code >> 4
			crc = crc << 8
			crc ^= code
			code = code << 5
			crc ^= code
			code = code << 7
			crc ^= code
		}

		return [Int8(bitPattern: UInt8(crc & 0xff)), Int8(bitPattern: UInt8((crc & 0xff00) >> 8))]
	}
}
