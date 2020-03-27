def find_item_by_name_in_collection(name, collection)
  collection.each do |item_info|
    if item_info[:item] == name
      return item_info
    end #if
  end #each
  nil
end


def consolidate_cart(cart)
  new_cart = []
  cart.each do |cart_item|
    item_name = cart_item[:item]
    item_info = find_item_by_name_in_collection(item_name, new_cart)
    if item_info
      item_info[:count] += 1
    else
      new_cart << {
        :item => item_name,
        :price => cart_item[:price],
        :clearance => cart_item[:clearance],
        :count => 1
      }
    end #if
  end #each
  new_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item_info = find_item_by_name_in_collection(coupon[:item], cart)
	  if item_info and item_info[:count] >= coupon[:num]
      cart << {
        :item => coupon[:item] + " W/COUPON",
        :price => (coupon[:cost]/coupon[:num]).round(2),
        :clearance => item_info[:clearance],
        :count => coupon[:num]
      }
      item_info[:count] -= coupon[:num]
    end #if
  end #each
  cart
end

def apply_clearance(cart)
  cart.each do |item_info|
    if item_info[:clearance]
      item_info[:price] *= 0.8
    end
  end
  cart
end

def checkout(cart, coupons)
  consol_cart = consolidate_cart(cart)
  cart_w_coupons_applied = apply_coupons(consol_cart, coupons)
  final_cart = apply_clearance(cart_w_coupons_applied)

  total = 0
  final_cart.each do |item_info|
    total += item_info[:price]*item_info[:count]
  end #each

  if total > 100
    total *= 0.9
  end #if
  return total.round(2)
end
