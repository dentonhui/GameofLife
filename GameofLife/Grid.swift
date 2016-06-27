//
//  Grid.swift
//  GameofLife
//
//  Created by Denton Hui on 6/22/16.
//  Copyright © 2016 Denton Hui. All rights reserved.
//

import SpriteKit

class Grid: SKSpriteNode {
    
    var population = 0
    var generation = 0
    
    /* Grid array dimensions */
    let rows = 8
    let columns = 10
    
    /* Creature Array */
    var gridArray = [[Creature]]()
    
    /* Individual cell dimension, calculated in setup*/
    var cellWidth = 0
    var cellHeight = 0
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        /* There will only be one touch as multi touch is not enabled by default */
        for touch in touches {
            
            /* Grab position of touch relative to the grid */
            let location  = touch.locationInNode(self)
            
            let gridX = Int(location.x) / cellWidth
            let gridY = Int(location.y) / cellHeight
            
            let creature = gridArray[gridX][gridY]
            
        
            creature.isAlive = !creature.isAlive
        }
    }
    
    func populateGrid() {
        /* Populate the grid with creatures */
        
        /* Loop through columns */
        for gridX in 0..<columns {
            
            /* Initialize empty column */
            gridArray.append([])
            
            /* Loop through rows */
            for gridY in 0..<rows {
                
                /* Create a new creature at row / column position */
                addCreatureAtGrid(x: gridX, y:gridY)
            }
        }
    }
    
    func addCreatureAtGrid(x x: Int, y: Int) {
        let creature = Creature()
        
        let gridPosition = CGPoint(x: x*cellWidth, y: y*cellHeight)
        creature.position = gridPosition
        
        addChild(creature)
        
        gridArray[x].append(creature)
        
        creature.isAlive = false
        
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /* Enable own touch implementation for this node */
        userInteractionEnabled = true
        
        /* Calculate individual cell dimensions */
        cellWidth = Int(size.width) / columns
        cellHeight = Int(size.height) / rows
        
        populateGrid()
        
    }
    
    func countNeighbors() {
        
        // Loop cycles through all creatures
        for x in 0..<columns {
            for y in 0..<rows {
               
                // Set creature's neighbor count to 0
                let creature = gridArray[x][y]
                creature.neighborCount = 0
               
                // Loop checks creature's neighbors
                for innerX in (x-1)...(x+1) {
                    // If statement checks if surrounding neighbors are in the array
                    if innerX < 0 || innerX >= columns {continue}
                    
                    for innerY in (y-1)...(y+1) {
                        if innerY < 0 || innerY >= rows  {continue}
                        
                        // Makes sure to not count itself as a neighbor
                        if innerY == y && innerX == x {continue}
                            
                        let neighbor = gridArray[innerX][innerY]
                        if neighbor.isAlive {
                            creature.neighborCount += 1
                        }
                        
                    }
                }
            }
        }
    }
    
    func updateCreatures() {
        
        // Reset population counter
        population = 0
        
        // Cycles through all creatures
        for x in 0..<columns {
            for y in 0..<rows {
                
                // Implements ruleset
                let creature = gridArray[x][y]
                if creature.neighborCount < 2 || creature.neighborCount > 3{
                    creature.isAlive = false
                }
                if creature.neighborCount == 3 {
                    creature.isAlive = true
                }
                if creature.isAlive == true {
                    population += 1
                }
            }
        }
    }
    
    func evolve() {
        /* Updated the grid to the next state in the game of life */
        
        /* Update all creature neighbor counts */
        countNeighbors()
        
        /* Calculate all creatures alive or dead */
        updateCreatures()
        
        /* Increment generation counter */
        generation += 1
    }
}