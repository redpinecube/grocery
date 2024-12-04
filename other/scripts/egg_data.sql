SELECT id, vendor, brand, product_name, nowtime, current_price
FROM product JOIN raw ON product.id = raw.product_id
WHERE units = '12 eggs';
