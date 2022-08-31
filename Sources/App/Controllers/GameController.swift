//
//  GameController.swift
//  
//
//  Created by Lucas Brandão on 29/08/22.
//

import Fluent
import Vapor

struct GameController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let games = routes.grouped(Game.schema.pathComponents)
        games.get(use: index)
        games.post(use: create)
        games.put(use: update)
        games.group(":gameID") { game in
            game.delete(use: delete)
        }
    }
    
    //MARK: GET /songs
    func index(req: Request) async throws -> [Game] {
        try await Game.query(on: req.db).all()
    }
    
    //MARK: POST /songs
    func create(req: Request) async throws -> HTTPStatus {
        let game = try req.content.decode(Game.self)
        
        guard game.title.count > 3 else {
            throw GameError.invalidTitle
        }
        
        guard game.isGenresValid else {
            throw GameError.invalidGenres
        }
        
        try await game.save(on: req.db)
        return .ok
    }
    
    //MARK: PUT /songs
    func update(req: Request) async throws -> HTTPStatus {
        let game = try req.content.decode(Game.self)
        
        guard game.title.count > 3 else {
            throw GameError.invalidTitle
        }
        
        guard game.isGenresValid else {
            throw GameError.invalidGenres
        }
        
        guard let gameFromDB = try await Game.find(game.id, on: req.db) else {
            throw Abort(.notFound)
        }
        gameFromDB.title = game.title
        gameFromDB.genres = game.genres
        
        try await gameFromDB.update(on: req.db)
        return .ok
    }
    
    //MARK: DELETE /songs/id
    func delete(req: Request) async throws -> HTTPStatus {
        
        guard let gameFromDB = try await Game.find(req.parameters.get("gameID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await gameFromDB.delete(on: req.db)
        return .ok
    }
}
