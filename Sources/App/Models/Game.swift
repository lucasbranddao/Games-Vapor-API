//
//  Game.swift
//  
//
//  Created by Lucas Brandão on 29/08/22.
//

import Fluent
import Vapor

final class Game: Model, Content {
    static let schema = "games"
    static let gamesGenres = ["Adventure", "Action", "Horror", "Multiplayer", "MOBA", "FPS"]
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "genres")
    var genres: [String]
    
    init() { }
    
    init(id: UUID? = nil, title: String, genres: [String]) {
        self.id = id
        self.title = title
        self.genres = genres
    }

    var isGenresValid: Bool {
        return self.genres.allSatisfy(Game.gamesGenres.contains)
    }
}
