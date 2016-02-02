require 'date'
require 'colorize'

class Blog
	def initialize
		@posts = []
    @actual_page = 1
    @max_pages = 0
	end

  #Añadimos post al array
	def add_post(post)
		@posts << post
    @posts = sort_posts

    @max_pages = (@posts.length / 3) 
    if(@posts.length % 3 != 0)
      @max_pages += 1
    end

	end

  #Ordenamos por fecha
  def sort_posts
    @posts.sort do |x, y|
      x.date <=> y.date
    end
  end

  #Imprimimos los post de la página correspondiente a @actual_page
	def publish_front_page

    if(@actual_page >= 1 && @actual_page <= @max_pages)
      for j in ((@actual_page - 1) * 3)..(@actual_page * 3) - 1
        if(j < @posts.length)
          @posts[j].publish
        end
      end

      publish_foot
    end
	
  end

  #Imprime el listado de páginas
  def publish_foot
    puts ""
    puts get_pages
    puts ""
  end


  #Obtenemos el listado del número de páginas para el footer
  def get_pages

    aux = ""

    for i in 1..@max_pages

      if(i == @actual_page)
        aux += "[#{i.to_s}] ".red
      else
        aux += i.to_s + " "
      end
      
    end

    aux

  end


  def main

    publish_front_page

    while((input = gets.chomp) != "exit")

      case input 
        when "next"
          @actual_page += 1
          publish_front_page
        when "prev"
          @actual_page -= 1
          publish_front_page
        else
          @actual_page = input.to_i
          publish_front_page
      end
    end
  end


end



class Post

  attr_reader :date

	def initialize(title, date, text, sponsor = false)
    if(sponsor)
      @title = "****" + title + "****"
    else
      @title = title
    end
		@date = date
		@text = text
    @sponsor = sponsor
	end

  def publish
      puts @title
      puts "*" * 15
      puts @text
      puts "-" * 15
  end

end



post1 = Post.new("Post title 1", Date.new(2016,1,13), "Post 1 text" )
post2 = Post.new("Post title 2", Date.new(2016,1,14), "Post 2 text" , true)
post3 = Post.new("Post title 3", Date.new(2016,1,23), "Post 3 text" )
post4 = Post.new("Post title 4", Date.new(2016,1,23), "Post 4 text" )
post5 = Post.new("Post title 5", Date.new(2016,1,25), "Post 5 text" , true)
post6 = Post.new("Post title 6", Date.new(2016,1,26), "Post 6 text" )
post7 = Post.new("Post title 7", Date.new(2016,1,27), "Post 7 text" )
post8 = Post.new("Post title 8", Date.new(2016,1,30), "Post 8 text" )



blog = Blog.new
blog.add_post(post1)
blog.add_post(post3)
blog.add_post(post2)
blog.add_post(post4)
blog.add_post(post5)
blog.add_post(post6)
blog.add_post(post7)
blog.add_post(post8)



blog.main


