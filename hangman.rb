#The word to guess is represented by a row of dashes, giving the number of letters. If
#the guessing player suggests a letter or number which occurs in the word, the other player
# writes it in all its correct positions. If the suggested letter or number does not occur in the
# word, the other player draws one element of the hanged man stick figure as a tally mark. The
# game is over when:
#
# The guessing player completes the word, or guesses the whole word correctly
# The other player completes the diagram:
# To get the hang of gameplay, here is an online version to play
#

# Use the colorize gem to make each piece of the hangman a different color.
# Place the application flow/logic in a method outside of any class, call this method at the
# end of the file to start the game.
#Display a post
#determine phrase to use
#display dashes
#display letters guessed (downcase)

#player guesses (types in) a letter
#redisplay with:
#letters crossed out and
#either/or:
#body added to hangman (colorize each piece)
#dashes filled in body gradually

#make it so you can't guess the same word twice
require 'colorize'

class Game

  attr_accessor :phrases, :random_phrase, :user_guess, :letters_array, :bool, :bool_letter, :bool_letter_array

  def initialize

    @phrases = Phrases.new(["antidisestablishmentarianism", "refrigerator", "xenophobia", "octogenarian", "ambidextrous", "pterodactyl"])
    @random_phrase = @phrases.randomize
    @user_guess = ""

    @letters_array = [@user_guess]
    @bool_letter_array = []

    @total = 0
    while @total < 7 do
      display(@random_phrase, @letters_array, @user_guess, @bool_letter_array)#1

      user = UserGuess.new
      @user_guess = user.guess_message
      @letters_array.push(@user_guess)
      @bool_letter = compare(@random_phrase, @user_guess) #boolean or count? maybe hash w/ letter/value
      @bool_letter_array.push(@bool_letter)

      @total = count_errors(@bool_letter_array)
      puts "TOTAL: #{@total}"

    end


  end

  def display(rand_phrase, letters_array, user_guess, bool_letter_array)
    show = Display.new(rand_phrase, letters_array, user_guess, bool_letter_array)#2
  end

  def compare(phrase, letter)
    bool_letter = nil
    phrase_letters = phrase.split("")
    phrase_letters.each do |comparison|
      if comparison == letter
        bool_letter = letter
        return bool_letter
      end
    end
    return bool_letter
  end

  def count_errors(array)
    total = 0
    array.each do |count|
      if count == nil
        total += 1
      end
    end
    return total
  end

end



class Display

  attr_accessor :phrase, :letters_array, :letter, :bool_letter_array

  def initialize(phrase, letters_array, letter, bool_letter_array)#3
    @phrase = phrase
    @letters_array = letters_array
    @letter = letter
    @bool_letter_array = bool_letter_array

    post_display(@bool_letter_array)
    notification = display_phrase(@phrase, @bool_letter_array)
    if notification != true
      abort("YOU WIN!")
    end

    display_used_letters(@letters_array)

  end

  def post_display(bool_letter_array)
    wrong_guesses = 0
    bool_letter_array.each do |count|
      if count == nil
        wrong_guesses += 1
      end
    end
    puts ""
    puts "********************************"
    puts ""
    puts ""
    puts "|   ____________"
    puts "|    |/        |"
    body_parts(wrong_guesses)
    puts "|    |"
    puts "|    |"
    puts "|____|_____"
    puts ""
    puts ""
  end

  def body_parts(wrong_guesses)
    if wrong_guesses >= 1
      print "|    |        "
      puts "( )".colorize(:red)
    else
      puts "|    |       "
    end

    if wrong_guesses >= 3
      print "|    |        "
      puts "\\|/".colorize(:light_blue)
    elsif wrong_guesses >= 2
      print "|    |        "
      puts "\\|".colorize(:blue)
    else
      puts "|    |        "
    end

    if wrong_guesses >= 4
      print "|    |         "
      puts "|".colorize(:green)
    else
      puts "|    |       "
    end

    if wrong_guesses >= 6
      print "|    |        "
      puts "/ \\".colorize(:magenta)
      abort ("You lose!")
    elsif wrong_guesses >= 5
        print "|    |        "
        puts "/".colorize(:magenta)
    else
      puts "|    |       "
    end
  end

  def display_used_letters(letters_array)
    puts "           Letters already used:"
    puts""
    print "           "
    letters_array.each do |letters|
      print ""
      print letters
      print " "
    end

    puts""
  end

  def display_phrase(phrase, bool_letter_array)
    notify = false
    bool = false
    print "           "
    phrase_array = phrase.split("")
    phrase_array.each do |phrase_letter|
      bool_letter_array.each do |guess_letter|

        if phrase_letter == guess_letter
          bool = true
          print " #{phrase_letter}"
        end
      end
      if bool != true
        print " _"
        notify = true
      end
    bool = false

    end
    puts ""
    puts ""
    puts ""
    return notify
  end

end



class Phrases

  attr_accessor :phrase_array

  def initialize(phrase_array)
    @phrase_array = phrase_array
  end

  def randomize
    rand = rand(6)
    return @phrase_array[rand]
  end

end

class UserGuess

  attr_accessor :guess, :phrase

  def initialize()#phrase
    @phrase = phrase
  end

  def guess_message
    puts ""
    puts ""
    puts "           Guess a letter!"
    print "           "
    @guess = gets.chomp.downcase
  end

end


play = Game.new
