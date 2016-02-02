
class Home
  attr_reader :name, :city, :capacity, :price

  def initialize(name, city, capacity, price)
    @name = name
    @city = city
    @capacity = capacity
    @price = price
  end

end



class HomeCollection
  def initialize(homes)
    @homes = homes
  end

  def showHomes (homes)
    homes.each do |hm|
      puts "#{hm.name} in #{hm.city} with price : #{hm.price.to_s}$/night and capacity: #{hm.capacity}"
    end
  end

  def sortByPrice (order = false)

    if(order)
      @homes.sort! do |home1, home2|
        home1.price <=> home2.price
      end
    else
      @homes.sort! do |home1, home2|
        home2.price <=> home1.price
      end
    end

  end

  def sortByCapacity(order = false)

    if(order)
      @homes.sort! do |home1, home2|
        home1.capacity <=> home2.capacity
      end
    else
      @homes.sort! do |home1, home2|
        home2.capacity <=> home1.capacity
      end
    end

  end

  def getCity(city)
    @homes.select { |home| home.city == city }
  end

  def getAverage
    total = @homes.reduce(0) { |sum, x| sum + x.price }
    total / @homes.length.to_f
  end

  def getByPrice(price)
    @homes.find { |home| home.price == price.to_i }
  end


  def showInstructions

    puts "-"*40
    puts "INSTRUCCIONES A SEGUIR - introduce de 1 a 7 "
    puts "-"*40
    puts "1 - Mostrar ciudades"
    puts "2 - Ordenar ciudades por precio"
    puts "3 - Ordenar ciudades por capacidad"
    puts "4 - Buscar por ciudad"
    puts "5 - Ver la media"
    puts "6 - Buscar por precio"
    puts "7 - EXIT"
    puts "-"*40

  end

  #Función principal
  def main

    showInstructions

    while((input = gets.chomp) != "7")
      case input 
        when "1"
          showHomes(@homes)
        when "2"
          puts "Escribe S o N si quieres ordenar crec o decrec"
          ordered = gets.chomp
          if(ordered == "S")
            sortByPrice(true)
          elsif(ordered == "N")
            sortByPrice(false)
          end
          showHomes(@homes)
        when "3"
          puts "Escribe S o N si quieres ordenar crec o decrec"
          ordered = gets.chomp
          if(ordered == "S")
            sortByCapacity(true)
          elsif(ordered == "N")
            sortByCapacity(false)
          end
          showHomes(@homes)
        when "4"
          puts "Escribe la ciudad a buscar"
          showHomes getCity(gets.chomp)
        when "5"
          puts "La media es " + getAverage.to_s
        when "6"
          puts "Introduce el precio a buscar"
          showHomes [getByPrice(gets.chomp)]
        else
          puts "Opción incorrecta"
      end

      showInstructions
    end

  end

end


homes = [
  Home.new("Nizar's place", "San Juan", 2, 42),
  Home.new("Fernando's place", "Seville", 5, 47),
  Home.new("Josh's place", "Pittsburgh", 3, 41),
  Home.new("Gonzalo's place", "Málaga", 2, 45),
  Home.new("Mario's place", "Alcalá la Real", 4, 49),
  Home.new("Juan's place", "Praga", 6, 34),
  Home.new("Pedro's place", "Londres", 5, 32),
  Home.new("Arturo's place", "París", 6, 65),
  Home.new("Sam's place", "Madrid", 2, 74),
  Home.new("Pepe's place", "Córdoba", 5, 15),
  Home.new("Nizar's place", "Jaén", 2, 55),
  Home.new("Jonh's place", "Huelva", 1, 33),
  Home.new("Mardy's place", "Granada", 3, 22)
]

collection = HomeCollection.new(homes)

collection.main



