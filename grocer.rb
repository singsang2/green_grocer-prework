
def consolidate_cart(cart)
  consolidated = {}
  cart.each do |item|
    if !consolidated.keys.include?(item.keys.first)
      consolidated[item.keys.first] = item.values.first
    end
    if consolidated[item.keys.first].keys.include?(:count)
      consolidated[item.keys.first][:count] += 1
    else
      consolidated[item.keys.first][:count] = 1
    end
  end
  consolidated
end

def apply_coupons(cart, coupons)
  counter = 0
  while counter < coupons.length
    name = coupons[counter][:item]
    if cart.keys.include?(name)
      if cart[name][:count] >= coupons[counter][:num]
        cart["#{name} W/COUPON"] = {price: coupons[counter][:cost], clearance: cart[name][:clearance], count: cart[name][:count]/coupons[counter][:num]}
        cart[name][:count] = cart[name][:count] % coupons[counter][:num]
      end
    end
    counter +=1 
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, hash|
    if hash[:clearance]
      hash[:price] = (0.8*hash[:price]).round(2)
    end
  end
  cart
end
  
  
def checkout(cart, coupons)
  
  new_cart = apply_coupons(consolidate_cart(cart), coupons)
  new_cart = apply_clearance(new_cart)
  
  total = 0
  
  new_cart.each{|item, h| total += h[:price]*h[:count]}
  
  if total > 100
    total *= 0.9
  else
    total
  end
end