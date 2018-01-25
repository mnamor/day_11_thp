class Player
  attr_accessor :name, :sign
  def initialize(_sign, _player_id)
    puts "Entrer un speudo #{_player_id} ?"
    @name = gets.chomp
    @sign = _sign # asignation de X ou de O
  end
end
class BoardSpace
  attr_accessor :id # (1..9)
  attr_accessor :state # pour gérée les état de la grille
  def initialize(_id)
    @id = _id
    @state = _id
  end
end
class Board
  attr_accessor :board_spaces
  attr_accessor :winning_combinations
  def initialize
    #on stock dans un array les valeurs des cases
    #on verra par la suite, notre board sera une matirce 3*3, on va identifier chaque casepar un id ciffre, l'element 1*1 de la matrice ==> 1, 1*2 (ligne 1, colonne 2) ==> 2
    #les différentes combinaisons gagantes, une sorte de dictionnaire qu'on va utiliser par la suite
    @board_spaces = [] #definition de la variable [tableau vide] vide pour contenire non grille
    (1..9).each do |i|
      @board_spaces << BoardSpace.new(i)
    end
    # les differente combinaison pour gagnier
    @winning_combinations = [
      [1, 2, 3], [4, 5, 6], [7, 8, 9],
      [1, 4, 7], [2, 5, 8], [3, 6, 9],
      [1, 5, 9], [3, 5, 7]
    ]
  end
  def display_board
    line_display = ""

    @board_spaces.each do |board_space|
      case board_space.id % 3
      when 1..2
        line_display += "| #{board_space.state} "
      when 0
        line_display += "| #{board_space.state} |"
        puts line_display
        line_display = ""

      end
    end
  end
end
class Game
  def initialize
    @turns = 0 #definition de la variable toure
    @cases_remaining = [1, 2, 3, 4, 5, 6, 7, 8, 9] # déffinition de la variable grille
  end
  def launch_game
    # définition de la class lancement du jeux
    @players = [Player.new("X", 1), Player.new("O", 2)]
    #definition de la variables grille
    @board = Board.new
    @board.display_board
    loop do
      play_turn
      if is_there_a_winner #le joueurs a gagnier affiche
        puts "#{@players[@turns%2].name} A GAGNE"
        break
      elsif @turns == 8 #si le nombre de tours est sup à 8 affiche
        puts "EGALITE"
        break
      end
      @turns += 1
    end
  end
  #
  def play_turn
    puts "#{@players[@turns%2].name} c'est à votre tour de jouer :"
    case_selected = ""
    loop do
      case_selected = gets.chomp.to_i
      #si la casse est remplie affiche
      if !@cases_remaining.include?(case_selected)
        puts "Vous devez entre un chiffre (entre 1 et 9, et qui n'a pas encore été joué) :"
      else
        @cases_remaining.delete(case_selected)
        break
      end
    end
    #on remplit le status de la case (si elle prend X ou un O) par le symole du joueur qui joue
    @board.board_spaces[case_selected - 1].state = @players[@turns%2].sign
    #affiche l'état du board à chaque tour
    @board.display_board
  end
  #definiion des conrtion de gagnier
  def is_there_a_winner
    return false if @turns < 4 #retourne faus si le toure est inférieur à 4
    #cher les differente combinaison de gagnier
    @board.winning_combinations.each do |combination|
      checked_spaces = []
      combination.each do |i|
        #definition de la si elle est vide
        checked_spaces << @board.board_spaces[i-1].state
      end
  #definition dune condition si la case est dejas utiliser
      return true if checked_spaces.uniq.length == 1
    end
    return false
  end
end
my_game = Game.new
my_game.launch_game

#teste de colorisation de casse selectioner
=begin
class Colors
  def red
    "\e[31m#{self}\e[0m"
  end
  def green
    "\e[32m#{self}\e[0m"
  end
=end
