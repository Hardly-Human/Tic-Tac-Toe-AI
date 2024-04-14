import os
import json
import re
import random
import anthropic
from openai import OpenAI

# Initialize API clients
client_claude = anthropic.Client(api_key=os.environ.get("ANTHROPIC_API_KEY"))
client_openai = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))


def claude3_move(board):
    message = json.dumps({"board": board, "current_player": "Claude3AI"})
    response = client_claude.messages.create(
        model="claude-2.1",
        max_tokens=50,
        system="Respond only with coordiantes of your next position in [row,col] format, Example: [0,0]",
        messages=[{"role": "user", "content": message}],
    )
    response_dict = response.to_dict()
    response_content = response_dict.get("content", [])[0].get("text", "")

    coordinates_match = re.search(r"\[([\d]+),\s*([\d]+)\]", response_content)
    if coordinates_match:
        row = int(coordinates_match.group(1))
        col = int(coordinates_match.group(2))
        return row, col
    else:
        return None


def openai_move(board):
    message = json.dumps({"board": board, "current_player": "OpenAI"})
    chat_completion = client_openai.chat.completions.create(
        messages=[
            {
                "role": "user",
                "content": "Respond only with coordiantes of your next position in [row,col] format, Example: [0,0]",
            },
            {"role": "user", "content": message},
        ],
        model="gpt-3.5-turbo",
    )
    chat_completion_dict = chat_completion.to_dict()
    chat_response = (
        chat_completion_dict.get("choices", [])[0].get("message", {}).get("content", "")
    )
    coordinates_match = re.search(r"\[([\d]+),\s*([\d]+)\]", chat_response)
    if coordinates_match:
        row = int(coordinates_match.group(2))
        col = int(coordinates_match.group(1))
        return row, col
    else:
        return None


def print_board(board):
    for row in board:
        print(" | ".join(row))
        print("-" * 10)


def check_winner(board):
    # Check rows
    for row in board:
        if row[0] == row[1] == row[2] and row[0] != " ":
            return row[0]
    # Check columns
    for col in range(3):
        if board[0][col] == board[1][col] == board[2][col] and board[0][col] != " ":
            return board[0][col]
    # Check diagonals
    if board[0][0] == board[1][1] == board[2][2] and board[0][0] != " ":
        return board[0][0]
    if board[0][2] == board[1][1] == board[2][0] and board[0][2] != " ":
        return board[0][2]
    return None


def is_board_full(board):
    for row in board:
        for cell in row:
            if cell == " ":
                return False
    return True


def main():
    # Initialize game board
    board = [[" " for _ in range(3)] for _ in range(3)]
    players = ["Claude3AI", "OpenAI"]
    # players = ["OpenAI"]
    current_player = random.choice(players)
    winner = None

    while not winner:
        print_board(board)
        if current_player == "Claude3AI":
            move = claude3_move(board)
        else:
            move = openai_move(board)

        print(f"{current_player}: {move}")

        if isinstance(move, tuple):  # Check if move is tuple (i, j)
            row, col = move
        else:  # If not, assume move is string and parse it
            row, col = map(int, move.split())

        # Update board with move
        board[row][col] = "X" if current_player == "Claude3AI" else "O"

        # Check for winner
        winner = check_winner(board)
        if winner:
            print_board(board)
            print(f"{current_player} wins!")
            break

        # Check for tie
        if is_board_full(board):
            print_board(board)
            print("It's a tie!")
            break

        # Switch player
        current_player = "OpenAI" if current_player == "Claude3AI" else "Claude3AI"


if __name__ == "__main__":
    main()
