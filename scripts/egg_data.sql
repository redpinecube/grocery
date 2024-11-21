SELECT id, vendor, brand, product_name,
       units, now_time, current_price 
FROM product JOIN raw ON product.id = raw.product_id