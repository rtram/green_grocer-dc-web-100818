require"pry"

def consolidate_cart(cart)
  cart_hash = {}
  
  #Remove duplicates and merge count hash
  cart.each do |item|
    if (cart_hash.keys.include? (item.keys[0])) == false
      count_hash = {}
      cart_hash[item.keys[0]] = item.values[0]
      count_hash[item.keys[0]] = {:count => 0}
      cart_hash[item.keys[0]] = cart_hash[item.keys[0]].merge(count_hash[item.keys[0]])
    end 
  end 
  
  #Count items and update cart-count hash
  cart_keys = []
  cart.each do |item|
    cart_keys << item.keys[0]
  end 
  
  cart_hash.each do |item_name, item_char|
    count_int = cart_keys.count(item_name)
    cart_hash[item_name][:count] = count_int
  end 
  cart = cart_hash
  return cart
end

def apply_coupons(cart, coupons)
  
  #check if coupon array has elements
  if coupons.length > 0
    
    #iterate through coupon array
    coupons.each do |n|
      
      #see if coupon item is in the cart
      if (cart.keys.include? (n[:item])) 
        
        #decrease cart item quantity
        cart[n[:item]][:count] -= n[:num]

        
        #see if we need to add coupon line item to cart or increase existing coupon line item
        if cart.keys.include? ("#{n[:item]} W/COUPON")
          
          cart["#{n[:item]} W/COUPON"][:count] += 1
        else 
        #convert coupon structure to cart_hash structure and merge into cart
        coupon_hash = {}
        coupon_hash["#{n[:item]} W/COUPON"] = {:price => n[:cost], :clearance => cart[n[:item]][:clearance], :count => 1}
        cart = cart.merge(coupon_hash)
        end
      else 
        return cart
      end 
    end 
  end
  return cart
end 


def apply_clearance(cart)
  #iterate through cart.
  cart.each do |item, item_values|
    item_values.each do |char, char_value|
  
  #if statement to determine clearance item
      if (char == :clearance && char_value == true)
  #return price pair with 80% value
        cart[item][:price] = (cart[item][:price] * 0.8).round(2)
      end 
    end 
  end
end

def checkout(cart, coupons)
  total_cost = 0
  
  #call consolidate_cart method
  cart = consolidate_cart(cart)

  #apply coupon method
  cart = apply_coupons(cart, coupons)

  #apply clearance
  cart = apply_clearance(cart)

  #iterate through cart, increment total_cost by item price
  cart.each do |item, item_values|
    item_values.each do |char, char_value|
      if char == :price
        total_cost += char_value
      end 
    end 
  end 

               binding.pry           
  #if statement to determine if cart total > $100, if yes apply 10% discount.
  if (total_cost > 100)
    total_cost = (total_cost*0.9)
  end 
  
  total_cost
end
