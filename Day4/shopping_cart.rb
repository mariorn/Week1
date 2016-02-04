

class ShoppingCart
  def initialize(fruits, discounts)
    @items = {}
    @fruits = fruits
    @discounts = discounts
  end

  def add_item_to_cart item
    @items[item] ? @items[item] = @items[item] + 1 : @items[item] = 1
  end

  def show season
    puts @items.inspect
    total = 0
    @items.each do |key, value| 
      total += get_price_discounted(key, value, season)
    end
    puts "TOTAL: #{total}"
  end

  def get_price_discounted(fruit, cantidad, season)
    res = 0
    #Obtenemos el descuento
    discounted_fruit = @discounts[fruit.to_sym]
    if discounted_fruit
      
      #Aplico descuento si la cantidad de fruta es >= que la indicada en el descuento
      if(cantidad >= discounted_fruit[0])
        #Obtenemos cuantos descuentos tenemos que aplicar
        num_dis = cantidad / discounted_fruit[0]
        #Obtenemos el precio de la fruta por la cantidad de fruta
        res = @fruits[fruit.to_sym][season.to_sym] * cantidad

        descuento = 0
        #Si la fruta del descuento la hemos comprado, aplicamos el descuento
        if @items[(discounted_fruit[1][0]).to_sym ]
          descuento = @fruits[ (discounted_fruit[1][0]).to_sym ][season.to_sym] * discounted_fruit[1][1] * num_dis
          res -= descuento
        end
      else

        res = @fruits[fruit.to_sym][season.to_sym] * cantidad

      end

    else
      res = @fruits[fruit.to_sym][season.to_sym] * cantidad
    end
    puts "RESULTADO: " + res.to_s
    res
  end


end


all_fruits = {apple: {spring: 10, summer: 10, autumm: 15, winter: 12}, 
              orange: {spring: 5, summer: 2, autumm: 5, winter: 5}, 
              banana: {spring: 20, summer: 20, autumm: 20, winter: 21}, 
              grape: {spring: 15, summer: 15, autumm: 15, winter: 15}, 
              watermelon: {spring: 50, summer: 50, autumm: 50, winter: 51}
            }

discounts = { apple:  [2 , ["apple", 1] ] ,
              orange: [3 , ["orange", 1] ],
              grape:  [4 , ["banana", 1] ]
            }

cart = ShoppingCart.new(all_fruits, discounts)

cart.add_item_to_cart :apple
cart.add_item_to_cart :orange
cart.add_item_to_cart :orange
cart.add_item_to_cart :orange
cart.add_item_to_cart :banana
cart.add_item_to_cart :grape
cart.add_item_to_cart :grape
cart.add_item_to_cart :grape
cart.add_item_to_cart :grape

cart.show "summer"



