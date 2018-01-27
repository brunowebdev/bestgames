//
//  BestGamesTests.swift
//  BestGamesTests
//
//  Created by Bruno Alves on 19/01/18.
//  Copyright © 2018 Bruno Alves. All rights reserved.
//

import XCTest
@testable import BestGames

class BestGamesTests: XCTestCase {
    
    func testGameEntityTest() {
        let entity = GameEntity(id: 1, name: "ola mundo", channels: 123, viewers: 564, thumbnail: "url")
        XCTAssertEqual(entity.id, 1)
    }
}
