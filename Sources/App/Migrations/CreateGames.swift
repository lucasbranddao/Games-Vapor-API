//
//  CreateGames.swift
//  
//
//  Created by Lucas Brandão on 29/08/22.
//

import Fluent

struct CreateGames: AsyncMigration {
        
    func prepare(on database: Database) async throws {
        try await database.schema(Game.schema)
            .id()
            .field("title", .string, .required)
            .field("genres", .array(of: .string), .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Game.schema).delete()
    } 
}
