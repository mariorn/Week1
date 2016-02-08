
class Character
  def initialize name
    @name = name
    @objects = []
  end

  def add_object object
    @objects << object
  end

  def delete_object object
    @objects.delete object
  end

end

class Room
  attr_reader :description, :actions, :doors, :objects

  def initialize(description, actions, doors, objects)
    @description = description
    @doors = doors
    @actions = actions
    @objects = objects
  end

  def delete object
    @objects.delete object
  end

  def get_object
    @objects[0][1].to_s
  end

  def show_description
    if @objects.length > 0
      puts @description + " " + get_object
    else
      puts @description
    end
  end

  def objects?
    cond = false

    if @objects.length > 0
      cond = true
    end

    cond
  end

end


class Game
  @@win = false
  def initialize(rooms, character)
    @rooms = rooms
    @actual_room = "room1"
    @character = character
  end

  def validate_input direction
    cond = false
    if(direction == "n" || direction == "s" || direction == "e" || direction == "w")
      cond = true
    end
    cond
  end

  #Validamos las acciones, en caso de que haya objetos, los recoge
  def process_action input
    cond = false
    room = @rooms[@actual_room.to_sym]
    action = room.actions[:action]

    if(action[0].downcase == input)
      #Comprobamos si hay objetos
      if(room.objects?)
        cond = true
        #Incluimos el objeto en el inventario del jugador
        @character.add_object action[1]
        #Eliminar el objeto de la habitación
        room.delete action[1]
      else
        puts "No action possible"
      end

    end

    cond
  end



  def start

    @rooms[@actual_room.to_sym].show_description

    input = gets.chomp.downcase

    while @actual_room != "room5"

      #Validar que lo introducido es: n/s/e/w
      if validate_input input

        #Ver si la dirección está habilitada en la habitación actual
        next_room = @rooms[@actual_room.to_sym].doors[input.to_sym]
puts "ROOOM: "+next_room
        if next_room
          if next_room == "room5" && @@win == false
            puts "Tienes que interactuar con ALGO"
          else
            @actual_room = next_room
          end

        else
          puts "No way"
        end

      else
        #Si no se introduce n/s/e/w puede ser que se quiera interactuar
        #hay que validar las acciones
        if process_action input

          puts "You #{input} the object"

        else
          puts "I don't understand"
        end
      end


      puts @rooms[@actual_room.to_sym].description
      direction = gets.chomp.downcase
    end

  end


end


                  #(description, actions, doors, objects)
room1 = Room.new("You are in a dark room. There is a door to the north.", {action: ["Pick up", "You pick up a CD"]} , { n: "room2" , s: nil , e: nil , w: nil } , [ ["CD", "There is a CD on the floor"]])
room2 = Room.new("You are in the forest. There is a lot of light. There is a bear eating apples.", {action: ["cry", "The bear wakes up and kills you."]}, { n: "room5" , s: nil , e: "room3" , w: "room4" } , [])
room3 = Room.new("Solo una salida, por la que has entrado", {} , { n: nil , s: nil , e: nil , w: "room2" } , [])
room4 = Room.new("Solo una salida, por la que has entrado. Hay un equipo de música", { action: ["play", "The bear sleep"]} , { n: nil , s: nil , e: "room2" , w: nil } , [])
room5 = Room.new("Ganaste...si no te mueves", {} , { n: nil , s: "room3" , e: nil , w: nil } , [])

      #     5

      # 3   2   4

      #     1

rooms = { 
          room1: room1,
          room2: room2,
          room3: room3,
          room4: room4,
          room5: room5
        }

game = Game.new(rooms, Character.new("Mario") )
game.start 
