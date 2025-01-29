package main

import "core:fmt"
import "core:slice"

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

compare_clues :: proc(a, b: Clue) -> slice.Ordering{
	max_a := max(a.size.x, a.size.y);
	max_b := max(b.size.x, b.size.y);

	switch delta := max_a - max_b; {
		case delta < 0: return slice.Ordering.Greater
		case delta > 0: return slice.Ordering.Less
	}

	min_a := min(a.size.x, a.size.y);
	min_b := min(b.size.x, b.size.y);

	switch delta := min_a - min_b; {
		case delta < 0: return slice.Ordering.Greater
		case delta > 0: return slice.Ordering.Less
	}

	return slice.Ordering.Equal;

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

apply_fixed_clue :: proc(cells: ^[3][3]Cell_State, clue: Clue) {
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

apply_offset_clue :: proc(cells: ^[3][3]Cell_State, clue: Clue) {
	// board.clues = make([dynamic]Clue);
	offsets := make([dynamic][2]int);
	defer delete(offsets);

	for x in 0..<3 - clue.size.x + 1 {
		for y in 0..<3 - clue.size.y + 1 {
			append(&offsets, [2]int{x, y});
		}
	}

	satisfiable := make([]bool, len(offsets));
	for &a in satisfiable {
		a = true;
	}
	// satisfiable = !satisfiable;

	// fmt.printfln("%#v", clue);



	for offset, index in offsets {
		for i in 0..<clue.size.x {
			for j in 0..<clue.size.y{
				current_clue := clue.item[j][i];
				current_cell := cells[j + offset.y][i + offset.x];


				#partial switch current_clue {
					case .EMPTY: fallthrough
					case .NONE: ;

					case .IRON_SWORD ..= .DIAMOND_CHESTPLATE: 					
						satisfiable[index] &&= current_cell.available[cast(ITEM_TYPE) current_clue];

					case .SWORD:
						satisfiable[index] &&= current_cell.available[.IRON_SWORD] || \
											 current_cell.available[.GOLD_SWORD] || \
											 current_cell.available[.DIAMOND_SWORD]
 
					case .PICKAXE:
						satisfiable[index] &&= current_cell.available[.IRON_PICKAXE] || \
											 current_cell.available[.GOLD_PICKAXE] || \
											 current_cell.available[.DIAMOND_PICKAXE]
					case .CHESTPLATE:
						satisfiable[index] &&= current_cell.available[.IRON_CHESTPLATE] || \
											 current_cell.available[.GOLD_CHESTPLATE] || \
											 current_cell.available[.DIAMOND_CHESTPLATE]
					
					case .IRON:
						satisfiable[index] &&= current_cell.available[.IRON_SWORD] || \
											 current_cell.available[.IRON_PICKAXE] || \
											 current_cell.available[.IRON_CHESTPLATE]
					
					case .GOLD:
						satisfiable[index] &&= current_cell.available[.GOLD_SWORD] || \
											 current_cell.available[.GOLD_PICKAXE] || \
											 current_cell.available[.GOLD_CHESTPLATE]
					
					case .DIAMOND:
						satisfiable[index] &&= current_cell.available[.DIAMOND_SWORD] || \
											 current_cell.available[.DIAMOND_PICKAXE] || \
											 current_cell.available[.DIAMOND_CHESTPLATE]
					


				}
			}
		}
	}

	satisfy_count := 0;
	correct_offset := [2]int{-1, -1};
	for satisfication, index in satisfiable {
		if satisfication {
			satisfy_count += 1;
			correct_offset = offsets[index] ;
		} else {
			fmt.println("Unsatisfiable clue: ")
			fmt.println(offsets, satisfiable);
			fmt.printfln("%#v", clue);

		}
	}

	if satisfy_count == 1 {
		// fmt.printfln("%#v", clue);
		// fmt.println(correct_offset);


		fixed_clue := Clue{
			item = {
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
				{.NONE, .NONE, .NONE},
			},
			size = {3, 3},
		}

		for i, ii in correct_offset.x..<3 {
			for j, jj in correct_offset.y..<3 {
				fixed_clue.item[j][i] = clue.item[jj][ii];
			}
		}

		// fmt.printfln("%#v", fixed_clue);
		apply_fixed_clue(cells, fixed_clue);
	} else {
		// fmt.printfln("%#v", clue);
		// fmt.println(offsets, satisfiable);
	}
	
	// fmt.println(offsets, satisfiable);


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

sort_clues :: proc(board: ^Board_State) {
	slice.sort_by_cmp(board.clues[:], compare_clues);


}

solve_board :: proc(board: ^Board_State) {
	sort_clues(board);

	for i in 0..<100{
		if is_solved(board^) do break;

		index := 0;
		for clue in board.clues{
			if clue.size.x == 3 && clue.size.y == 3 {
				apply_fixed_clue(&board.cells, clue);
				index += 1;
			}
		}
		
		remove_range(&board.clues, 0, index);
		
		index = 0;
		for clue in board.clues{
			apply_offset_clue(&board.cells, clue);
			index += 1;
		}
	}
}

is_solved :: proc(board: Board_State) -> bool{
	for row in board.cells {
		for cell in row {
			count := 0;
			for state in cell.available {
				if state do count += 1;
			}

			if count != 1 do return false;
		}
	}

	return true;
}

print_solution :: proc(board: Board_State) {
	for i in 0..<3 {
		for j in 0..<3 {
			fmt.print("[ ");
			for type, type_name in board.cells[i][j].available {
				if type {
					fmt.print(type_name, " ");
				}
			}
			fmt.print("] ");
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

	apply_fixed_clue(&board.cells, board.clues[0]);

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
		apply_fixed_clue(&board.cells, clue);
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
		apply_fixed_clue(&board.cells, clue);
	}

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

	sort_clues(&board);


	index := 0;
	for clue in board.clues{
		if clue.size.x == 3 && clue.size.y == 3 {
			apply_fixed_clue(&board.cells, clue);
			index += 1;
		}
	}

	remove_range(&board.clues, 0, index);

	index = 0;
	for clue in board.clues{
		apply_offset_clue(&board.cells, clue);
		index += 1;
	}

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

// odin run .
main :: proc() {
	problem20();
}