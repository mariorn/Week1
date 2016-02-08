require 'imdb'

  file = File.open("movies.txt", "r")
  movies = file.readlines
  file.close
  
  pelis = []

  movies.each do |title|

    i = Imdb::Search.new(title)

    title_search = ""
    rating_search = nil

    find_film = i.movies.find do |movie| 
      movie.rating != nil
    end

    pelis << [find_film.title, find_film.rating.round(1).to_i]

  end


def find_max_rating(pelis)
  res = pelis.sort do |x,y|
    y[1] <=> x[1]
  end

  res[0][1]

end


cont = find_max_rating(pelis)



while cont > 0
  cad = "|"

    pelis.each do |peli|
      if peli[1] >= cont
        cad += "#|"
      else

        cad += " |"
      end
    end

  cont -= 1
  puts cad
end

puts "---------------"

aux = "|"
pelis.length.times do |i|
aux += i.to_s + "|"
end

puts aux

pelis.length.times do |i|
puts i.to_s + ". " + pelis[i][0]

end






