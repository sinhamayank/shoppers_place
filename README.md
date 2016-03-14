# shoppers_place
ruby 2.1.3p242, Rails 4.1.0
Database: Postgres
database name - shoppers_place
username - postgres
password - india

Steps:
sudo apt-get update
sudo apt-get install nodejs
bundle install
rake db:migrate

1)   Rails application which expose public interface
Public API Interface responds to the following requests:
[POST] /api/v1/products.json
Based on RESTful paradigm POST request makes persistent data 
which are being sent in this request.
Format of the request is:
{
    "endpoint_name": "api/v1/products.json",
    "method": "POST",
    "parameters": {
     "expire_date": "2016­09­05",
     "name": "Black Jacket",
     "sku_id": 1234,
     "categories": [
   
 "jackets",
   
 "mens­wear"
     ],
     "tags": [
   
 "black",
   
 "jacket",
   
 "leather"
     ],
     "images": [
   
 {
   
 "img_path": "http://xxx.png"
   
 },
   
 {
   
 "img_path": "http://yyy.png"
   
 }
     ],
     "price": 1000
    }
}

● A product is created / edited using the same url

2) Backoffice listing of products
As an Admin I am able to see the list of products by using 
following url: 'host/admin/products'
Listing represents the following set of columns:
• name
• SKU_ID
• price
• thumbnail of the first picture

3) Backoffice editing product
As an Admin I am able to choose specific 'product' by clicking 
on its name and see a page where I can edit fields.
Notes:  
1.non­editable fields: images
