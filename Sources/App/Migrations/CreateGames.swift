//
//  CreateGames.swift
//  
//
//  Created by Lucas Brandão on 29/08/22.
//

import Fluent

struct CreateGames: Migration {
        
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Game.schema)
            .id()
            .field("title", .string, .required)
            .field("genres", .array(of: .string), .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Game.schema).delete()
    }
    
    
}
