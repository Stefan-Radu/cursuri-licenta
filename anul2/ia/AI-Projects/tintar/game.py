import sys, pygame

from copy import deepcopy
from enum import Enum
from math import sqrt
from time import perf_counter


class Piece(Enum):
    WHITE = 1
    BLACK = 2
    NOTHING = 3


class PlayerType(Enum):
    HUMAN = 1
    MACHINE = 2


class PlayerState(Enum):
    TO_PUT = 1
    MOARA = 2
    TO_SELECT = 3
    SELECTED = 4


class GameStatus(Enum):
    RUNNING = 1
    OVER = 2

INF = float('inf')

ab_nodes = []
mm_nodes = []

class GameState:

    def __init__(self):
        self.layers = [ [Piece.NOTHING] * 8,
                        [Piece.NOTHING] * 8,
                        [Piece.NOTHING] * 8, ]
        self.to_put = [9, 9]
        self.on_table = [0, 0]
        # 0 -> white, 1 -> black
        self.player_to_move = 0
        self.moarad = False


    def __str__(self):
        ret = f"{self.player_to_move}\n"
        for layer in self.layers:
            for piece in layer:
                if piece is Piece.NOTHING:
                    ret += ' 0 '
                elif piece is Piece.WHITE:
                    ret += ' 1 '
                else:
                    ret += '-1 '
            ret += '\n'
        ret += str(EvaluateV1(self)) + '\n'
        return ret


    @staticmethod
    def EachPosition():
        for i in range(3):
            for j in range(8):
                yield((i, j))


    def add_piece(self, pos: tuple):
        i, j = pos
        if self.player_to_move == 0:
            self.layers[i][j] = Piece.WHITE
        else:
            self.layers[i][j] = Piece.BLACK

        self.to_put[self.player_to_move] -= 1
        assert self.to_put[self.player_to_move] >= 0
        self.on_table[self.player_to_move] += 1


    def remove_piece(self, pos):
        i, j = pos
        assert 0 <= i <= 2
        assert 0 <= j <= 8

        prev_element = self.layers[i][j]
        if prev_element is Piece.NOTHING:
            print('invalid move')
            return
        self.layers[i][j] = Piece.NOTHING
        self.on_table[1 - self.player_to_move] -= 1


    def move_piece(self, old_pos: tuple, new_pos: tuple):
        assert len(old_pos) == 2 and len(new_pos) == 2

        olayer, opos = old_pos
        nlayer, npos = new_pos

        assert self.layers[olayer][opos] is not Piece.NOTHING
        assert self.layers[nlayer][npos] is Piece.NOTHING

        self.layers[nlayer][npos] = self.layers[olayer][opos]
        self.layers[olayer][opos] = Piece.NOTHING


    def is_late_game(self):
        return self.to_put[self.player_to_move] == 0 and \
            self.on_table[self.player_to_move] == 3


    def who_won(self):
        if self.to_put[0] == 0 and self.on_table[0] == 2:
            return 'Black'
        if self.to_put[1] == 0 and self.on_table[1] == 2:
            return 'White'

        if self.to_put[0] > 0 or self.to_put[1] > 0:
            return None

        can_move_white, can_move_black = 0, 0
        for i in range(3):
            for j in range(8):
                a = self.layers[i][j]
                b = self.layers[i][j - 1]
                if a is Piece.NOTHING:
                    a, b = b, a
                if a is not Piece.NOTHING and b is Piece.NOTHING:
                    if a is Piece.WHITE:
                        can_move_white += 1
                    else:
                        can_move_black += 1
                if can_move_black and can_move_white:
                    return None

        for i in range(1, 3):
            for j in range(1, 8, 2):
                a = self.layers[i][j]
                b = self.layers[i - 1][j]
                if a is Piece.NOTHING:
                    a, b = b, a
                if a is not Piece.NOTHING and b is Piece.NOTHING:
                    if a is Piece.WHITE:
                        can_move_white += 1
                    else:
                        can_move_black += 1
                if can_move_black and can_move_white:
                   return None

        if not can_move_white and self.on_table[0] > 3:
            return 'Black'
        if not can_move_black and self.on_table[1] > 3:
            return 'White'
        return None


    def can_put(self, pos):
        i, j = pos
        if self.layers[i][j] is not Piece.NOTHING:
            return False
        return self.to_put[self.player_to_move] > 0


    def can_select(self, point):
        i, j = point
        if self.player_to_move == 0:
            return self.layers[i][j] == Piece.WHITE
        return self.layers[i][j] == Piece.BLACK


    def can_move(self, old_pos, new_pos):
        if self.layers[new_pos[0]][new_pos[1]] is not Piece.NOTHING:
            return False

        if not self.is_late_game():
            inter = abs(old_pos[0] - new_pos[0]) == 1 and \
                old_pos[1] == new_pos[1] and old_pos[1] % 2 == 1
            j_pa = ((min(old_pos[1], new_pos[1]), max(old_pos[1], new_pos[1])))
            on_layer = old_pos[0] == new_pos[0] and \
                (j_pa == (0, 7) or (j_pa[0] == j_pa[1] - 1))
            return inter or on_layer

        return True


    def can_remove(self, pos):
        i, j = pos
        target_piece = Piece.WHITE if self.player_to_move else Piece.BLACK
        if self.layers[i][j] is not target_piece:
            print('nimic sau piesa gresita')
            return False

        if not self.is_moara(pos):
            return True

        for i, layer in enumerate(self.layers):
            for j, piece in enumerate(layer):
                if piece is not target_piece:
                    continue
                if not self.is_moara((i, j)):
                    # print('nu poti scoate din moara acum')
                    return False
        return True


    def change_turn(self):
        self.player_to_move = 1 - self.player_to_move


    def is_moara(self, point):
        i, j = point

        if j % 2 == 1:
            if self.layers[0][j] == self.layers[1][j] == self.layers[2][j]:
                return True
            if j == 7:
                if self.layers[i][6] == self.layers[i][7] == \
                    self.layers[i][0]:
                    return True
                return False
            if self.layers[i][j] == self.layers[i][j - 1] == \
                    self.layers[i][j + 1]:
                return True
            return False

        if j == 0:
            if self.layers[i][0] == self.layers[i][1] == self.layers[i][2]:
                return True
            if self.layers[i][0] == self.layers[i][7] == self.layers[i][6]:
                return True
            return False

        if j == 6:
            if self.layers[i][6] == self.layers[i][7] == self.layers[i][0]:
                return True
            if self.layers[i][6] == self.layers[i][5] == self.layers[i][4]:
                return True
            return False

        if self.layers[i][j] == self.layers[i][j - 1] == self.layers[i][j - 2]:
            return True
        if self.layers[i][j] == self.layers[i][j + 1] == self.layers[i][j + 2]:
            return True
        return False


def Successors(state: GameState):
    empty = [(i, j) for i, j in GameState.EachPosition() \
                if state.layers[i][j] == Piece.NOTHING]
    me = Piece.WHITE if state.player_to_move == 0 else Piece.BLACK
    not_me = Piece.BLACK if state.player_to_move == 0 else Piece.WHITE

    mine = [(i, j) for i, j in GameState.EachPosition() \
                if state.layers[i][j] is me]
    not_mine = [(i, j) for i, j in GameState.EachPosition() \
                if state.layers[i][j] is not_me]

    if state.to_put[state.player_to_move] > 0:
        for i, j in empty:
            new_state = deepcopy(state)
            new_state.add_piece((i, j))
            if new_state.is_moara((i, j)):
                new_state.moarad = True
                for k, l in not_mine:
                    if new_state.can_remove((k, l)):
                        newer_state = deepcopy(new_state)
                        newer_state.remove_piece((k, l))
                        newer_state.change_turn()
                        yield newer_state
            else:
                new_state.change_turn()
                yield new_state
    else:
        for i, j in mine:
            for k, l in empty:
                if state.can_move((i, j), (k, l)):
                    new_state = deepcopy(state)
                    new_state.move_piece((i, j), (k, l))
                    if new_state.is_moara((k, l)):
                        new_state.moarad = True
                        for m, n in not_mine:
                            if new_state.can_remove((m, n)):
                                newer_state = deepcopy(new_state)
                                newer_state.remove_piece((m, n))
                                newer_state.change_turn()
                                yield newer_state
                    else:
                        new_state.change_turn()
                        yield new_state



def EvaluateV1(state):
    m_count = Game.MoaraCount(state)
    p_count = Game.PieceCount(state)
    tp_count = Game.TwoPieceConfig(state)
    final = Game.IsFinal(state)
    if sum(state.to_put) > 0:
        return 17 * state.moarad + 27 * m_count + \
            9 * p_count + 10 * tp_count
    else:
        return 13 * state.moarad + 53 * m_count + \
            11 * p_count + 7 * tp_count + 1001 * final


def EvaluateV2(state):
    m_count = Game.MoaraCount(state)
    p_count = Game.PieceCount(state)
    tp_count = Game.TwoPieceConfig(state)
    final = Game.IsFinal(state)
    return 3 * state.moarad + 5 * m_count + \
        2 * p_count + tp_count + 100 * final


def _MiniMax(state, depth, evaluate):
    total = 1
    if depth == 0:
        return evaluate(state), state, total

    if state.player_to_move == 0:
        max_eval = (-INF, None)
        for next_state in Successors(state):
            ev = _MiniMax(next_state, depth - 1, evaluate)
            if ev[0] > max_eval[0]: max_eval = (ev[0], next_state)
            total += ev[2]
        return (max_eval[0], max_eval[1], total)

    min_eval = (INF, None)
    for next_state in Successors(state):
        ev = _MiniMax(next_state, depth - 1, evaluate)
        if ev[0] < min_eval[0]: min_eval = (ev[0], next_state)
        total += ev[2]
    return (min_eval[0], min_eval[1], total)


def MiniMax(state, depth, evaluate):
    res = _MiniMax(state, depth, evaluate)
    mm_nodes.append(res[2])
    return res[0], res[1]


def _AlphaBeta(state, depth, evaluate, alpha = -INF, beta = INF):
    total = 1
    if depth == 0:
        return evaluate(state), state, total

    if state.player_to_move == 0:
        max_eval = (-INF, None)
        for next_state in Successors(state):
            ev = _AlphaBeta(next_state, depth - 1, evaluate, alpha, beta)
            if ev[0] > max_eval[0]: max_eval = (ev[0], next_state)
            alpha = max(alpha, ev[0])
            total += ev[2]
            if beta <= alpha: break
        return (max_eval[0], max_eval[1], total)

    min_eval = (INF, None)
    for next_state in Successors(state):
        ev = _AlphaBeta(next_state, depth - 1, evaluate, alpha, beta)
        if ev[0] < min_eval[0]: min_eval = (ev[0], next_state)
        beta = min(beta, ev[0])
        total += ev[2]
        if beta <= alpha: break
    return (min_eval[0], min_eval[1], total)


def AlphaBeta(state, depth, evaluate):
    res = _AlphaBeta(state, depth, evaluate)
    ab_nodes.append(res[2])
    return res[0], res[1]


class Buton:
    def __init__(self, display=None, left=0, top=0, w=0, h=0, \
                 culoareFundal=(89,134,194), \
                 culoareFundalSel=(53,80,115), text="", \
                 font="arial", fontDimensiune=16, \
                 culoareText=(255,255,255), valoare=""):
        self.display = display
        self.culoareFundal = culoareFundal
        self.culoareFundalSel = culoareFundalSel
        self.text = text
        self.font = font
        self.w = w
        self.h = h
        self.selectat = False
        self.fontDimensiune = fontDimensiune
        self.culoareText = culoareText
        #creez obiectul font
        fontObj = pygame.font.SysFont(self.font, self.fontDimensiune)
        self.textRandat = fontObj.render(self.text, True , \
                                         self.culoareText)
        self.left = left
        self.top = top
        self.dreptunghi = pygame.Rect(left, top, w, h)
        #aici centram textul
        self.dreptunghiText = self.textRandat. \
            get_rect(center=self.dreptunghi.center)
        self.valoare = valoare


    def selecteaza(self,sel):
        self.selectat = sel
        self.deseneaza()


    def selecteazaDupacoord(self,coord):
        if self.dreptunghi.collidepoint(coord) and \
                self.selectat == False:
            self.selecteaza(True)
            return True
        return False


    def updateDreptunghi(self):
        self.dreptunghi.left = self.left
        self.dreptunghi.top = self.top
        self.dreptunghiText = self.textRandat. \
            get_rect(center=self.dreptunghi.center)


    def deseneaza(self):
        culoareF = self.culoareFundalSel if self.selectat \
            else self.culoareFundal
        pygame.draw.rect(self.display, culoareF, self.dreptunghi)
        self.display.blit(self.textRandat ,self.dreptunghiText)


class GrupButoane:
    def __init__(self, listaButoane=[], indiceSelectat=0, \
                 spatiuButoane=10,left=0, top=0):
        self.listaButoane = listaButoane
        self.indiceSelectat = indiceSelectat
        self.listaButoane[self.indiceSelectat].selectat = True
        self.top = top
        self.left = left
        leftCurent = self.left
        for b in self.listaButoane:
            b.top = self.top
            b.left = leftCurent
            b.updateDreptunghi()
            leftCurent += (spatiuButoane + b.w)


    def selecteazaDupacoord(self, coord):
        for ib, b in enumerate(self.listaButoane):
            if b.selecteazaDupacoord(coord):
                self.listaButoane[self.indiceSelectat] \
                    .selecteaza(False)
                self.indiceSelectat = ib
                return True
        return False


    def deseneaza(self):
        #atentie, nu face wrap
        for b in self.listaButoane:
            b.deseneaza()


    def getValoare(self):
        return self.listaButoane[self.indiceSelectat].valoare


def get_player_input(display):
    btn_alg = GrupButoane(top=30, left=30, listaButoane=[
            Buton(display=display, w=80, h=30, \
                  text="minimax", valoare="minimax"),
            Buton(display=display, w=90, h=30, \
                  text="alphabeta", valoare="alphabeta")
            ], indiceSelectat=1)

    btn_est = GrupButoane(top=100, left=30, listaButoane=[
            Buton(display=display, w=100, h=30, \
                  text="estimare_1", valoare="estimare_1"),
            Buton(display=display, w=100, h=30, \
                  text="estimare_2", valoare="estimare_2")
            ])

    btn_color = GrupButoane(top=170, left=30, listaButoane=[
            Buton(display=display, w=55, h=30, \
                  text="White", valoare=0),
            Buton(display=display, w=55, h=30, \
                  text="Black", valoare=1)
            ], indiceSelectat=0)

    btn_diff = GrupButoane(top=240, left=30, listaButoane=[
            Buton(display=display, w=60, h=30, \
                  text="Easy", valoare=1),
            Buton(display=display, w=70, h=30, \
                  text="Medium", valoare=2),
            Buton(display=display, w=60, h=30, \
                  text="Hard", valoare=3),
            ], indiceSelectat=1)

    btn_type = GrupButoane(top=310, left=30, listaButoane=[
            Buton(display=display, w=100, h=30, \
                  text="Player vs AI", valoare=1),
            Buton(display=display, w=127, h=30, \
                  text="Player vs Player", valoare=2),
            Buton(display=display, w=100, h=30, \
                  text="AI1 vs AI2", valoare=3),
            ], indiceSelectat=0)

    start = Buton(display=display, top=380, left=30, w=40, h=30, \
               text="Start", culoareFundal=(155,0,55))

    btn_alg.deseneaza()
    btn_color.deseneaza()
    btn_diff.deseneaza()
    btn_est.deseneaza()
    btn_type.deseneaza()
    start.deseneaza()

    while True:
        for ev in pygame.event.get():
            if ev.type== pygame.QUIT:
                pygame.quit()
                sys.exit()
            if ev.type == pygame.MOUSEBUTTONDOWN:
                pos = pygame.mouse.get_pos()
                btn_alg.selecteazaDupacoord(pos)
                btn_color.selecteazaDupacoord(pos)
                btn_diff.selecteazaDupacoord(pos)
                btn_est.selecteazaDupacoord(pos)
                btn_type.selecteazaDupacoord(pos)
                if start.selecteazaDupacoord(pos):
                    return btn_alg.getValoare(), \
                        btn_diff.getValoare(), \
                        btn_color.getValoare(), \
                        btn_est.getValoare(), \
                        btn_type.getValoare()
        pygame.display.update()


class Game:

    SIZE = 800, 900
    BLACK = 0, 0, 0
    WHITE = 255, 255, 255
    PINK = 224, 42, 221
    BACKGROUND = 227, 223, 123
    FOREGROUND = 50, 50, 50
    BALL_RADIUS = 15
    PIECE_RADIUS = 27
    LINE_THINKNESS = 7

    positions = [
        [(100, 100), (400, 100), (700, 100), (700, 400), \
         (700, 700), (400, 700), (100, 700), (100, 400)],
        [(200, 200), (400, 200), (600, 200), (600, 400), \
         (600, 600), (400, 600), (200, 600), (200, 400)],
        [(300, 300), (400, 300), (500, 300), (500, 400), \
         (500, 500), (400, 500), (300, 500), (300, 400)],
    ]

    piece_color_map = {
        Piece.WHITE: WHITE,
        Piece.BLACK: BLACK,
        Piece.NOTHING: FOREGROUND,
    }

    lines_per_layer = [(0, 2), (2, 4), (4, 6), (6, 0)]
    lines_inter_layer = [1, 3, 5, 7]
    lines_explicit = [(0, 1, 2), (2, 3, 4), (4, 5, 6), (6, 7, 0)]

    def __init__(self, algorithm, difficulty, who_first, est_function, \
                 game_type):

        pygame.init()
        pygame.font.init()
        pygame.display.set_caption('Stefan Radu - Tintar')

        self.state = GameState()
        self.screen = pygame.display.set_mode(self.SIZE)
        print('a rulat init')
        self.player_state = PlayerState.TO_PUT
        self.selected = ()
        self.game_status = GameStatus.RUNNING

        self.display_text = ''
        self.font = pygame.font.SysFont('Source Code Pro Black', 64)

        self.algorithm = MiniMax if algorithm == 'minimax' else AlphaBeta

        d = { }
        if algorithm == 'minimax':
            d = { 1: 1, 2: 2, 3: 3 }
        else:
            d = { 1: 1, 2: 3, 3: 5 }
        self.depth = d[difficulty]
        self.state.player_to_move = 0

        self.eval_function = EvaluateV1 if est_function == 'estimare_1' \
            else EvaluateV2

        self.player_type = ()
        if game_type == 1:
            self.player_type = (PlayerType.HUMAN, PlayerType.MACHINE)
        elif game_type == 2:
            self.player_type = (PlayerType.HUMAN, PlayerType.HUMAN)
        elif game_type == 3:
            self.player_type = (PlayerType.MACHINE, PlayerType.MACHINE)

        if who_first == 1:
            self.player_type = (self.player_type[1], self.player_type[0])


    def display(self, who_won = None):
        self.screen.fill(self.BACKGROUND)

        # layer lines
        for line in self.lines_per_layer:
            i, j = line
            for layer in range(3):
                x = self.positions[layer][i]
                y = self.positions[layer][j]
                pygame.draw.line(self.screen, self.FOREGROUND, \
                                 x, y, self.LINE_THINKNESS)

        # inter-layer lines
        for j in self.lines_inter_layer:
            x = self.positions[0][j]
            y = self.positions[2][j]
            pygame.draw.line(self.screen, self.FOREGROUND, \
                                x, y, self.LINE_THINKNESS)

        # circles
        for i, layer in enumerate(self.positions):
            for j, poz in enumerate(layer):
                piece = self.state.layers[i][j]
                color = self.piece_color_map[piece]
                radius = self.PIECE_RADIUS if piece != Piece.NOTHING \
                    else self.BALL_RADIUS
                pygame.draw.circle(self.screen, color, poz, radius)

        # mark selected
        if self.selected:
            i, j = self.selected
            assert self.state.layers[i][j] is not Piece.NOTHING
            color = self.BLACK
            if self.state.layers[i][j] is Piece.BLACK:
                color = self.WHITE
            i, j = self.selected
            pygame.draw.circle(self.screen, color, self.positions[i][j], \
                               self.BALL_RADIUS)

        # mark in moara
        if self.player_state == PlayerState.MOARA:
            target, color = None, None
            if self.state.player_to_move == 0:
                target = Piece.BLACK
                color = self.WHITE
            else:
                target = Piece.WHITE
                color = self.BLACK

            for i, layer in enumerate(self.positions):
                for j, poz in enumerate(layer):
                    piece = self.state.layers[i][j]
                    if piece is not target:
                        continue
                    pygame.draw.circle(self.screen, color, poz, self.BALL_RADIUS)

        if who_won is not None and self.game_status is GameStatus.OVER:
            target = None
            if who_won == 'White':
                target = Piece.WHITE
            else:
                target = Piece.BLACK

            for i, layer in enumerate(self.positions):
                for j, poz in enumerate(layer):
                    piece = self.state.layers[i][j]
                    if piece is not target:
                        continue
                    pygame.draw.circle(self.screen, self.PINK, poz, \
                                       self.BALL_RADIUS)

        # render text
        surface = self.font.render(self.display_text, False, self.BLACK)
        self.screen.blit(surface, (100, 800))

        pygame.display.flip()


    @staticmethod
    def GetDist(poz1, poz2):
        x1, y1 = poz1
        x2, y2 = poz2
        return sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)


    def get_clicked_point(self, click_pos):
        for i, layer in enumerate(self.positions):
            for j, pos in enumerate(layer):
                if self.GetDist(pos, click_pos) < self.PIECE_RADIUS:
                    return (i, j)
        return None


    def handle_click(self, event):
        point = self.get_clicked_point(event.pos)
        if point is None:
            print('apesi pe langa')
            return

        if self.player_state == PlayerState.TO_PUT and \
                self.state.to_put[self.state.player_to_move] == 0:
            self.player_state = PlayerState.TO_SELECT

        if self.player_state == PlayerState.TO_PUT:
            if self.state.can_put(point):
                self.state.add_piece(point)
                if self.state.is_moara(point):
                    self.player_state = PlayerState.MOARA
                else:
                    self.state.change_turn()
            else:
                print('invalid move')
        elif self.player_state == PlayerState.TO_SELECT:
            if self.state.can_select(point):
                self.selected = point
                self.player_state = PlayerState.SELECTED
                print(f'selected {self.selected}')
            else:
                print('invalid select')
        elif self.player_state == PlayerState.SELECTED:
            print('unde muti?')
            if self.state.can_move(self.selected, point):
                self.state.move_piece(self.selected, point)
                self.selected = ()
                if self.state.is_moara(point):
                    self.player_state = PlayerState.MOARA
                else:
                    self.state.change_turn()
                    self.player_state = PlayerState.TO_PUT
            elif self.state.can_select(point):
                self.selected = point
                self.player_state = PlayerState.SELECTED
                print(f'selected {self.selected}')
            else:
                print('cannot move there')
        elif self.player_state == PlayerState.MOARA:
            if self.state.can_remove(point):
                self.state.remove_piece(point)
                self.state.change_turn()
                self.player_state = PlayerState.TO_PUT


    @staticmethod
    def MoaraCount(state: GameState):
        # difference between the number of mori
        ret = 0
        for a, b, c in Game.lines_explicit:
            for i in range(3):
                if state.layers[i][a] == Piece.NOTHING:
                    continue
                if state.layers[i][a] == state.layers[i][b] == \
                        state.layers[i][c]:
                    if state.layers[i][a] == Piece.WHITE:
                        ret += 1
                    else:
                        ret -= 1
        for j in Game.lines_inter_layer:
            if state.layers[0][j] == Piece.NOTHING:
                continue
            if state.layers[0][j] == state.layers[1][j] == \
                    state.layers[2][j]:
                if state.layers[0][j] == Piece.WHITE:
                    ret += 1
                else:
                    ret -= 1

        return ret


    @staticmethod
    def PieceCount(state: GameState):
        # difference between the number of pieces
        ret = 0
        for i, j in GameState.EachPosition():
            if state.layers[i][j] == Piece.WHITE:
                ret += 1
            elif state.layers[i][j] == Piece.BLACK:
                ret -= 1

        return ret


    @staticmethod
    def TwoPieceConfig(state: GameState):
        # difference between almost moris configs count
        ret = 0
        for i in range(3):
            for js in Game.lines_explicit:
                w, b, n = 0, 0, 0
                for j in js:
                    if state.layers[i][j] is Piece.WHITE:
                        w += 1
                    elif state.layers[i][j] is Piece.BLACK:
                        b += 1
                    else:
                        n += 1
                if w == 2 and n == 1:
                    ret += 1
                elif b == 2 and n == 1:
                    ret -= 1

        for j in Game.lines_inter_layer:
            w, b, n = 0, 0, 0
            for i in range(3):
                if state.layers[i][j] is Piece.WHITE:
                    w += 1
                elif state.layers[i][j] is Piece.BLACK:
                    b += 1
                else:
                    n += 1
            if w == 2 and n == 1:
                ret += 1
            elif b == 2 and n == 1:
                ret -= 1

        return ret


    @staticmethod
    def IsFinal(state: GameState):
        # check if final State
        who_won = state.who_won()
        if who_won == 'White':
            return 1
        if who_won == 'Black':
            return -1
        return 0


    def run(self):
        if self.state.player_to_move == 0:
            self.display_text = 'White\'s turn to move.'
        else:
            self.display_text = 'Black\'s turn to move.'
        self.display()

        player_time = [[], []]

        tic = perf_counter()
        tic_total = perf_counter()
        player_count = [0, 0]

        while True:
            click = None
            exit = False
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    exit = True
                    break
                elif event.type == pygame.MOUSEBUTTONDOWN:
                    click = event
                elif event.type == pygame.KEYDOWN:
                    if self.game_status == GameStatus.OVER:
                        exit = True
                        break

            if exit: break

            who_won = self.state.who_won()
            if who_won is not None:
                self.game_status = GameStatus.OVER

            if self.game_status is GameStatus.RUNNING:
                if self.state.player_to_move == 0:
                    self.display_text = 'White\'s turn to move.'
                else:
                    self.display_text = 'Black\'s turn to move.'
                self.display()

                ceva = True
                if self.player_type[0] == self.player_type[1] and \
                        self.player_type[0] == PlayerType.MACHINE:
                    if self.state.player_to_move == 0:
                        player_count[self.state.player_to_move] += 1
                        res = self.algorithm(self.state, self.depth, \
                                             EvaluateV1)
                        self.state = res[1]
                        print(f'Estimare: {res[0]}')
                    else:
                        player_count[self.state.player_to_move] += 1
                        res = self.algorithm(self.state, self.depth, \
                                             EvaluateV2)
                        self.state = res[1]
                        print(f'Estimare: {res[0]}')
                else:
                    now_type = self.player_type[self.state.player_to_move]
                    if now_type == PlayerType.HUMAN:
                        if click:
                            player_count[self.state.player_to_move] += 1
                            self.handle_click(click)
                        else:
                            ceva = False
                    else:
                        player_count[self.state.player_to_move] += 1
                        res = self.algorithm(self.state, self.depth, \
                                             self.eval_function)
                        self.state = res[1]
                        print(f'Estimare: {res[0]}')

                if ceva:
                    toc = perf_counter()
                    print(f'Thinking time: {toc - tic:0.3f}')
                    player_time[1 - self.state.player_to_move].append(toc - tic)
                    tic = toc

            else:
                if click: break
                self.display_text = f'{who_won} won. Press any key.'

            self.display(who_won)

        print(f'\nPlayer 1 times:\nmin: {min(player_time[0]):0.3f}s\n' \
              f'max: {max(player_time[0]):0.3f}s\n' \
              f'avg: {(sum(player_time[0]) / len(player_time[0])):0.3f}s\n' \
              f'median: {player_time[0][len(player_time[0]) // 2]:0.3f}s')

        print(f'\nPlayer 2 times:\nmin: {min(player_time[1]):0.3f}s\n' \
              f'max: {max(player_time[1]):0.3f}s\n' \
              f'avg: {(sum(player_time[1]) / len(player_time[1])):0.3f}s\n' \
              f'median: {player_time[1][len(player_time[1]) // 2]:0.3f}s')

        global mm_nodes, ab_nodes
        if mm_nodes == []: mm_nodes = [0]
        if ab_nodes == []: ab_nodes = [0]

        print(f'\nMinimax noduri:\nmin: {min(mm_nodes):0.3f}\n' \
              f'max: {max(mm_nodes):0.3f}\n' \
              f'avg: {(sum(mm_nodes) / len(mm_nodes)):0.3f}\n' \
              f'median: {mm_nodes[len(mm_nodes) // 2]:0.3f}')

        print(f'\nAlpha-Beta noduri:\nmin: {min(ab_nodes):0.3f}\n' \
              f'max: {max(ab_nodes):0.3f}\n' \
              f'avg: {(sum(ab_nodes) / len(ab_nodes)):0.3f}\n' \
              f'median: {ab_nodes[len(ab_nodes) // 2]:0.3f}')

        toc_total = perf_counter()
        print(f'\nTimp total joc: {toc_total - tic_total:0.3f}s\n')

        print(f'Jucatorul 1 a mutat de {player_count[0]} ori\n')
        print(f'Jucatorul 2 a mutat de {player_count[1]} ori\n')


if __name__ == '__main__':
    pygame.init()
    screen = pygame.display.set_mode((800, 900))
    alg, diff, color, est, typ = get_player_input(screen)
    g = Game(alg, diff, color, est, typ)
    g.run()
