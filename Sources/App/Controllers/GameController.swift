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
    func index(req: Request) throws -> EventLoopFuture<[Game]> {
        return Game.query(on: req.db).all()
    }
    
    //MARK: POST /songs
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let game = try req.content.decode(Game.self)
        
        guard game.title.count > 3 else {
            throw GameError.invalidTitle
        }
        
        guard game.isGenresValid else {
            throw GameError.invalidGenres
        }
        
        return game.save(on: req.db).transform(to: .ok)
    }
    
    //MARK: PUT /songs
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let game = try req.content.decode(Game.self)
        
        guard game.title.count > 3 else {
            throw GameError.invalidTitle
        }
        
        guard game.isGenresValid else {
            throw GameError.invalidGenres
        }
        
        return Game.find(game.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.title = game.title
                $0.genres = game.genres
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    //MARK: DELETE /songs/id
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Game.find(req.parameters.get("gameID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.delete(on: req.db)
            }
            .transform(to: .ok)
    }
}
