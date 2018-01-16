//
//  Signer.swift
//  Stellar
//
//  Created by Casey Fleser on 1/16/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation


// See https://raw.githubusercontent.com/stellar/js-stellar-base/master/src/generated/stellar-xdr_generated.js
//
//	xdr.struct("Signer", [
//	  ["key", xdr.lookup("SignerKey")],
//	  ["weight", xdr.lookup("Uint32")],
//	]);
//
//	xdr.union("SignerKey", {
//	  switchOn: xdr.lookup("SignerKeyType"),
//	  switchName: "type",
//	  switches: [
//		["signerKeyTypeEd25519", "ed25519"],
//		["signerKeyTypePreAuthTx", "preAuthTx"],
//		["signerKeyTypeHashX", "hashX"],
//	  ],
//	  arms: {
//		ed25519: xdr.lookup("Uint256"),
//		preAuthTx: xdr.lookup("Uint256"),
//		hashX: xdr.lookup("Uint256"),
//	  },
//	});
//
//	xdr.enum("SignerKeyType", {
//	  signerKeyTypeEd25519: 0,
//	  signerKeyTypePreAuthTx: 1,
//	  signerKeyTypeHashX: 2,
//	});

enum SignerKey: XDRDecodable, CustomStringConvertible {
	case ed25519(_: String)
	case preAuthTx(_: String)
	case hashX(_: String)

	var description		: String {
		switch self {
			case .ed25519(let addr):	return "ed25519 - \(addr)"
			case .preAuthTx(let tx):	return "preAuthTx - \(tx)"
			case .hashX(let hash):		return "ed25519 - \(hash)"
		}
	}

	init?(xdr: ExDR, capacity: Int = 1) {
		guard let rawValue	= xdr.decodeEnum() else { return nil }
		guard var keyBytes	= xdr.decodeBytes(32) else { return nil }

		switch rawValue {
			case 0:
				keyBytes.insert(6 << 3, at: 0)
				keyBytes.append(contentsOf: PublicKey.crc(keyBytes))
				
				self = .ed25519(Base32Encode(data: Data(bytes: keyBytes, count: keyBytes.count)))

			case 1:
				self = .preAuthTx(Data(bytes: keyBytes, count: keyBytes.count).base64EncodedString())
			
			case 2:
				self = .hashX(Data(bytes: keyBytes, count: keyBytes.count).base64EncodedString())
			
			default:
				return nil
		}
	}
}

class Signer: XDRDecodable, CustomStringConvertible {
	let key			: SignerKey
	let weight		: UInt32

	var description		: String {
		return "key: \(self.key), weight: \(self.weight))"
	}

	required init?(xdr: ExDR, capacity: Int = 1) {
		guard let key		= SignerKey(xdr: xdr) else { return nil }
		guard let weight	= UInt32(xdr: xdr) else { return nil }

		self.key = key
		self.weight = weight
	}
}

