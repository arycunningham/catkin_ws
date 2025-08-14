#!/usr/bin/env python3
# -*- coding: utf-8 -*-

############################### ############################### Libraries ###############################
############################### Author: Piaktipik
# Map libs
import pygame, sys
import configparser
import os                               # library to use some system functions

############################### ############################### Parameters ###############################
############################### Base path 
absolute_path = os.path.dirname(os.path.abspath(__file__))
relative_path = "../../.."
basePath = os.path.abspath(os.path.join(absolute_path, relative_path))
configFileName = f'{basePath}/uav4pe_mission_planner/config/configRun.cfg'
print(f'Loading Configurations from: {configFileName}...')

class MAP():
    def __init__(self):
        try:
            config = configparser.ConfigParser()
            config.read(configFileName)
            self.map2use = config['problem']['map']
        except:
            print("uav4pe_navigation::Configuration file not found.. using default map-16A.")
            self.map2use = "map-16A"    # If map is not available, we use a the default one

        """CREATING MAP-SIZE"""
        self.TILESIZE = 25
        self.MAPWIDTH = 16
        self.MAPHEIGHT = 16

        """Define Tiles"""
        T = 2       #TARGET
        U = 1       #UNEXPLORED
        G = 0       #SAFE
        S = -1      #EXPLORED
        X = -2      #UNKOWN
        R = -3      #DANGEROUS

        self.T = T      #TARGET
        self.U = U      #UNEXPLORED
        self.G = G      #SAFE
        self.S = S      #EXPLORED
        self.X = X      #UNKOWN
        self.R = R      #DANGEROUS

        """Define Tile Colour"""
        UNEXPLOREDBLUE = (0,0,255)
        TARGETYELLOW = (250,250,100)
        GRASSGREEN = (0,252,0)
        DANGERED = (200,0,0)
        EXPLOREDGREY = (150,150,150)
        UNKOWNGREY = (50,50,50)
        """
        TYPE RGB then the colour into GOOGLE to get what it's RGB numbers are
        RGB = Red, Green, Blue
        """        

        """Link Tile to Colour"""
        self.TileColour = {T : TARGETYELLOW,
                    U : UNEXPLOREDBLUE,
                    G : GRASSGREEN,
                    S : EXPLOREDGREY,
                    X : UNKOWNGREY,
                    R : DANGERED
                    }
        #alist = [[],[],[]]

        """Create Map"""
        """Specifies Rows and Columns"""
  
        self.mapA = [[X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X], #16
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,T,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,R,R,R,R,U,U,G,G,G,G,U,U,U,U,X],
                    [X,R,R,R,R,U,U,G,G,G,G,U,U,U,U,X],
                    [X,R,R,R,R,U,U,G,G,G,G,U,U,U,U,X],
                    [X,R,R,R,R,U,U,G,G,G,G,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X]
                    ]
        
        self.mapB = [[X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X], #16
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,R,R,R,R,U,U,G,G,G,G,U,U,U,U,X],
                    [X,R,R,R,R,U,U,G,G,G,G,U,U,U,U,X],
                    [X,R,R,R,R,U,U,G,G,G,G,U,U,U,U,X],
                    [X,R,R,R,R,U,U,G,G,G,G,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,T,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X]
                    ]
        
        self.mapAD = [[X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X], #16
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,T,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,R,R,R,R,R,R,G,G,G,G,U,U,U,U,X],
                    [X,R,R,R,R,R,R,G,G,G,G,U,U,U,U,X],
                    [X,R,R,R,R,R,R,G,G,G,G,U,U,U,U,X],
                    [X,R,R,R,R,R,R,G,G,G,G,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X]
                    ]
        
        self.mapBD = [[X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X], #16
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,R,R,R,R,R,R,G,G,G,G,U,U,U,U,X],
                    [X,R,R,R,R,R,R,G,G,G,G,U,U,U,U,X],
                    [X,R,R,R,R,R,R,G,G,G,G,U,U,U,U,X],
                    [X,R,R,R,R,R,R,G,G,G,G,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,T,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,U,U,U,U,U,U,U,U,U,U,U,U,U,U,X],
                    [X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X]
                    ]

        if self.map2use == "map-16A":
            self.map = self.mapA.copy()
        elif self.map2use == "map-16AD":
            self.map = self.mapAD.copy()
        elif self.map2use == "map-16B":
            self.map = self.mapB.copy()
        else:
            self.map = self.mapBD.copy()

        self.explorableCells = self.countExplorableCells()

    def getNextCloseUnexploredCell(self,position):
        sPosition = position.copy()
        nPosition = position.copy()
        # Check close positions looking for the next unexplored cell
   
        # Search positions (priority north-up, west-left, south-down, east-right)
        pPosition = [[1,0],[0,1],[-1,0],[0,-1]]
        searchD = 1; # Search Diameter, used to find closed unexplored

        while (searchD < (self.MAPWIDTH + self.MAPHEIGHT)):
            # Look in all search directions for valid and unexplored cells

            for cPos in pPosition:
                csPos = searchD*cPos.copy()
                sPosition[0] = position[0] + csPos[0]
                sPosition[1] = position[1] + csPos[1]
                # Check if it is valid
                if(self.isValid(sPosition)):
                    # Check if RSCellType is unexplored or target
                    if(self.getCellType(sPosition) > 0):
                        # Return next unexplored cell or next closest to unexplored cells.
                        nPosition[0] = position[0] + cPos[0]
                        nPosition[1] = position[1] + cPos[1]
                        return nPosition

            searchD += 1
        
        # If the normal search fail explore full map looking for unexplored and return direction
        for searchI in range(self.MAPWIDTH):
            for searchJ in range(self.MAPHEIGHT):
                sPosition[0] = searchI
                sPosition[1] = searchJ
                # Check if it is valid
                if(self.isValid(sPosition)):
                    # Check if RSCellType is unexplored or target
                    if(self.getCellType(sPosition) > 0):
                        # Return next unexplored cell or next closest to unexplored cells.
                        sPosition[0] -= int(position[0]) # The position of the founded cell is referenced to current position
                        sPosition[1] -= int(position[1])
                        if (sPosition[0] != 0): nPosition[0] += int(sPosition[0]/abs(sPosition[0])) # just the directon of the cell is extracted.
                        if (sPosition[1] != 0): nPosition[1] += int(sPosition[1]/abs(sPosition[1]))
                        return nPosition
                    
        # Not unexplored places arround, return the initial position.
        return position
    
    def getCellType(self, p):
        #print(p)
        return self.map[p[0]][p[1]]

    def countExplorableCells(self):
        count = 0
        sPosition = [0,0]
        for searchI in range(self.MAPWIDTH):
            for searchJ in range(self.MAPHEIGHT):
                sPosition[0] = searchI
                sPosition[1] = searchJ
                # Check if it is valid
                if(self.isValid(sPosition)):
                    # Check if RSCellType is unexplored or target
                    if(self.getCellType(sPosition) > 0):
                        count += 1
        return count
    
    # Check if Position is inside the map boundaries:
    def isValid(self, position):
        return (position[0] >= 0 and position[0] < self.MAPWIDTH 
                and position[1] >= 0 and position[1] < self.MAPHEIGHT
                and self.getCellType(position) != self.X)
    
    def check_map(self,map):
        print(map.map)
        return True

    def showMap(self):
        """CREATING MAP-SIZE"""
        self.TILESIZE = 25
        self.MAPWIDTH = 16
        self.MAPHEIGHT = 16

        """Create Display"""
        pygame.init()
        DISPLAY = pygame.display.set_mode((self.MAPWIDTH*self.TILESIZE,self.MAPHEIGHT*self.TILESIZE))

        """Basic User Interface"""
        while True:
            for event in pygame.event.get():
                
                """Quit (when "x" in top-right corner is pressed)"""
                if event.type == pygame.QUIT:
                    pygame.quit()
                    #sys.exit()

            """Draw Map to Display"""
            #ROWS
            for row in range(self.MAPHEIGHT):
                #COLUMNS
                for col in range(self.MAPWIDTH):
                    #DRAW TILE
                    """pygame.draw.rect(screen, [red, blue, green], [left, top, width, height], filled)"""
                    pygame.draw.rect(DISPLAY,self.TileColour[self.map[row][col]],(col*self.TILESIZE,row*self.TILESIZE,self.TILESIZE,self.TILESIZE))
                    #DISPLAY.blit(self.TileColour[self.mapA[row][col]],(col*self.TILESIZE,row*self.TILESIZE))
                    
            """Update Display"""
            pygame.display.update()