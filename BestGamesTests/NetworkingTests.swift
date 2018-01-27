//
//  NetworkingTests.swift
//  BestGamesTests
//
//  Created by Bruno Alves on 27/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import XCTest
@testable import BestGames
import Alamofire

class NetworkingTests: XCTestCase {
    
    func testGettingData() {
        
        let xpect = expectation(description: "networking")
        
        Alamofire.request(Endpoints.topGames.url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Client-ID": API.ClientID]).responseJSON { (response) in
            
            if response.result.isFailure {
                XCTFail("Getting data failed")
            }else{
                xpect.fulfill()
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func exampleTest(){
        XCTAssert(true)
    }
    
}
