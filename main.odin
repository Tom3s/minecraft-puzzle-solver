package main

import "core:fmt"

ITEM_TYPE :: enum {
	IRON_SWORD,
	IRON_PICKAXE,
	IRON_CHESTPLATE,
	GOLD_SWORD,
	GOLD_PICKAXE,
	GOLD_CHESTPLATE,
	DIAMOND_SWORD,
	DIAMOND_PICKAXE,
	DIAMOND_CHESTPLATE,
}

CLUE_TYPE :: enum {
	IRON_SWORD,
	IRON_PICKAXE,
	IRON_CHESTPLATE,
	GOLD_SWORD,
	GOLD_PICKAXE,
	GOLD_CHESTPLATE,
	DIAMOND_SWORD,
	DIAMOND_PICKAXE,
	DIAMOND_CHESTPLATE,
	
	EMPTY,
	NONE,

	IRON,
	GOLD,
	DIAMOND,

	SWORD,
	PICKAXE,
	CHESTPLATE,
}

Cell_State :: struct {
	available: [ITEM_TYPE]bool,
}

Clue :: struct {
	item: [3][3]CLUE_TYPE,
	size: [2]int,
	satisfied: bool,
}

Negative_Clue :: struct {
	item: [3][3]CLUE_TYPE,
	size: [2]int,
}

Board_State :: struct {
	cells: [3][3]Cell_State,

	clues: [dynamic]Clue,
	negative_clues: [dynamic]Negative_Clue,
}

init_cell_state :: proc(cell: ^Cell_State) {
	for i in 0..<9 {
		cell.available[cast(ITEM_TYPE) i] = true;
	}
}

init_board_state :: proc(board: ^Board_State) {
	for i in 0..<3 {
		for j in 0..<3 {
			init_cell_state(&board.cells[j][i]);
		}
	}

	board.clues = make([dynamic]Clue);
	board.negative_clues = make([dynamic]Negative_Clue);
}

destroy_board_state :: proc(board: ^Board_State) {
	delete(board.clues);
	delete(board.negative_clues);
}

apply_clue :: proc(cells: ^[3][3]Cell_State, clue: Clue) {
	for i in 0..<3 {
		for j in 0..<3 {
			// init_cell_state(&board.cells[j][i]);
			current_clue := clue.item[j][i];
			#partial switch current_clue {
				case .IRON_SWORD ..= .DIAMOND_CHESTPLATE: 
					cells[j][i] = {};
					cells[j][i].available[cast(ITEM_TYPE) current_clue] = true;
				
				case .SWORD:
					cells[j][i].available[.IRON_CHESTPLATE] = false;
					cells[j][i].available[.IRON_PICKAXE] = false;
					cells[j][i].available[.GOLD_CHESTPLATE] = false;
					cells[j][i].available[.GOLD_PICKAXE] = false;
					cells[j][i].available[.DIAMOND_CHESTPLATE] = false;
					cells[j][i].available[.DIAMOND_PICKAXE] = false;
				
				case .PICKAXE:
					cells[j][i].available[.IRON_CHESTPLATE] = false;
					cells[j][i].available[.IRON_SWORD] = false;
					cells[j][i].available[.GOLD_CHESTPLATE] = false;
					cells[j][i].available[.GOLD_SWORD] = false;
					cells[j][i].available[.DIAMOND_CHESTPLATE] = false;
					cells[j][i].available[.DIAMOND_SWORD] = false;
				
				case .CHESTPLATE:
					cells[j][i].available[.IRON_PICKAXE] = false;
					cells[j][i].available[.IRON_SWORD] = false;
					cells[j][i].available[.GOLD_PICKAXE] = false;
					cells[j][i].available[.GOLD_SWORD] = false;
					cells[j][i].available[.DIAMOND_PICKAXE] = false;
					cells[j][i].available[.DIAMOND_SWORD] = false;

				case .IRON:
					cells[j][i].available[.GOLD_SWORD] = false;
					cells[j][i].available[.GOLD_PICKAXE] = false;
					cells[j][i].available[.GOLD_CHESTPLATE] = false;
					cells[j][i].available[.DIAMOND_SWORD] = false;
					cells[j][i].available[.DIAMOND_PICKAXE] = false;
					cells[j][i].available[.DIAMOND_CHESTPLATE] = false;
				
				case .GOLD:
					cells[j][i].available[.IRON_SWORD] = false;
					cells[j][i].available[.IRON_PICKAXE] = false;
					cells[j][i].available[.IRON_CHESTPLATE] = false;
					cells[j][i].available[.DIAMOND_SWORD] = false;
					cells[j][i].available[.DIAMOND_PICKAXE] = false;
					cells[j][i].available[.DIAMOND_CHESTPLATE] = false;
				
				case .DIAMOND:
					cells[j][i].available[.IRON_SWORD] = false;
					cells[j][i].available[.IRON_PICKAXE] = false;
					cells[j][i].available[.IRON_CHESTPLATE] = false;
					cells[j][i].available[.GOLD_SWORD] = false;
					cells[j][i].available[.GOLD_PICKAXE] = false;
					cells[j][i].available[.GOLD_CHESTPLATE] = false;
					
			}

			check_final_item(cells, {i, j});
		}
	}
}

check_final_item :: proc(cells: ^[3][3]Cell_State, index: [2]int) {
	// check if only one item left
	possible_items: int;
	remaining_type: ITEM_TYPE;
	for type in ITEM_TYPE {
		if cells[index.y][index.x].available[type] {
			possible_items += 1;
			remaining_type = type;
		}
	}

	// disable that everywhere else
	if possible_items == 1 {
		fmt.println("Final item on cell ", index, remaining_type);
		for ii in 0..<3 {
			for jj in 0..<3 {
				if ii == index.x && jj == index.y do continue;
				
				old_state := cells[jj][ii].available[remaining_type];

				cells[jj][ii].available[remaining_type] = false;
				if old_state do check_final_item(cells, {ii, jj});
			}
		}
	}
}

print_solution :: proc(board: Board_State) {
	for i in 0..<3 {
		for j in 0..<3 {
			for type, type_name in board.cells[i][j].available {
				if type {
					fmt.print(type_name, " ");
				}
			}
		}
		fmt.println();
	}
}

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

	apply_clue(&board.cells, board.clues[0]);

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

	for clue in board.clues{
		apply_clue(&board.cells, clue);
	}

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

	for clue in board.clues{
		apply_clue(&board.cells, clue);
	}

	// fmt.printfln("%#v", board.cells);
	print_solution(board);
}

main :: proc() {
	problem3()
}