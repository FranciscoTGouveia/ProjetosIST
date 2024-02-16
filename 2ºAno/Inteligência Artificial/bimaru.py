# bimaru.py: Template para implementação do projeto de Inteligência Artificial 2022/2023.
# Devem alterar as classes e funções neste ficheiro de acordo com as instruções do enunciado.
# Além das funções e classes já definidas, podem acrescentar outras que considerem pertinentes.

# Grupo 25:
# 102571 Francisco Gouveia
# 103155 Rui Amaral

import sys
import numpy as np
from search import (
    Problem,
    Node,
    astar_search,
    breadth_first_tree_search,
    depth_first_tree_search,
    greedy_search,
    recursive_best_first_search,
)

water_pos = {
                't': [(-1, 0), (0, 1), (0, -1)],
                'b': [(1, 0), (0, 1), (0, -1)],
                'r': [(-1, 0), (0, 1), (1, 0)],
                'l': [(-1, 0), (0, -1), (1, 0)],
                'c': [(-1, 0), (0, 1), (0, -1), (1, 0)],
                'm': []
            }

class BimaruState:
    state_id = 0

    def __init__(self, board, should_print = False, sp2 = False, sp3 = False):
        self.board = board
        self.id = BimaruState.state_id
        BimaruState.state_id += 1
        self.should_print = should_print
        self.should_print2 = sp2
        self.should_print3 = sp3

    def __lt__(self, other):
        return self.id < other.id
    
    def actions(self):
        la = self.board.last_action
        actions = self.board.get_possible_ship_positions()
        return actions

    def goal_test(self):
        return self.board.is_finished()

    def take_action(self, action):
        new_board = self.board.copy()
        new_board.last_action = action
        new_board.place_ship(*action)
        return BimaruState(new_board)

    def print_board(self):
        self.board.print()

    # TODO: outros metodos da classe


class Board:
    """Representação interna de um tabuleiro de Bimaru."""
    def __init__(self, matrix, rows, columns, hints, remaining_ships = [-1, 4, 3, 2, 1], my_rows = [0] * 10, my_columns = [0] * 10, current_ship_size = 4, last_action = ("H", 0, 10)):
        """Construtor para o tabuleiro e informação necessária
            -> '.' = water
            -> 't' = top
            -> 'b' = bottom
            -> 'l' = left
            -> 'r' = right
            -> 'm' = middle
            -> 'c' = circle
            -> 'None' = none (a.k.a. empty)
            Se algum dos símbolos for upper_case então é de uma hint.
        """
        self.board = matrix
        self.rows = rows
        self.columns = columns
        self.my_rows = my_rows
        self.my_columns = my_columns
        self.remaining_ships = remaining_ships
        self.hints = hints;
        self.current_ship_size = current_ship_size
        self.last_action = last_action

    def get_value(self, row: int, col: int) -> str:
        """Devolve o valor na respetiva posição do tabuleiro."""
        return self.board[row, col]

    def adjacent_vertical_values(self, row: int, col: int) -> (str, str):
        """Devolve os valores imediatamente acima e abaixo,
        respectivamente."""
        if row == 0:
            return (None, self.board[row+1, col])
        elif row == 9:
            return (self.board[row-1, col], None)
        else:
            return (self.board[row-1, col], self.board[row+1, col])

    def adjacent_horizontal_values(self, row: int, col: int) -> (str, str):
        """Devolve os valores imediatamente à esquerda e à direita,
        respectivamente."""
        if col == 0:
            return (None, self.board[row, col+1])
        elif col == 9:
            return (self.board[row, col-1], None)
        else:
            return (self.board[row, col-1], self.board[row, col+1])

    def use_hints(self):
        """Places waters from the hints. Does not place down any ship parts."""
        for hint in self.hints:
            letter = hint[2]
            if (letter == 'W'):
                self.board[hint[0], hint[1]] = "W"
            elif (letter == 'C'):
                self.place_part('c', hint[0], hint[1])
                self.remaining_ships[1] -= 1
            else: 
                #self.try_place(letter, hint[0], hint[1])
                self.fill_surrounding_water(hint[0], hint[1], letter.lower())
                
        self.complete_board_after_hints()

    def fill_surrounding_water(self, row, column, letter):
        """Fills in the squares around a given ship part with water"""
        # Get all the water positions for the ship part
        if letter not in water_pos.keys():
            raise Exception("Invalid letter")

        pos_offsets = water_pos[letter] + [(1, 1), (-1, -1), (-1, 1), (1, -1)]
        positions = [(row + v_off, column + h_off) for (v_off, h_off) in pos_offsets]

        for pos in positions:
            if (Board.is_valid_position(pos)):
                self.try_place('.', *pos)

    def get_num_ships_in_row(self, row: int) -> int:
        """Retorna o número de navios numa determinada linha."""
        return self.my_rows[row]
            
    def get_num_ships_in_column(self, column: int) -> int:
        """Retorna o número de navios numa determinada coluna."""
        return self.my_columns[column]
        
    def complete_row_with_water(self, row: int):
        """Completa uma linha do tabuleiro com zeros onde estaria None."""
        for i in range(10):
            self.try_place('.', row, i)
    
    def complete_column_with_water(self, column: int):
        """Completa uma coluna do tabuleiro com zeros onde estaria None."""
        for i in range(10):
            self.try_place('.', i, column)

    def is_free(self, row, column):
        return self.board[row, column] is None

    def try_place(self, letter, row, column):
        """Places a water tile on the given position."""
        if (self.is_free(row, column)):
            self.board[row, column] = letter;
            return True
        else:
            return False

    def complete_board_after_hints(self):
        """Completa o tabuleiro a partir de conclusões que pode tirar
        através das listas rows e columns, e das hints dadas."""
        # Itera sobre linhas
        for i in range(10):
            if self.get_num_ships_in_row(i) == self.rows[i]:
                self.complete_row_with_water(i)
        # Itera sobre colunas
        for i in range(10):
            if self.get_num_ships_in_column(i) == self.columns[i]:
                self.complete_column_with_water(i)
        # Bloqueia espaço ao lado dos barcos
    
    def get_possible_ship_positions(self, dp = False):
        """Finds all possible actions for the current board."""
        actions = [];
        if (self.current_ship_size == 0):
            return actions
        # Set limits as to not check positions which have already been checked
        if self.last_action[0] == "H":
            start_row = self.last_action[1]
            last_col_index = self.last_action[2]
            start_col = 0
            last_row_index = 10
        else:
            start_col = self.last_action[2]
            last_row_index = self.last_action[1]
            start_row = 10
            last_col_index = 10


        # check horizontal ship positions
        for row in range(start_row, 10):
            if self.rows[row] - self.my_rows[row] < self.current_ship_size:
                last_col_index = 10
                continue
            free_tiles = 0;
            for col in reversed(range(0, last_col_index)):
                if self.is_free(row, col):
                    free_tiles += 1
                else:
                    free_tiles = 0
                if free_tiles >= self.current_ship_size:
                    actions.append(("H", row, col))
            last_col_index = 10

        free_tiles = 0

        # check vertical ship positions
        for col in range(start_col, 10):
            if self.columns[col] - self.my_columns[col] < self.current_ship_size:
                last_row_index = 10
                continue
            free_tiles = 0;
            for row in reversed(range(0, last_row_index)):
                if self.is_free(row, col):
                    free_tiles += 1
                else:
                    free_tiles = 0
                if free_tiles >= self.current_ship_size:
                    actions.append(("V", row, col))
            last_row_index = 10
        if len(actions) < self.remaining_ships[self.current_ship_size]:
            return [] 
        return actions

    def place_part(self, part, row, col):
        if not self.try_place(part, row, col):
            raise Exception("Could not place part")

        self.fill_surrounding_water(row, col, part)

        self.my_rows[row] += 1
        self.my_columns[col] += 1

        if (self.my_rows[row] == self.rows[row]):
            self.complete_row_with_water(row)
        if (self.my_columns[col] == self.columns[col]):
            self.complete_column_with_water(col)

    def place_ship(self, orientation, row, col):
        size = self.current_ship_size
        if size == 0:
            raise Exception("Bad stuff happened")

        # Update current ship size
        self.remaining_ships[size] -= 1
        if (self.remaining_ships[size] == 0):
            self.current_ship_size -= 1;
            self.last_action = ("H", 0, 10)
        
        if size == 1:
            self.place_part('c', row, col)
            return

        h_offset = 0
        v_offset = 0
        placed = 2
        if orientation == 'V':
            v_offset = 1
            self.place_part('t', row, col)
            end = 'b'
        else:
            h_offset = 1
            self.place_part('l', row, col)
            end = 'r'

        while placed < size:
            row += v_offset 
            col += h_offset 
            self.place_part('m', row, col)
            placed += 1

        self.place_part(end, row + v_offset, col + h_offset)

    def is_finished(self):
        return self.current_ship_size == 0 and self.check_hints()

    def check_hints(self):
        for hint in self.hints:
            if self.board[hint[0], hint[1]] not in [hint[2].lower(), hint[2]]:
                return False

        return True

    def print(self):
        # Replace hints by upper case letters
        for hint in self.hints:
            self.board[hint[0], hint[1]] = hint[2].upper()

        for i in range(10):
            for j in range(10):
                if not self.is_free(i, j):
                    print(self.board[i, j], end='')
                else:
                    print('*', end='')
            print()


    def copy(self):
        # Performs a deep copy of the board
        matrix_copy = np.array([row.copy() for row in self.board])
        return Board(matrix_copy, self.rows, self.columns, self.hints,
                     self.remaining_ships.copy(), self.my_rows.copy(),
                     self.my_columns.copy(), self.current_ship_size,
                     self.last_action)

    @staticmethod
    def is_valid_position(pos):
        return pos[0] in range(0, 10) and pos[1] in range(0, 10)

    @staticmethod
    def parse_instance():
        rows, columns, hints = [], [], []
        row_input = input()
        row_ptr = 4
        for i in range(10):
            rows.append(int(row_input[row_ptr]))
            row_ptr += 2
        column_input = input()
        col_init = 7
        for i in range(10):
            columns.append(int(column_input[col_init]))
            col_init += 2
        num_hints = int(input())
        for i in range(num_hints):
            new_hint = input()
            new_hint = (int(new_hint[5]), int(new_hint[7]), new_hint[9])
            hints.append(new_hint)
        # Create a matrix to represent the board and return a Board object
        matrix = np.full((10, 10), None)
        my_board = Board(matrix, rows, columns, hints)
        my_board.use_hints()
        return my_board

class Bimaru(Problem):
    def __init__(self, board: Board):
        """O construtor especifica o estado inicial."""
        # É preciso incluir: binaruState, o board, e o id
        self.expansions = 0
        self.initial = BimaruState(board)

    def actions(self, state: BimaruState):
        """Retorna uma lista de ações que podem ser executadas a
        partir do estado passado como argumento."""
        self.expansions += 1
        return state.actions()

    def result(self, state: BimaruState, action) -> BimaruState:
        """Retorna o estado resultante de executar a 'action' sobre
        'state' passado como argumento. A ação a executar deve ser uma
        das presentes na lista obtida pela execução de
        self.actions(state)."""
        return state.take_action(action)

    def goal_test(self, state: BimaruState):
        """Retorna True se e só se o estado passado como argumento é
        um estado objetivo. Deve verificar se todas as posições do tabuleiro
        estão preenchidas de acordo com as regras do problema."""
        return state.goal_test()

    def h(self, node: Node):
        """Função heuristica utilizada para a procura A*."""
        # TODO
        return 0
    
    # TODO: outros metodos da classe

if __name__ == "__main__":
    board = Board.parse_instance()
    bim = Bimaru(board)
    goal = depth_first_tree_search(bim)
    if (goal is not None):
        goal.state.print_board()
