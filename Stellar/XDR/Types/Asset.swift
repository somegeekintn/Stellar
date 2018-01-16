//
//  Asset.swift
//  Stellar
//
//  Created by Casey Fleser on 1/15/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation

// See https://raw.githubusercontent.com/stellar/js-stellar-base/master/src/generated/stellar-xdr_generated.js
//
//	xdr.union("Asset", {
//	  switchOn: xdr.lookup("AssetType"),
//	  switchName: "type",
//	  switches: [
//		["assetTypeNative", xdr.void()],
//		["assetTypeCreditAlphanum4", "alphaNum4"],
//		["assetTypeCreditAlphanum12", "alphaNum12"],
//	  ],
//	  arms: {
//		alphaNum4: xdr.lookup("AssetAlphaNum4"),
//		alphaNum12: xdr.lookup("AssetAlphaNum12"),
//	  },
//	});
//
//	xdr.struct("AssetAlphaNum4", [
//	  ["assetCode", xdr.opaque(4)],
//	  ["issuer", xdr.lookup("AccountId")],
//	]);
//
//	xdr.struct("AssetAlphaNum12", [
//	  ["assetCode", xdr.opaque(12)],
//	  ["issuer", xdr.lookup("AccountId")],
//	]);

enum Asset: XDRDecodable {
	case native
	case alphaNum4(code: String, issuer: PublicKey)
	case alphaNum12(code: String, issuer: PublicKey)

	init?(xdr: ExDR, capacity: Int = 1) {
		guard let rawValue = xdr.decodeEnum() else { return nil }
		
		switch rawValue {
			case 0:
				self = .native
			
			case 1:
				guard let bytes = xdr.decodeBytes(4), let code = String(utf8String: bytes) else { return nil }
				guard let issuer = PublicKey(xdr: xdr) else { return nil }

				self = .alphaNum4(code: code, issuer: issuer)
			
			case 2:
				guard let bytes = xdr.decodeBytes(12), let code = String(utf8String: bytes) else { return nil }
				guard let issuer = PublicKey(xdr: xdr) else { return nil }

				self = .alphaNum12(code: code, issuer: issuer)

			default:
				return nil
		}
	}
}
