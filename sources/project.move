module MyModule::TicTacToe {
    use aptos_framework::signer;
    use std::vector;

    struct Game has key {
        board: vector<u8>,
        current_player: u8,
        is_finished: bool,
    }

    public fun create_game(owner: &signer) {
        let game = Game {
            board: vector[0, 0, 0, 0, 0, 0, 0, 0, 0],
            current_player: 1,
            is_finished: false,
        };
        move_to(owner, game);
    }

    public fun make_move(player: &signer, index: u64) acquires Game {
        let game = borrow_global_mut<Game>(signer::address_of(player));
        assert!(!game.is_finished, 0);
        assert!(game.board[index] == 0, 1);
        game.board[index] = game.current_player;
        check_win_condition(game);
        game.current_player = 3 - game.current_player;
    }

    fun check_win_condition(game: &mut Game) {
        let i = 0;
        while (i < 9) {
            if (game.board[i] > 0
                && ((game.board[i] == game.board[i + 1] && game.board[i + 1] == game.board[i + 2])
                    || (game.board[i] == game.board[i + 3] && game.board[i + 3] == game.board[i + 6])
                    || (game.board[i] == game.board[i + 4] && game.board[i + 4] == game.board[i + 8])
                    || (i == 0 && game.board[i] == game.board[i + 2] && game.board[i + 2] == game.board[i + 4]))) {
                game.is_finished = true;
                return;
            };
            i = i + 1;
        };
    }
}