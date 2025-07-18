-- Tic Tac Toe Database Schema (MySQL)

-- USERS TABLE: Stores registered user credentials and profile info
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(32) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- GAMES TABLE: Stores info about ongoing or completed games
CREATE TABLE IF NOT EXISTS games (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_x_id INT NOT NULL,
    player_o_id INT,
    status ENUM('waiting', 'in_progress', 'x_won', 'o_won', 'draw', 'abandoned') NOT NULL DEFAULT 'waiting',
    current_turn ENUM('X', 'O') DEFAULT 'X',
    start_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    end_time DATETIME DEFAULT NULL,
    winner_id INT DEFAULT NULL,
    game_mode ENUM('vs_player', 'vs_computer') DEFAULT 'vs_player',
    FOREIGN KEY (player_x_id) REFERENCES users(id),
    FOREIGN KEY (player_o_id) REFERENCES users(id),
    FOREIGN KEY (winner_id) REFERENCES users(id)
);

-- MOVES TABLE: Stores every move made in a game for move-by-move replay/history
CREATE TABLE IF NOT EXISTS moves (
    id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT NOT NULL,
    move_number INT NOT NULL,
    player_id INT NOT NULL,
    row TINYINT NOT NULL,      -- Row: 0, 1, or 2 for 3x3 grid
    col TINYINT NOT NULL,      -- Col: 0, 1, or 2 for 3x3 grid
    symbol ENUM('X', 'O') NOT NULL,
    moved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES users(id)
);

-- MATCH HISTORY TABLE: Stores summary result for finished games
CREATE TABLE IF NOT EXISTS match_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT NOT NULL,
    player_x_id INT NOT NULL,
    player_o_id INT,
    winner_id INT,
    result ENUM('x_won', 'o_won', 'draw', 'abandoned') NOT NULL,
    finished_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
    FOREIGN KEY (player_x_id) REFERENCES users(id),
    FOREIGN KEY (player_o_id) REFERENCES users(id),
    FOREIGN KEY (winner_id) REFERENCES users(id)
);

-- Indexes to speed up queries on user and game lookups
CREATE INDEX IF NOT EXISTS idx_games_player_x_id ON games(player_x_id);
CREATE INDEX IF NOT EXISTS idx_games_player_o_id ON games(player_o_id);
CREATE INDEX IF NOT EXISTS idx_moves_game_id ON moves(game_id);
CREATE INDEX IF NOT EXISTS idx_moves_player_id ON moves(player_id);
CREATE INDEX IF NOT EXISTS idx_match_history_player_x_id ON match_history(player_x_id);
CREATE INDEX IF NOT EXISTS idx_match_history_player_o_id ON match_history(player_o_id);
CREATE INDEX IF NOT EXISTS idx_match_history_winner_id ON match_history(winner_id);
