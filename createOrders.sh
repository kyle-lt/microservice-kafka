#!/bin/bash

# Create 4 Orders
echo "Creating 4 Orders"

# 1 iPod
echo "Ordering 1 iPod"
curl -d "customer=5&shippingAddress.street=301+Saddlehorn+Dr&shippingAddress.zip=78620-2740&shippingAddress.city=Dripping+Springs&billingAddress.street=301+Saddlehorn+Dr&billingAddress.zip=78620-2740&billingAddress.city=Dripping+Springs&orderLine%5B0%5D.count=1&orderLine%5B0%5D.item=1&submit=" -X POST http://localhost:8080/order/

# 2 iPods
echo "Ordering 2 iPods"
curl -d "customer=5&shippingAddress.street=301+Saddlehorn+Dr&shippingAddress.zip=78620-2740&shippingAddress.city=Dripping+Springs&billingAddress.street=301+Saddlehorn+Dr&billingAddress.zip=78620-2740&billingAddress.city=Dripping+Springs&orderLine%5B0%5D.count=2&orderLine%5B0%5D.item=1&submit=" -X POST http://localhost:8080/order/

# 1 Apple TV
echo "Ordering 1 Apple TV"
curl -d "customer=5&shippingAddress.street=301+Saddlehorn+Dr&shippingAddress.zip=78620-2740&shippingAddress.city=Dripping+Springs&billingAddress.street=301+Saddlehorn+Dr&billingAddress.zip=78620-2740&billingAddress.city=Dripping+Springs&orderLine%5B0%5D.count=1&orderLine%5B0%5D.item=4&submit=" -X POST http://localhost:8080/order/

# 2 Apple TVs
echo "Ordering 2 Apple TVs"
curl -d "customer=5&shippingAddress.street=301+Saddlehorn+Dr&shippingAddress.zip=78620-2740&shippingAddress.city=Dripping+Springs&billingAddress.street=301+Saddlehorn+Dr&billingAddress.zip=78620-2740&billingAddress.city=Dripping+Springs&orderLine%5B0%5D.count=2&orderLine%5B0%5D.item=4&submit=" -X POST http://localhost:8080/order/

exit 0
