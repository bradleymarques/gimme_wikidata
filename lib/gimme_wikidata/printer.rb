module GimmeWikidata
  require 'colorize'

  class Entity
    ##
    # Prints a pretty version of the Entity to console
    def print(colour = :blue)
      heading = "#{label} (#{id})"
      puts '=' * heading.length
      puts "#{label} (#{id})".bold.colorize(background: colour)
      puts '=' * heading.length
      puts "Description\t".bold + @description
      puts "Aliases\t\t".bold + @aliases.join(', ')
      puts "Claims:".underline
      claims.each {|sc| sc.print }
      return nil
    end
  end

  class Claim
    ##
    # Prints a pretty version of the Claim to the console
    def print(colour = :blue)
      simple = simplify
      puts "#{simple[:property]}: ".bold.colorize(color: colour) + "#{simple[:value].to_s}"
    end
  end

end