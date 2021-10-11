import pygame, sys
import numpy as np
import subprocess
import time
import json

WIDTH = 600
HEIGHT = 600+100
LINE_WIDTH = 15
WIN_LINE_WIDTH = 15
BOARD_ROWS = 3
BOARD_COLS = 3
SQUARE_SIZE = 200
CIRCLE_RADIUS = 60
CIRCLE_WIDTH = 15
CROSS_WIDTH = 25
SPACE = 55

RED = (255, 0, 0)
BG_COLOR = (20, 200, 160)
LINE_COLOR = (23, 145, 135)
CIRCLE_COLOR = (239, 231, 200)
CROSS_COLOR = (66, 66, 66)

PLAYER_LOOKUP = {
	1 : 'ai',
	2 : 'user'
}

CONTRACT_ADDRESS = '0x4e136383b01c19f1ba82a2bda668bf5b3a24f71ff9dab4ff1b129f3c74ceb20'
CONTRACT_VIEW_BOARD = f"starknet call --network=alpha --address {CONTRACT_ADDRESS} --abi tic_contract_abi.json --function view_board".split(" ")
CONTRACT_USER_MOVE = f"starknet invoke --network=alpha --address {CONTRACT_ADDRESS} --abi tic_contract_abi.json --function user_move --inputs".split(" ")
CONTRACT_RESET_BOARD = f"starknet invoke --network=alpha --address {CONTRACT_ADDRESS} --abi tic_contract_abi.json --function reset_board".split(" ")
STARKNET_TX_STATUS = f"starknet tx_status --network=alpha --id="

def draw_lines():
	pygame.draw.line( screen, LINE_COLOR, (0, SQUARE_SIZE), (WIDTH, SQUARE_SIZE), LINE_WIDTH )
	pygame.draw.line( screen, LINE_COLOR, (0, 2 * SQUARE_SIZE), (WIDTH, 2 * SQUARE_SIZE), LINE_WIDTH )
	pygame.draw.line( screen, LINE_COLOR, (SQUARE_SIZE, 0), (SQUARE_SIZE, HEIGHT), LINE_WIDTH )
	pygame.draw.line( screen, LINE_COLOR, (2 * SQUARE_SIZE, 0), (2 * SQUARE_SIZE, HEIGHT), LINE_WIDTH )

def draw_figures():
	for row in range(BOARD_ROWS):
		for col in range(BOARD_COLS):
			if board[row][col] == 1:
				pygame.draw.circle( screen, CIRCLE_COLOR, (int( col * SQUARE_SIZE + SQUARE_SIZE//2 ), int( row * SQUARE_SIZE + SQUARE_SIZE//2 )), CIRCLE_RADIUS, CIRCLE_WIDTH )
			elif board[row][col] == 2:
				pygame.draw.line( screen, CROSS_COLOR, (col * SQUARE_SIZE + SPACE, row * SQUARE_SIZE + SQUARE_SIZE - SPACE), (col * SQUARE_SIZE + SQUARE_SIZE - SPACE, row * SQUARE_SIZE + SPACE), CROSS_WIDTH )
				pygame.draw.line( screen, CROSS_COLOR, (col * SQUARE_SIZE + SPACE, row * SQUARE_SIZE + SPACE), (col * SQUARE_SIZE + SQUARE_SIZE - SPACE, row * SQUARE_SIZE + SQUARE_SIZE - SPACE), CROSS_WIDTH )

def mark_square(row, col, player):
	board[row][col] = player

def available_square(row, col):
	return board[row][col] == 0

def is_board_full():
	for row in range(BOARD_ROWS):
		for col in range(BOARD_COLS):
			if board[row][col] == 0:
				return False

	return True

def check_win(player):
	for col in range(BOARD_COLS):
		if board[0][col] == player and board[1][col] == player and board[2][col] == player:
			draw_vertical_winning_line(col, player)
			return True

	for row in range(BOARD_ROWS):
		if board[row][0] == player and board[row][1] == player and board[row][2] == player:
			draw_horizontal_winning_line(row, player)
			return True

	if board[2][0] == player and board[1][1] == player and board[0][2] == player:
		draw_asc_diagonal(player)
		return True

	if board[0][0] == player and board[1][1] == player and board[2][2] == player:
		draw_desc_diagonal(player)
		return True

	return False

def draw_vertical_winning_line(col, player):
	posX = col * SQUARE_SIZE + SQUARE_SIZE//2

	if player == 1:
		color = CIRCLE_COLOR
	elif player == 2:
		color = CROSS_COLOR

	pygame.draw.line( screen, color, (posX, 15), (posX, HEIGHT - 15), LINE_WIDTH )

def draw_horizontal_winning_line(row, player):
	posY = row * SQUARE_SIZE + SQUARE_SIZE//2

	if player == 1:
		color = CIRCLE_COLOR
	elif player == 2:
		color = CROSS_COLOR

	pygame.draw.line( screen, color, (15, posY), (WIDTH - 15, posY), WIN_LINE_WIDTH )

def draw_asc_diagonal(player):
	if player == 1:
		color = CIRCLE_COLOR
	elif player == 2:
		color = CROSS_COLOR

	pygame.draw.line( screen, color, (15, HEIGHT - 15), (WIDTH - 15, 15), WIN_LINE_WIDTH )

def draw_desc_diagonal(player):
	if player == 1:
		color = CIRCLE_COLOR
	elif player == 2:
		color = CROSS_COLOR

	pygame.draw.line( screen, color, (15, 15), (WIDTH - 15, HEIGHT - 15), WIN_LINE_WIDTH )

def restart():
	screen.fill( BG_COLOR )
	draw_lines()
	for row in range(BOARD_ROWS):
		for col in range(BOARD_COLS):
			board[row][col] = 0

# text box initialization
def update_message (message):
	font = pygame.font.Font(None, 24)
	text = font.render(message, 1, (255, 255, 255))
	text_rect = text.get_rect(center =(WIDTH / 2, HEIGHT-50))
	screen.fill ((0, 0, 0), (0, WIDTH, HEIGHT, 100))
	screen.blit(text, text_rect)
	pygame.display.update()

def command_check_tx_status(tx_id):
	command = STARKNET_TX_STATUS+tx_id
	return command.split(' ')

def subprocess_run (cmd):
	result = subprocess.run(cmd, stdout=subprocess.PIPE)
	result = result.stdout.decode('utf-8')[:-1] # remove trailing newline
	return result

# game param initialization
board = np.zeros( (BOARD_ROWS, BOARD_COLS) )
player = 2
game_over = False

# screen initialization
pygame.init()
screen = pygame.display.set_mode( (WIDTH, HEIGHT) )
pygame.display.set_caption( 'TIC TAC TOE' )
screen.fill( BG_COLOR )
draw_lines()

# reset game board on StarkNet
result = subprocess_run(CONTRACT_RESET_BOARD)
update_message("Resetting the board on StarkNet...")
print(result)
reset_tx_id = result.split(' ')[-1]
while(True): # checking tx status every 10 seconds
	cmd = command_check_tx_status(reset_tx_id)
	result = subprocess_run(cmd)
	result_json = json.loads(result)
	tx_status = result_json['tx_status']

	time.sleep(10)
	if (tx_status == 'ACCEPTED_ONCHAIN'):
		update_message(f"Reset successful. It's {PLAYER_LOOKUP[player]}'s turn.")
		print(tx_status)
		break
	else:
		print(tx_status)

# view_board() and update board visuals
result = subprocess_run(CONTRACT_VIEW_BOARD)
print(result)
result = result.split(' ')
for row in range(BOARD_ROWS):
	for col in range(BOARD_COLS):
		board[row][col] = result[row*3+col]
draw_figures()
pygame.display.update()

# game loop
while True:
	for event in pygame.event.get():
		if event.type == pygame.QUIT:
			sys.exit()

		if event.type == pygame.MOUSEBUTTONDOWN and not game_over:

			mouseX = event.pos[0]
			mouseY = event.pos[1]

			clicked_row = int(mouseY // SQUARE_SIZE)
			clicked_col = int(mouseX // SQUARE_SIZE)

			if available_square( clicked_row, clicked_col ):

				mark_square( clicked_row, clicked_col, player )
				if check_win( player ):
					game_over = True
				#player = player % 2 + 1

				draw_figures()
				pygame.display.update()

				### starknet contract interaction
				# user_move()
				result = subprocess_run(CONTRACT_USER_MOVE+[f'{clicked_row}',f'{clicked_col}'])
				user_move_tx_id = result.split(' ')[-1]
				print(result)
				print(user_move_tx_id)

				# wait for confirmation of user_move accepted onchain
				update_message("Waiting for AI's countermove from StarkNet...")
				while(True): # checking tx status every 10 seconds
					cmd = command_check_tx_status(user_move_tx_id)
					result = subprocess_run(cmd)
					result_json = json.loads(result)
					tx_status = result_json['tx_status']

					if (tx_status == 'ACCEPTED_ONCHAIN'):
						update_message("AI has moved. It is your turn now.")
						print(tx_status)
						break
					elif (tx_status == 'REJECTED'):
						update_message("Your invalid move irritated the AI.")
						print(tx_status)
						break
					time.sleep(10)

				# view_board()
				result = subprocess_run(CONTRACT_VIEW_BOARD)
				print(result)
				update_message(result)

				# update board visuals
				result = result.split(' ')
				for row in range(BOARD_ROWS):
					for col in range(BOARD_COLS):
						board[row][col] = result[row*3+col]
				draw_figures()
				pygame.display.update()

		if event.type == pygame.KEYDOWN:
			if event.key == pygame.K_r:
				restart()
				player = 1
				game_over = False
				pygame.display.update()

