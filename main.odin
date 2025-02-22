package main

import "core:fmt"
import "core:slice"

MAX_ITERATIONS :: 20;

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

	// NONE,
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

compare_negative_clues :: proc(a, b: Negative_Clue) -> slice.Ordering{
	switch delta := a.item_count - b.item_count; {
		case delta > 0: return slice.Ordering.Greater
		case delta < 0: return slice.Ordering.Less
	}

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
	item_count: int,
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

init_board_state :: proc(board: ^Board_State, reset_clues: bool = true) {
	for i in 0..<3 {
		for j in 0..<3 {
			init_cell_state(&board.cells[j][i]);
		}
	}

	if reset_clues {
		board.clues = make([dynamic]Clue);
		board.negative_clues = make([dynamic]Negative_Clue);
	}
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

			check_triplets(cells);
		}
	}
}

only_item_remaining :: proc(cell: Cell_State) -> ITEM_TYPE {
	count := 0;
	available_type: ITEM_TYPE = nil;
	for check_type in ITEM_TYPE {
		if cell.available[check_type] {
			count += 1;
			available_type = check_type;
			if count > 1 do return nil;
		}
	}

	if count == 1 do return available_type;
	return nil;
}

only_material_remaining :: proc(cell: Cell_State) -> CLUE_TYPE {
	iron := 0;
	gold := 0;
	diamond := 0;

	for type in ITEM_TYPE {
		if cell.available[type] {
			switch type {
				case .IRON_SWORD ..= .IRON_CHESTPLATE:
					iron += 1;
				case .GOLD_SWORD ..= .GOLD_CHESTPLATE:
					gold += 1;
				case .DIAMOND_SWORD ..= .DIAMOND_CHESTPLATE:
					diamond += 1;
			}
		}
	}

	if iron != 0 && gold + diamond == 0 {
		return .IRON;
	}

	if gold != 0 && iron + diamond == 0 {
		return .GOLD;
	}

	if diamond != 0 && iron + gold == 0 {
		return .DIAMOND;
	}

	return .NONE;

}

only_tool_remaining :: proc(cell: Cell_State) -> CLUE_TYPE {
	sword := 0;
	pickaxe := 0;
	chestplate := 0;

	for type in ITEM_TYPE {
		if cell.available[type] {
			switch type {
				case .IRON_SWORD: fallthrough
				case .GOLD_SWORD: fallthrough
				case .DIAMOND_SWORD: 
					sword += 1;

				case .IRON_PICKAXE: fallthrough
				case .GOLD_PICKAXE: fallthrough
				case .DIAMOND_PICKAXE: 
					pickaxe += 1;

				case .IRON_CHESTPLATE: fallthrough
				case .GOLD_CHESTPLATE: fallthrough
				case .DIAMOND_CHESTPLATE: 
					chestplate += 1;
			}
		}
	}

	if sword != 0 && pickaxe + chestplate == 0 {
		return .SWORD;
	}

	if pickaxe != 0 && sword + chestplate == 0 {
		return .PICKAXE;
	}

	if chestplate != 0 && sword + pickaxe == 0 {
		return .CHESTPLATE;
	}

	return .NONE;

}

disable_ambiguous_cells :: proc(cells: ^[3][3]Cell_State, type: CLUE_TYPE) {
	for i in 0..<3 {
		for j in 0..<3 {
			current_cell := &cells[j][i];
			
			#partial switch type {
				case .IRON:
					if only_material_remaining(current_cell^) == .NONE {
						current_cell.available[.IRON_SWORD] = false;
						current_cell.available[.IRON_PICKAXE] = false;
						current_cell.available[.IRON_CHESTPLATE] = false;
					}

				case .GOLD:
					if only_material_remaining(current_cell^) == .NONE {
						current_cell.available[.GOLD_SWORD] = false;
						current_cell.available[.GOLD_PICKAXE] = false;
						current_cell.available[.GOLD_CHESTPLATE] = false;
					}

				case .DIAMOND:
					if only_material_remaining(current_cell^) == .NONE {
						current_cell.available[.DIAMOND_SWORD] = false;
						current_cell.available[.DIAMOND_PICKAXE] = false;
						current_cell.available[.DIAMOND_CHESTPLATE] = false;
					}
				
				
				case .SWORD:
					if only_tool_remaining(current_cell^) == .NONE {
						current_cell.available[.IRON_SWORD] = false;
						current_cell.available[.GOLD_SWORD] = false;
						current_cell.available[.DIAMOND_SWORD] = false;
					}

				case .PICKAXE:
					if only_tool_remaining(current_cell^) == .NONE {
						current_cell.available[.IRON_PICKAXE] = false;
						current_cell.available[.GOLD_PICKAXE] = false;
						current_cell.available[.DIAMOND_PICKAXE] = false;
					}
				case .CHESTPLATE:
					if only_tool_remaining(current_cell^) == .NONE {
						current_cell.available[.IRON_CHESTPLATE] = false;
						current_cell.available[.GOLD_CHESTPLATE] = false;
						current_cell.available[.DIAMOND_CHESTPLATE] = false;
					}
			}
		}
	}
}

is_material :: proc(type: CLUE_TYPE) -> bool {
	if type == .IRON || type == .GOLD || type == .DIAMOND {
		return true;
	}
	return false;
}

is_tool :: proc(type: CLUE_TYPE) -> bool{
	if type == .SWORD || type == .PICKAXE || type == .CHESTPLATE {
		return true;
	}
	return false;
}

Materials :: struct {
	iron: bool,
	gold: bool,
	diamond: bool,
}

get_materials :: proc(cell: Cell_State) -> Materials {
	materials: Materials;
	for type in ITEM_TYPE {
		switch type {
			case .IRON_SWORD ..= .IRON_CHESTPLATE:
				materials.iron = true;
			case .GOLD_SWORD ..= .GOLD_CHESTPLATE:
				materials.gold = true;
			case .DIAMOND_SWORD ..= .DIAMOND_CHESTPLATE:
				materials.diamond = true;
		}
	}

	return materials;
}

Tools :: struct {
	sword: bool,
	pickaxe: bool,
	chestplate: bool,
}

get_tools :: proc(cell: Cell_State) -> Tools {
	tools: Tools;
	for type in ITEM_TYPE {
		if cell.available[type] {
			switch type {
				case .IRON_SWORD: fallthrough
				case .GOLD_SWORD: fallthrough
				case .DIAMOND_SWORD: 
					tools.sword = true;

				case .IRON_PICKAXE: fallthrough
				case .GOLD_PICKAXE: fallthrough
				case .DIAMOND_PICKAXE: 
					tools.pickaxe = true;

				case .IRON_CHESTPLATE: fallthrough
				case .GOLD_CHESTPLATE: fallthrough
				case .DIAMOND_CHESTPLATE: 
					tools.chestplate = true;
			}
		}
	}

	return tools;
}
get_ambiguous_cells :: proc(cells: ^[3][3]Cell_State, type: CLUE_TYPE) -> [dynamic][2]int {

	ambi_cells := make([dynamic][2]int);

	for i in 0..<3 {
		for j in 0..<3 {
			current_cell := cells[j][i];

			if is_material(type) {
				materials := get_materials(current_cell);

				#partial switch type {
					case .IRON:
						if materials.iron && (materials.gold || materials.diamond) {
							append(&ambi_cells, [2]int{i, j});
						}
					case .GOLD:
						if materials.gold && (materials.iron || materials.diamond) {
							append(&ambi_cells, [2]int{i, j});
						}
					case .DIAMOND:
						if materials.diamond && (materials.iron || materials.gold) {
							append(&ambi_cells, [2]int{i, j});
						}
				}
			} else if is_tool(type) {
				tools := get_tools(current_cell);

				#partial switch type {
					case .SWORD:
						if tools.sword && (tools.pickaxe || tools.chestplate) {
							append(&ambi_cells, [2]int{i, j});
						}
					case .PICKAXE:
						if tools.pickaxe && (tools.sword || tools.chestplate) {
							append(&ambi_cells, [2]int{i, j});
						}
					case .CHESTPLATE:
						if tools.chestplate && (tools.sword || tools.pickaxe) {
							append(&ambi_cells, [2]int{i, j});
						}
				}
			}
			
		}
	}

	return ambi_cells;
}

check_triplets :: proc(cells: ^[3][3]Cell_State) {
	remaining: [CLUE_TYPE]int;

	for type in CLUE_TYPE {
		remaining[type] = 3;
	}

	for i in 0..<3 {
		for j in 0..<3 {
			current_cell := cells[j][i];

			remaining_item := only_item_remaining(current_cell)

			switch remaining_item {
				case nil:
					// do nothing
				case .IRON_SWORD:
					remaining[.IRON] -= 1;
					remaining[.SWORD] -= 1;

				case .IRON_PICKAXE:
					remaining[.IRON] -= 1;
					remaining[.PICKAXE] -= 1;

				case .IRON_CHESTPLATE:
					remaining[.IRON] -= 1;
					remaining[.CHESTPLATE] -= 1;
				
				case .GOLD_SWORD:
					remaining[.GOLD] -= 1;
					remaining[.SWORD] -= 1;

				case .GOLD_PICKAXE:
					remaining[.GOLD] -= 1;
					remaining[.PICKAXE] -= 1;

				case .GOLD_CHESTPLATE:
					remaining[.GOLD] -= 1;
					remaining[.CHESTPLATE] -= 1;
				
				case .DIAMOND_SWORD:
					remaining[.DIAMOND] -= 1;
					remaining[.SWORD] -= 1;

				case .DIAMOND_PICKAXE:
					remaining[.DIAMOND] -= 1;
					remaining[.PICKAXE] -= 1;

				case .DIAMOND_CHESTPLATE:
					remaining[.DIAMOND] -= 1;
					remaining[.CHESTPLATE] -= 1;
			}	

			if remaining_item != nil do continue;

			remaining_material := only_material_remaining(current_cell);

			#partial switch remaining_material {
				case .IRON:
					remaining[.IRON] -= 1;
				case .GOLD:
					remaining[.GOLD] -= 1;
				case .DIAMOND:
					remaining[.DIAMOND] -= 1;
			}

			if remaining_material != .NONE do continue;
			
			remaining_tool := only_tool_remaining(current_cell);

			#partial switch remaining_tool {
				case .SWORD:
					remaining[.SWORD] -= 1;
				case .PICKAXE:
					remaining[.PICKAXE] -= 1;
				case .CHESTPLATE:
					remaining[.CHESTPLATE] -= 1;
			}
		}
	}

	// possible_cells := make([CLUE_TYPE][dynamic][2]int);

	// fmt.println(remaining);
	// if true do return;

	for type in CLUE_TYPE {
		if remaining[type] == 0 {
			// fmt.println("All found of: ", type);
			disable_ambiguous_cells(cells, type);

			// print_hacky(cells^);

			continue;
		} 
		ambi_cells := get_ambiguous_cells(cells, type);

		if 0 < len(ambi_cells) && len(ambi_cells) <= 3 {
			// fmt.println("Ambiguous cells: ", ambi_cells, " for type ", type);
		}
		// else if remaining[type] == 1 {
		// 	ambi_cells := get_ambiguous_cells(cells, type);
		// 	// append(&possible_cells[type], )
		// 	// fmt.println("One remaining of: ", type);
		// 	fmt.println("Ambiguous cells: ", ambi_cells);
		// 	if len(ambi_cells) == 1 {
		// 	}
		// }
	}
}

get_offsets_array :: proc(clue: Clue) -> [dynamic][2]int {
	offsets := make([dynamic][2]int);

	for x in 0..<3 - clue.size.x + 1 {
		for y in 0..<3 - clue.size.y + 1 {
			append(&offsets, [2]int{x, y});
		}
	}

	return offsets;
}

get_offsets_array_negative :: proc(clue: Negative_Clue) -> [dynamic][2]int {
	offsets := make([dynamic][2]int);

	for x in 0..<3 - clue.size.x + 1 {
		for y in 0..<3 - clue.size.y + 1 {
			append(&offsets, [2]int{x, y});
		}
	}

	return offsets;
}

disable_unsatisfiable_clue :: proc(cells: ^[3][3]Cell_State, clue: Clue, offset: [2]int) {
	items_to_disable := make([dynamic]ITEM_TYPE);

	for i in 0..<clue.size.x {
		for j in 0..<clue.size.y{
			current_clue := clue.item[j][i];

			#partial switch current_clue {
				case .EMPTY: fallthrough
				case .NONE: ;

				case .IRON_SWORD ..= .DIAMOND_CHESTPLATE: 
					append(&items_to_disable, cast(ITEM_TYPE) current_clue)
			}
		}
	}

	for i in 0..<clue.size.x {
		for j in 0..<clue.size.y{
			current_clue := clue.item[j][i];
			current_cell := &cells[j + offset.y][i + offset.x];


			for item in items_to_disable {
				if cast(ITEM_TYPE) current_clue == item do continue;

				// fmt.println("Disabling ", item, " on ", i, j);
				current_cell.available[item] = false;
			}
		}
	}
}

apply_offset_clue :: proc(cells: ^[3][3]Cell_State, clue: Clue) {
	// board.clues = make([dynamic]Clue);
	offsets := get_offsets_array(clue);
	defer delete(offsets);


	satisfiable := make([]bool, len(offsets));
	for &a in satisfiable {
		a = true;
	}
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
			// fmt.println("Unsatisfiable clue: ")
			// fmt.println(offsets, satisfiable);
			// fmt.printfln("%#v", clue);
			disable_unsatisfiable_clue(cells, clue, offsets[index]);

		}
	}

	if satisfy_count == 1 {
		fixed_clue := create_fixed_clue(clue, correct_offset);

		apply_fixed_clue(cells, fixed_clue);
	} else {
		// fmt.printfln("%#v", clue);
		// fmt.println(offsets, satisfiable);
	}
	
	// fmt.println(offsets, satisfiable);


}

create_fixed_clue :: proc(clue: Clue, correct_offset: [2]int) -> Clue {
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

	return fixed_clue;
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
		// fmt.println("Final item on cell ", index, remaining_type);
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

illegal_state :: proc(board: Board_State) -> bool {
	for x in 0..<3 {
		for y in 0..<3 {
			available_count: int;
			for i in 0..<9 {
				if board.cells[y][x].available[cast(ITEM_TYPE) i] {
					available_count += 1;
				}
			}
			if available_count == 0 do return true;
		}
	}
	return false;
}

sort_clues :: proc(board: ^Board_State) {
	slice.sort_by_cmp(board.clues[:], compare_clues);
	slice.sort_by_cmp(board.negative_clues[:], compare_negative_clues);
}

combine_clues :: proc(clues: []Clue) -> Board_State {
	// fmt.println(clues);

	offsets: [dynamic][dynamic][2]int = make([dynamic][dynamic][2]int);
	defer delete(offsets);

	for clue in clues {
		append(&offsets, get_offsets_array(clue));
	}

	offset_lengths: []int = make([]int, len(offsets));
	defer delete(offset_lengths);

	for offset_array, index in offsets {
		offset_lengths[index] = len(offsets[index]);
	}

	permutation: []int = make([]int, len(offsets));
	defer delete(permutation);

	invalid_permutations: [dynamic][dynamic]int = make([dynamic][dynamic]int);

	for {
		// fmt.println(permutation);
		
		// handle current permutation here
		prunable := true
		if len(invalid_permutations) == 0 do prunable = false;
		for invalid_perm in invalid_permutations {
			for a, index in invalid_perm {
				if a != permutation[index] {
					prunable = false;
					break;
				}
			}
			if !prunable do break;
		}

		
		if !prunable {
			combined_clues := make([dynamic]Clue);
			legal_permutation := true;
			aux_board: Board_State;
			init_board_state(&aux_board);
			// defer destroy_board_state(&aux_board);

			partial_permutation := make([dynamic]int);
			defer delete(partial_permutation);

			for offset_index, index in permutation {
				append(&partial_permutation, offset_index);

				fixed_clue := create_fixed_clue(clues[index], offsets[index][offset_index]);

				apply_fixed_clue(&aux_board.cells, fixed_clue);

				if illegal_state(aux_board) {
					append(&invalid_permutations, partial_permutation);
					legal_permutation = false;
					delete(combined_clues);
					break;
				}

				append(&combined_clues, fixed_clue);
			}

			// print_solution(aux_board);
			if legal_permutation && is_solved(aux_board){
				// print_solution(aux_board);
				return aux_board;
				// return;
			}
		}
		// end of current permutation

		place_pointer: int = len(offset_lengths) - 1;

		for {
			if place_pointer < 0 do break;
			
			permutation[place_pointer] += 1;
			if permutation[place_pointer] >= offset_lengths[place_pointer] {
				permutation[place_pointer] = 0;
				place_pointer -= 1;
			} else do break;
			
		}
		if place_pointer < 0 do break;
	}
	fmt.println("No solution found ://")
	return {};
}

disable_unallowed_items :: proc(cells: ^[3][3]Cell_State, clue: Negative_Clue) {
	offsets := get_offsets_array_negative(clue);
	for offset in offsets {
		for i in 0..<clue.size.x {
			for j in 0..<clue.size.y{
				current_clue := clue.item[j][i];
				current_cell := &cells[j + offset.y][i + offset.x];
				
				#partial switch current_clue {
					case .IRON_SWORD ..= .DIAMOND_CHESTPLATE:
						current_cell.available[cast(ITEM_TYPE) current_clue] = false;
					
					case .IRON:
						current_cell.available[.IRON_SWORD] = false;
						current_cell.available[.IRON_PICKAXE] = false;
						current_cell.available[.IRON_CHESTPLATE] = false;
					
					case .GOLD:
						current_cell.available[.GOLD_SWORD] = false;
						current_cell.available[.GOLD_PICKAXE] = false;
						current_cell.available[.GOLD_CHESTPLATE] = false;
					
					case .DIAMOND:
						current_cell.available[.DIAMOND_SWORD] = false;
						current_cell.available[.DIAMOND_PICKAXE] = false;
						current_cell.available[.DIAMOND_CHESTPLATE] = false;
					
					case .SWORD:
						current_cell.available[.IRON_SWORD] = false;
						current_cell.available[.GOLD_SWORD] = false;
						current_cell.available[.DIAMOND_SWORD] = false;
					
					case .PICKAXE:
						current_cell.available[.IRON_PICKAXE] = false;
						current_cell.available[.GOLD_PICKAXE] = false;
						current_cell.available[.DIAMOND_PICKAXE] = false;
					
					case .CHESTPLATE:
						current_cell.available[.IRON_CHESTPLATE] = false;
						current_cell.available[.GOLD_CHESTPLATE] = false;
						current_cell.available[.DIAMOND_CHESTPLATE] = false;
				}

				check_final_item(cells, {i, j});

				check_triplets(cells);
			}
		}
	}
}

solve_board :: proc(board: ^Board_State, try_combinations: bool = false) -> Board_State {
	sort_clues(board);

	for clue in board.negative_clues {
		if clue.item_count == 1 {
			disable_unallowed_items(&board.cells, clue);
		}
	}

	for i in 0..<len(board.clues) {
		if board.clues[i].size != {3, 3} {
			fmt.println("No fixed clue. Must combine existing clues");

			old_clue := board.clues[i]

			offsets := get_offsets_array(old_clue);
			
			for offset in offsets {
				aux_board: Board_State;
				init_board_state(&aux_board);
				// defer destroy_board_state(&aux_board);
	
				// append_elems(&aux_board.clues, ..board.clues[:]);
				// copy_slice(aux_board.clues[:], board.clues[:]);
				// copy(aux_board.clues[:], board.clues[:])
				append_elems(&aux_board.clues, ..board.clues[:]);
				append_elems(&aux_board.negative_clues, ..board.negative_clues[:]);
	
				// fmt.println(i, offset);
				
	
				
				aux_board.clues[i] = create_fixed_clue(old_clue, offset);



				solve_board(&aux_board);

				if is_solved(aux_board) {
					return aux_board;
				} else {
					// fmt.println("\n\n");
					// print_solution(aux_board);
					destroy_board_state(&aux_board);
				}
			}

			// delete(board.clues);
			// board.clues = combine_clues(board.clues[:]);
		} else {
			break;
		}
	}

	for i in 0..<MAX_ITERATIONS{
		if is_solved(board^) {
			fmt.println("Took ", i, "iterations to solve");
			// print_solution(board^)
			return board^;
		};

		index := 0;
		for clue in board.clues{
			if clue.size.x == 3 && clue.size.y == 3 {
				apply_fixed_clue(&board.cells, clue);
				index += 1;
			}
		}

		// print_solution(board^)

		
		// remove_range(&board.clues, 0, index);
		
		index = 0;
		for clue in board.clues{
			apply_offset_clue(&board.cells, clue);
			index += 1;
		}
	}
	if try_combinations {
		init_board_state(board, false);
		return combine_clues(board.clues[:]);
	}
	return board^;
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

print_hacky :: proc(cells: [3][3]Cell_State) {
	for i in 0..<3 {
		for j in 0..<3 {
			fmt.print("[ ");
			for type, type_name in cells[i][j].available {
				if type {
					fmt.print(type_name, " ");
				}
			}
			fmt.print("] ");
		}
		fmt.println();
	}
}



// odin run .
main :: proc() {
	// invalid_problem();

	// problem17();
	// problem19_m2();
	// problem19();

	problem39();
	// problem21();
	// problem22();
	// problem23();
	// problem25();
	// problem34();
	// problem1();
	// problem2();
	// problem3();
	// problem4();
	// problem7();

	// asd: []int = {2, 6, 4};
	// counter: []int = make([]int, len(asd));

	// for {
	// 	fmt.println(counter);

	// 	place_pointer: int = len(asd) - 1;

	// 	for {
	// 		if place_pointer < 0 do break;
			
	// 		counter[place_pointer] += 1;
	// 		if counter[place_pointer] >= asd[place_pointer] {
	// 			counter[place_pointer] = 0;
	// 			place_pointer -= 1;
	// 		} else do break;
			
	// 	}
	// 	if place_pointer < 0 do break;
	// }
}