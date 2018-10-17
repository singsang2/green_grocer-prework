
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
puts consolidate_cart([{"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
      {"BEETS" => {:price => 2.50, :clearance => false}},
      {"SOY MILK" => {:price => 4.50, :clearance => true}}])

def apply_coupons(cart, coupons)
  counter = 0
  while counter < coupons.length
    if cart.keys.include?(coupons[counter][:item])
      if cart[coupons[counter][:item]][:count] >= coupons[counter][:num]
        cart["#{coupons[counter][:item]} W/COUPON"] = {price: coupons[counter][:cost], clearance:cart[coupons[counter][:item]][:clearance], count: cart[coupons[counter][:item]][:count]/coupons[counter][:num]}
        if cart[coupons[counter][:item]][:count]%coupons[counter][:num]==0
          cart.delete(coupons[counter][:item])
        else
          cart[coupons[counter][:item][:count]] = cart[coupons[counter][:item]][:count]%coupons[counter][:num]
        end
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