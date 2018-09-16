class Application

  @@items = ["Apples","Carrots","Pears"]

  #Create a new class array called @@cart to hold any items in your cart
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/) #http://localhost:9292/items
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/) #http://localhost:9292/search?q=Apples
      search_term = req.params["q"]
      resp.write handle_search(search_term)

    #Create a new route called /cart to show the items in your cart
    elsif req.path.match(/cart/) #http://localhost:9292/cart
      if @@cart.empty?
        resp.write "Your cart is empty"
      else
        @@cart.each do |cart_item|
          resp.write "#{cart_item}\n"
        end
      end

    #Create a new route called /add that takes in a GET param with the key item.
    #This should check to see if that item is in @@items and then add it to the cart 
    #if it is. Otherwise give an error
    elsif req.path.match(/add/) #http://localhost:9292/add?item=Apples // http://localhost:9292/add?item=Figs
      search_term = req.params["item"]
      if handle_search(search_term).include?("Couldn't find")
        resp.write "We don't have that item"
      else
        @@cart << search_term
        resp.write "added #{search_term}"
      end

    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
