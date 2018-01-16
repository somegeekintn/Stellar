//
//  Memo.swift
//  Stellar
//
//  Created by Casey Fleser on 1/14/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation

// See https://raw.githubusercontent.com/stellar/js-stellar-base/master/src/generated/stellar-xdr_generated.js
//
//	xdr.typedef("Hash", xdr.opaque(32));
//
//	xdr.enum("MemoType", {
//	  memoNone: 0,
//	  memoText: 1,
//	  memoId: 2,
//	  memoHash: 3,
//	  memoReturn: 4,
//	});
//
//	xdr.union("Memo", {
//	  switchOn: xdr.lookup("MemoType"),
//	  switchName: "type",
//	  switches: [
//		["memoNone", xdr.void()],
//		["memoText", "text"],
//		["memoId", "id"],
//		["memoHash", "hash"],
//		["memoReturn", "retHash"],
//	  ],
//	  arms: {
//		text: xdr.string(28),
//		id: xdr.lookup("Uint64"),
//		hash: xdr.lookup("Hash"),
//		retHash: xdr.lookup("Hash"),
//	  },
//	});

enum Memo: XDRDecodable {
	case none
	case text(_ : String)
	case id(_ : UInt64)
	case hash(_ : String)
	case retHash(_ : String)

	init?(xdr: ExDR, capacity: Int = 1) {
		guard let rawValue = xdr.decodeEnum() else { return nil }
		
		switch rawValue {
			case 0:
				self = .none
				
			case 1:
				guard let str = String(xdr: xdr, capacity: 28) else { return nil }
				
				self = .text(str)
			
			case 2:
				guard let id = UInt64(xdr: xdr) else { return nil }

				self = .id(id)

			case 3:
				guard let hash = xdr.decodeBytes(32) else { return nil }

				self = .hash(Data(bytes: hash, count: hash.count).base64EncodedString())
			
			case 4:
				guard let hash = xdr.decodeBytes(32) else { return nil }

				self = .retHash(Data(bytes: hash, count: hash.count).base64EncodedString())

			default:
				return nil
		}
	}
}
