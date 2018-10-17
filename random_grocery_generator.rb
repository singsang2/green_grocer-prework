require_relative 'grocer'

def items
	[
		{"AVOCADO" => {:price => 3.00, :clearance => true}},
		{"KALE" => {:price => 3.00, :clearance => false}},
		{"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
		{"ALMONDS" => {:price => 9.00, :clearance => false}},
		{"TEMPEH" => {:price => 3.00, :clearance => true}},
		{"CHEESE" => {:price => 6.50, :clearance => false}},
		{"BEER" => {:price => 13.00, :clearance => false}},
		{"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
		{"BEETS" => {:price => 2.50, :clearance => false}}
	]
end

def coupons
	[
		{:item => "AVOCADO", :num => 2, :cost => 5.00},
		{:item => "BEER", :num => 2, :cost => 20.00},
		{:item => "CHEESE", :num => 3, :cost => 15.00}
	]
end

def generate_cart
	[].tap do |cart|
		rand(20).times do
			cart.push(items.sample)
		end
	end
end

def generate_coupons
	[].tap do |c|
		rand(2).times do
			c.push(coupons.sample)
		end
	end
end

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
  puts consolidated
end

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
      cart.values[:price] *= 0.8
    end
  end
  cart
end
  
  
def checkout(cart)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearnace0
  
  total = 0
  
  cart.each{|item, h| total += h[:price]*h[:count]}
  
  if total > 100
    total *= 0.9
  else
    total
  end
end
  
cart = generate_cart
coupons = generate_coupons
consolidate_cart(cart)
puts "Items in cart"
# cart.each do |item|
# 	puts "Item: #{item.keys.first}"
# 	puts "Price: #{item[item.keys.first][:price]}"
# 	puts "Clearance: #{item[item.keys.first][:clearance]}"
# 	puts "=" * 10
# end


# puts "Coupons on hand"
# coupons.each do |coupon|
# 	puts "Get #{coupon[:item].capitalize} for #{coupon[:cost]} when you by #{coupon[:num]}"
# end

# puts "Your total is #{checkout(cart: cart, coupons: coupons)}"