package main

problem1 :: proc() {
	board: Board_State;
	init_board_state(&board);
	defer destroy_board_state(&board);

	append(&board.clues, 
		Clue{
			item = {
				{.GOLD_CHESTPLATE, .DIAMOND_SWORD, .IRON_PICKAXE},
				{.IRON_SWORD, .GOLD_SWORD, .DIAMOND_CHESTPLATE},
				{.PICKAXE, .IRON, .DIAMOND},
			},
			size = {3, 3},
		}
	)

	// apply_fixed_clue(&board.cells, board.clues[0]);
	solve_board(&board);

	// fmt.printfln("%#v", board.cells);
	print_solution(board);
}

problem2 :: proc() {
	board: Board_State;
	init_board_state(&board);

	append(&board.clues, 
		Clue{
			item = {
				{.CHESTPLATE, .NONE, .NONE},
				{.CHESTPLATE, .NONE, .NONE},
				{.PICKAXE, .NONE, .NONE},
			},
			size = {3, 3},
		}
	)
	
	append(&board.clues, 
		Clue{
			item = {
				{.DIAMOND, .DIAMOND, .DIAMOND},
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 3},
		}
	)
	
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .NONE, .NONE},
				{.GOLD, .GOLD, .GOLD},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 3},
		}
	)
	
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .NONE, .SWORD},
				{.NONE, .NONE, .PICKAXE},
				{.NONE, .NONE, .CHESTPLATE},
			},
			size = {3, 3},
		}
	)

	solve_board(&board);

	// fmt.printfln("%#v", board.cells);
	print_solution(board);
}

problem3 :: proc() {
	board: Board_State;
	init_board_state(&board);

	// append(&board.clues, 
	// 	Clue{
	// 		item = {
	// 			{.NONE, .NONE, .NONE},
	// 			{.NONE, .NONE, .NONE},
	// 			{.NONE, .NONE, .NONE},
	// 		},
	// 		size = {3, 3},
	// 	}
	// )
	append(&board.clues, 
		Clue{
			item = {
				{.DIAMOND, .SWORD, .NONE},
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .DIAMOND, .CHESTPLATE},
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.PICKAXE, .NONE, .NONE},
				{.GOLD_SWORD, .NONE, .NONE},
				{.DIAMOND, .NONE, .NONE},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .NONE, .IRON},
				{.NONE, .NONE, .IRON_SWORD},
				{.NONE, .NONE, .CHESTPLATE},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
				{.CHESTPLATE, .IRON, .NONE},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
				{.NONE, .PICKAXE, .GOLD},
			},
			size = {3, 3},
		}
	)

	solve_board(&board);

	// fmt.printfln("%#v", board.cells);
	print_solution(board);
}

problem4 :: proc() {
	board: Board_State;
	init_board_state(&board);

	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .EMPTY, .NONE},
				{.DIAMOND_CHESTPLATE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)

	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .EMPTY, .EMPTY},
				{.NONE, .DIAMOND_SWORD, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 2},
		}
	)

	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .DIAMOND_PICKAXE, .NONE},
				{.NONE, .EMPTY, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)

	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .NONE, .NONE},
				{.EMPTY, .GOLD_CHESTPLATE, .NONE},
				{.EMPTY, .NONE, .NONE},
			},
			size = {2, 3},
		}
	)

	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .EMPTY, .NONE},
				{.EMPTY, .GOLD_SWORD, .EMPTY},
				{.NONE, .EMPTY, .NONE},
			},
			size = {3, 3},
		}
	)

	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .EMPTY, .NONE},
				{.GOLD_PICKAXE, .EMPTY, .NONE},
				{.NONE, .EMPTY, .NONE},
			},
			size = {2, 3},
		}
	)

	append(&board.clues, 
		Clue{
			item = {
				{.IRON_CHESTPLATE, .NONE, .NONE},
				{.EMPTY, .EMPTY, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)

	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .IRON_SWORD, .NONE},
				{.EMPTY, .EMPTY, .EMPTY},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 2},
		}
	)

	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .EMPTY, .NONE},
				{.EMPTY, .IRON_PICKAXE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)

	solve_board(&board);

	print_solution(board);
}

problem7 :: proc() {
	board: Board_State;
	init_board_state(&board);

	// append(&board.clues, 
	// 	Clue{
	// 		item = {
	// 			{.NONE, .NONE, .NONE},
	// 			{.NONE, .NONE, .NONE},
	// 			{.NONE, .NONE, .NONE},
	// 		},
	// 		size = {3, 3},
	// 	}
	// )
	append(&board.clues, 
		Clue{
			item = {
				{.DIAMOND, .NONE, .NONE},
				{.NONE, .DIAMOND, .NONE},
				{.NONE, .NONE, .DIAMOND},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .NONE, .PICKAXE},
				{.NONE, .PICKAXE, .NONE},
				{.PICKAXE, .NONE, .NONE},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.IRON, .NONE, .NONE},
				{.IRON, .IRON, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .SWORD, .NONE},
				{.SWORD, .SWORD, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.GOLD, .GOLD, .NONE},
				{.NONE, .GOLD, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.CHESTPLATE, .CHESTPLATE, .NONE},
				{.CHESTPLATE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 3},
		}
	)

	solve_board(&board);

	print_solution(board);
}

problem20 :: proc() {
	board: Board_State;
	init_board_state(&board);

	// append(&board.clues, 
	// 	Clue{
	// 		item = {
	// 			{.NONE, .NONE, .NONE},
	// 			{.NONE, .NONE, .NONE},
	// 			{.NONE, .NONE, .NONE},
	// 		},
	// 		size = {3, 3},
	// 	}
	// )
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .DIAMOND_PICKAXE, .NONE},
				{.EMPTY, .NONE, .NONE},
				{.NONE, .EMPTY, .NONE},
			},
			size = {2, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .EMPTY, .NONE},
				{.GOLD_PICKAXE, .NONE, .NONE},
				{.NONE, .EMPTY, .NONE},
			},
			size = {2, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .EMPTY, .NONE},
				{.EMPTY, .NONE, .NONE},
				{.NONE, .IRON_PICKAXE, .NONE},
			},
			size = {2, 3},
		}
	)

	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .EMPTY, .NONE},
				{.DIAMOND_CHESTPLATE, .NONE, .EMPTY},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .NONE, .GOLD_CHESTPLATE},
				{.NONE, .EMPTY, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .EMPTY, .NONE},
				{.EMPTY, .NONE, .IRON_CHESTPLATE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 2},
		}
	)

	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .NONE, .NONE},
				{.NONE, .EMPTY, .NONE},
				{.GOLD_SWORD, .NONE, .NONE},
			},
			size = {2, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .NONE, .NONE},
				{.NONE, .IRON, .NONE},
				{.NONE, .NONE, .EMPTY},
			},
			size = {3, 3},
		}
	)
	
	solve_board(&board);

	print_solution(board);
}
problem34_m :: proc() {
	board: Board_State;
	init_board_state(&board);

	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .CHESTPLATE, .SWORD},
				{.GOLD, .PICKAXE, .CHESTPLATE},
				{.PICKAXE, .IRON, .NONE},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.SWORD, .DIAMOND, .NONE},
				{.GOLD, .SWORD, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.IRON, .GOLD, .NONE},
				{.GOLD, .DIAMOND, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.GOLD, .DIAMOND, .NONE},
				{.DIAMOND, .IRON, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	
	solve_board(&board);

	print_solution(board);
}

problem34_m2 :: proc() {
	board: Board_State;
	init_board_state(&board);

	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .CHESTPLATE, .SWORD},
				{.NONE, .PICKAXE, .CHESTPLATE},
				{.EMPTY, .NONE, .NONE},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.GOLD, .PICKAXE, .NONE},
				{.PICKAXE, .IRON, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.SWORD, .DIAMOND, .NONE},
				{.GOLD, .SWORD, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.IRON, .GOLD, .NONE},
				{.GOLD, .DIAMOND, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.GOLD, .DIAMOND, .NONE},
				{.DIAMOND, .IRON, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	
	solve_board(&board);

	print_solution(board);
}

problem34 :: proc() {
	board: Board_State;
	init_board_state(&board);

	append(&board.clues, 
		Clue{
			item = {
				{.CHESTPLATE, .SWORD, .NONE},
				{.PICKAXE, .CHESTPLATE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.GOLD, .PICKAXE, .NONE},
				{.PICKAXE, .IRON, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.SWORD, .DIAMOND, .NONE},
				{.GOLD, .SWORD, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.IRON, .GOLD, .NONE},
				{.GOLD, .DIAMOND, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.GOLD, .DIAMOND, .NONE},
				{.DIAMOND, .IRON, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	
	board = solve_board(&board);

	print_solution(board);
}

problem36 :: proc() {
	board: Board_State;
	init_board_state(&board);

	append(&board.clues, 
		Clue{
			item = {
				{.IRON_CHESTPLATE, .NONE, .NONE},
				{.NONE, .CHESTPLATE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .GOLD, .NONE},
				{.CHESTPLATE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.DIAMOND, .NONE, .NONE},
				{.CHESTPLATE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {1, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.PICKAXE, .CHESTPLATE, .NONE},
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 1},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.CHESTPLATE, .DIAMOND_PICKAXE, .NONE},
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 1},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .SWORD, .NONE},
				{.SWORD, .CHESTPLATE, .NONE},
				{.NONE, .SWORD, .NONE},
			},
			size = {2, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .CHESTPLATE, .NONE},
				{.IRON, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.CHESTPLATE, .NONE, .NONE},
				{.NONE, .GOLD, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)

	solved_board := solve_board(&board);
	// solved_board := combine_clues(board.clues[:]);

	print_solution(solved_board);
}

problem19 :: proc() {
	board: Board_State;
	init_board_state(&board);

	append(&board.clues, 
		Clue{
			item = {
				{.SWORD, .SWORD, .NONE},
				{.PICKAXE, .CHESTPLATE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.CHESTPLATE, .SWORD, .NONE},
				{.PICKAXE, .CHESTPLATE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.GOLD, .GOLD, .NONE},
				{.IRON, .DIAMOND, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.GOLD, .DIAMOND, .NONE},
				{.GOLD, .IRON, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)


	solved_board := solve_board(&board);
	// solved_board := combine_clues(board.clues[:]);


	print_solution(solved_board);
}

problem19_m :: proc() {
	board: Board_State;
	init_board_state(&board);
	append(&board.clues, 
		Clue{
			item = {
				{.SWORD, .SWORD, .NONE},
				{.PICKAXE, .CHESTPLATE, .NONE},
				{.NONE, .NONE, .EMPTY},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .NONE, .NONE},
				{.NONE, .CHESTPLATE, .SWORD},
				{.NONE, .PICKAXE, .CHESTPLATE},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .NONE, .NONE},
				{.GOLD, .GOLD, .NONE},
				{.IRON, .DIAMOND, .EMPTY},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .GOLD, .DIAMOND},
				{.NONE, .GOLD, .IRON},
				{.NONE, .NONE, .EMPTY},
			},
			size = {3, 3},
		}
	)
	solved_board := solve_board(&board);
	print_solution(solved_board);
}

problem19_m2 :: proc() {
	board: Board_State;
	init_board_state(&board);
	append(&board.clues, 
		Clue{
			item = {
				{.SWORD, .SWORD, .NONE},
				{.PICKAXE, .CHESTPLATE, .SWORD},
				{.NONE, .PICKAXE, .CHESTPLATE},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.GOLD, .GOLD, .NONE},
				{.IRON, .DIAMOND, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.GOLD, .DIAMOND, .NONE},
				{.GOLD, .IRON, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	solved_board := solve_board(&board);
	print_solution(solved_board);
}

problem15 :: proc() {
	board: Board_State;
	init_board_state(&board);
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .SWORD, .NONE},
				{.NONE, .SWORD, .NONE},
				{.SWORD, .NONE, .NONE},
			},
			size = {2, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.IRON, .NONE, .NONE},
				{.IRON, .NONE, .NONE},
				{.NONE, .IRON, .NONE},
			},
			size = {2, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .DIAMOND, .DIAMOND},
				{.DIAMOND, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.PICKAXE, .PICKAXE, .NONE},
				{.NONE, .NONE, .PICKAXE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 2},
		}
	)
	solved_board := solve_board(&board);
	print_solution(solved_board);
}

problem17 :: proc() {
	board: Board_State;
	init_board_state(&board);
	append(&board.clues, 
		Clue{
			item = {
				{.GOLD, .GOLD, .NONE},
				{.NONE, .GOLD, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .NONE, .NONE},
				{.NONE, .CHESTPLATE, .NONE},
				{.NONE, .SWORD, .NONE},
			},
			size = {2, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.PICKAXE, .NONE, .NONE},
				{.PICKAXE, .NONE, .NONE},
				{.PICKAXE, .NONE, .NONE},
			},
			size = {1, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .EMPTY, .NONE},
				{.CHESTPLATE, .NONE, .NONE},
				{.IRON, .NONE, .NONE},
			},
			size = {2, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.IRON, .IRON, .NONE},
				{.IRON, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	solved_board := solve_board(&board);
	print_solution(solved_board);
}

problem17_m :: proc() {
	board: Board_State;
	init_board_state(&board);
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .GOLD, .GOLD},
				{.NONE, .NONE, .GOLD},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .NONE, .NONE},
				{.NONE, .CHESTPLATE, .NONE},
				{.NONE, .SWORD, .NONE},
			},
			size = {2, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.PICKAXE, .NONE, .NONE},
				{.PICKAXE, .NONE, .NONE},
				{.PICKAXE, .NONE, .NONE},
			},
			size = {1, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .EMPTY, .NONE},
				{.CHESTPLATE, .NONE, .NONE},
				{.IRON, .NONE, .NONE},
			},
			size = {2, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.IRON, .IRON, .NONE},
				{.IRON, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
		}
	)
	solved_board := solve_board(&board);
	print_solution(solved_board);
}

invalid_problem :: proc() {
	board: Board_State;
	init_board_state(&board);

	append(&board.clues, 
		Clue{
			item = {
				{.CHESTPLATE, .DIAMOND, .NONE},
				{.DIAMOND, .CHESTPLATE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.GOLD, .PICKAXE, .NONE},
				{.PICKAXE, .IRON, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 3},
		}
	)
	
	solve_board(&board);

	print_solution(board);
}

// negative clues

problem21 :: proc() {
	board: Board_State;
	init_board_state(&board);
	append(&board.clues, 
		Clue{
			item = {
				{.IRON_CHESTPLATE, .NONE, .EMPTY},
				{.EMPTY, .EMPTY, .EMPTY},
				{.NONE, .EMPTY, .NONE},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .NONE, .NONE},
				{.GOLD_SWORD, .EMPTY, .NONE},
				{.EMPTY, .EMPTY, .EMPTY},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.NONE, .DIAMOND_CHESTPLATE, .EMPTY},
				{.NONE, .EMPTY, .NONE},
				{.EMPTY, .EMPTY, .NONE},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .EMPTY, .GOLD_PICKAXE},
				{.EMPTY, .NONE, .EMPTY},
				{.EMPTY, .EMPTY, .EMPTY},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .NONE, .EMPTY},
				{.EMPTY, .NONE, .IRON_PICKAXE},
				{.EMPTY, .EMPTY, .EMPTY},
			},
			size = {3, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .EMPTY, .EMPTY},
				{.NONE, .IRON_SWORD, .NONE},
				{.EMPTY, .EMPTY, .EMPTY},
			},
			size = {3, 3},
		}
	)

	append(&board.negative_clues, 
		Negative_Clue{
			item = {
				{.EMPTY, .EMPTY, .EMPTY},
				{.EMPTY, .NONE, .EMPTY},
				{.GOLD, .NONE, .EMPTY},
			},
			size = {3, 3},
			item_count = 1,
		}
	)
	append(&board.negative_clues, 
		Negative_Clue{
			item = {
				{.EMPTY, .EMPTY, .EMPTY},
				{.EMPTY, .NONE, .EMPTY},
				{.EMPTY, .CHESTPLATE, .EMPTY},
			},
			size = {3, 3},
			item_count = 1,
		}
	)
	append(&board.negative_clues, 
		Negative_Clue{
			item = {
				{.EMPTY, .EMPTY, .EMPTY},
				{.NONE, .EMPTY, .NONE},
				{.NONE, .PICKAXE, .NONE},
			},
			size = {3, 3},
			item_count = 1,
		}
	)
	solved_board := solve_board(&board);
	print_solution(solved_board);
}


problem22 :: proc() {
	board: Board_State;
	init_board_state(&board);
	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .EMPTY, .NONE},
				{.EMPTY, .EMPTY, .NONE},
				{.GOLD_CHESTPLATE, .IRON_SWORD, .NONE},
			},
			size = {2, 3},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.DIAMOND_SWORD, .EMPTY, .EMPTY},
				{.IRON_PICKAXE, .EMPTY, .EMPTY},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.EMPTY, .EMPTY, .GOLD_SWORD},
				{.EMPTY, .EMPTY, .DIAMOND_PICKAXE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 2},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.GOLD_PICKAXE, .IRON_CHESTPLATE, .NONE},
				{.EMPTY, .EMPTY, .NONE},
				{.EMPTY, .EMPTY, .NONE},
			},
			size = {2, 3},
		}
	)

	append(&board.negative_clues, 
		Negative_Clue{
			item = {
				{.EMPTY, .EMPTY, .NONE},
				{.EMPTY, .EMPTY, .NONE},
				{.PICKAXE, .EMPTY, .NONE},
			},
			size = {2, 3},
			item_count = 1,
		}
	)
	solved_board := solve_board(&board);
	print_solution(solved_board);
}

problem23 :: proc() {
	board: Board_State;
	init_board_state(&board);

	append(&board.negative_clues, 
		Negative_Clue{
			item = {
				{.PICKAXE, .NONE, .EMPTY},
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 1},
			item_count = 1,
		}
	)
	append(&board.negative_clues, 
		Negative_Clue{
			item = {
				{.CHESTPLATE, .NONE, .EMPTY},
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 1},
			item_count = 1,
		}
	)
	append(&board.negative_clues, 
		Negative_Clue{
			item = {
				{.EMPTY, .NONE, .SWORD},
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 1},
			item_count = 1,
		}
	)
	append(&board.negative_clues, 
		Negative_Clue{
			item = {
				{.IRON, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
				{.EMPTY, .NONE, .NONE},
			},
			size = {1, 3},
			item_count = 1,
		}
	)
	append(&board.negative_clues, 
		Negative_Clue{
			item = {
				{.EMPTY, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
				{.GOLD, .NONE, .NONE},
			},
			size = {1, 3},
			item_count = 1,
		}
	)
	append(&board.negative_clues, 
		Negative_Clue{
			item = {
				{.DIAMOND, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
				{.EMPTY, .NONE, .NONE},
			},
			size = {1, 3},
			item_count = 1,
		}
	)
	append(&board.negative_clues, 
		Negative_Clue{
			item = {
				{.EMPTY, .NONE, .PICKAXE},
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 1},
			item_count = 1,
		}
	)
	append(&board.negative_clues, 
		Negative_Clue{
			item = {
				{.EMPTY, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
				{.DIAMOND, .NONE, .NONE},
			},
			size = {1, 3},
			item_count = 1,
		}
	)
	solved_board := solve_board(&board);
	print_solution(solved_board);
}

problem25 :: proc() {
	board: Board_State;
	init_board_state(&board);
	append(&board.clues, 
		Clue{
			item = {
				{.GOLD_PICKAXE, .EMPTY, .DIAMOND_CHESTPLATE},
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 1},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.IRON_PICKAXE, .EMPTY, .GOLD_CHESTPLATE},
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 1},
		}
	)
	append(&board.clues, 
		Clue{
			item = {
				{.DIAMOND_PICKAXE, .EMPTY, .IRON_CHESTPLATE},
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 1},
		}
	)

	append(&board.negative_clues, 
		Negative_Clue{
			item = {
				{.DIAMOND, .NONE, .NONE},
				{.NONE, .EMPTY, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
			item_count = 1,
		}
	)
	append(&board.negative_clues, 
		Negative_Clue{
			item = {
				{.EMPTY, .NONE, .NONE},
				{.NONE, .GOLD, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {2, 2},
			item_count = 1,
		}
	)
	solved_board := solve_board(&board);
	print_solution(solved_board);
}