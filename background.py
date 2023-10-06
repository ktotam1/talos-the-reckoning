import pygame
import random

def gen_building(min_width, max_width, min_height, max_height):
    #choose height and width of building
    width = random.randint(min_width, max_width)
    height = random.randint(min_height, max_height)
    #choose color of building from list of presets
    #primary building colors (greys, light blues)
    primary_colors = [(10, 10, 20), (20, 20, 30), (30, 30, 40), (40, 40, 50), (50, 50, 60), (60, 60, 70), (70, 70, 80), (80, 80, 90), (90, 90, 100), (100, 100, 110), (110, 110, 120), (120, 120, 130), (130, 130, 140)]
    #colors for windows (greens, darker blues)
    secondary_colors = [(10,50,10), (20,60,50), (100,150,40), (100,100,150),(10,50,100)]
    #choose color for building
    building_color = random.choice(primary_colors)
    #choose color for windows
    window_color = random.choice(secondary_colors)
    #create building surface
    building = pygame.Surface((width, height))
    #fill building with color
    building.fill(building_color)
    #draw windows onto building surface
    #choose number of windows
    num_windows = random.randint(6, 10)
    #choose window size
    window_size = random.randint(building.get_width() // num_windows - 6, building.get_width() // num_windows - 2)
    #choose window spacing
    #calulate maximum window spacing 
    max_window_spacing = (building.get_width() - num_windows * window_size) // (num_windows - 1)
    window_spacing = random.randint(max_window_spacing*3//4, max_window_spacing)
    #calculate window margin to center windows
    window_height = random.randint(5, 20)
    window_margin = (width - (num_windows * window_size + (num_windows - 1) * window_spacing)) / 2

    
    #draw windows
    for i in range(num_windows):
        #choose window x coordinate
        window_x = window_margin + i * (window_size + window_spacing)
        #choose window y coordinate
        
        #draw window
        pygame.draw.rect(building, window_color, (window_x, window_height, window_size, building.get_height()))
    #return building surface
    return building

def need_building(buildings, left_x, spacings, screen_width):
    #check if building is needed
    #check if last building is on screen
    #sum width of all buildings, spacing
    sum = 0
    for index, building in enumerate(buildings):
        sum += building.get_width() + spacings[index]
    if sum + left_x <= screen_width:
        return True
    return False

def main():
    screen_width = 1280
    screen_height = 720
    running = True
    clock = pygame.time.Clock()
    pygame.init()

    screen = pygame.display.set_mode((screen_width, screen_height))
    pygame.display.set_caption("Background Generator")
    left_x = screen_width
    spacing = 50
    #update screen
    pygame.display.flip()
    buildings = []
    right_spacings = []
    buildings.append(gen_building(50, 100, 200, 400))
    right_spacings.append(random.randint(0, 50))
    while running:
        screen.fill("white")
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running= False
        clock.tick(60)
        if need_building(buildings, left_x, right_spacings, screen_width):
            buildings.append(gen_building(50, 100, 200, 400))
            right_spacings.append(random.randint(0, 50))

        if left_x + buildings[0].get_width() < 0:
            buildings.pop(0)
            left_x = right_spacings.pop(0)
        left_x -= 1
        widths = 0
        spacing = 0
        for index, building in enumerate(buildings):
            # pygame.draw.rect(screen, "white", (left_x + index * spacing + widths, screen_height - building.get_height(), building.get_width(), building.get_height()))
            screen.blit(building, (left_x + spacing + widths, screen_height - building.get_height()))
            widths += building.get_width()
            spacing += right_spacings[index]
        pygame.display.flip()
        clock.tick(120)

    pygame.quit()
    quit()



if __name__ == "__main__":
    main()