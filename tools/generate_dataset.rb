require 'chunky_png'
require 'rubycards'
include RubyCards

unless ARGV[0] and ARGV[1] and ARGV[2]
  puts "Usage: ruby generate_dataset.rb [Number of players to simulate] [Number of decks to use per round] [number of scenarios to generate per player per deck]"
  puts "Also ensure you've created the proper directories for the output images: blackjack, blackjack/stand and blackjack/hit"
end

ARGV[0].to_i.times do |n_players|
  ARGV[1].to_i.times do |n_decks|
    ARGV[2].to_i.times do |x|

      drawn_cards = []
      
      player_hands = []
      n_players.times { player_hands << Hand.new }

      deck = Deck.new
      deck.shuffle!

      player_hands.each do |hand|
        hand.draw(deck, 2)
        hand.each { |card| drawn_cards << card.to_i }

        puts hand
      end

      while not player_hands.empty?
        player_hands.each do |hand|
          hand.draw(deck, 1)

          puts hand
          card = hand[-1]
          drawn_cards << card.to_i
          
          busted = false
          deck_total = 0
          hand.each { |c| deck_total += c.to_i }
          if deck_total > 21
            busted = true
            player_hands.delete(hand)
          end
          
          png = ChunkyPNG::Image.new(64, 64, ChunkyPNG::COLOR_GRAYSCALE)

          drawn_cards.each_with_index do |card, i|
            break if i > 47
            i += 1
            png[i,i] = card*16
            png[i+1,i] = card*16
            png[i,i+1] = card*16
            png[i+1,i+1] = card*16
          end
          
          classname = "blackjack/"
          classname += "stand" if busted
          classname += "hit" if !busted 
          png.save("#{classname}/#{x.to_s}-#{n_players}-#{n_decks}.png", :interlace => false)

        end
      end
    end
  end
end
