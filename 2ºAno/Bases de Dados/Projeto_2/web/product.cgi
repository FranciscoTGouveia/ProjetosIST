#!/usr/bin/python3
import psycopg2
from datetime import datetime
import cgi
import login
import aux
import re

aux.print_init_page("Register a new Product:")
connection = None
form = cgi.FieldStorage()
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()
    
    # See if there is any customer to insert on db
   
    
    # Getting new product information
    
    TIN= form.getvalue('TIN')

    if TIN :
        name = form.getvalue('name')
        address = form.getvalue('address')
        SKU = form.getvalue('SKU')
        address_pattern = r'^[A-Za-zÀ-ÿ\s]+ \d{4}-\d{3} [A-Za-zÀ-ÿ\s]+$' 
        if re.match(address_pattern, address):
            sku = form.getvalue("sku")
            sdate = datetime.now()

            insert = True
            if (sku != None):
                price = form.getvalue('price')
                ean = form.getvalue('ean')
                description = form.getvalue('description')
                product_name = form.getvalue('product_name')
                if( sku != SKU) or (price == None) or (product_name == None) :
                    insert = False
                    print('<h1>The product values inputed were not coherent with the supplier </h1>')
                    connection.rollback()
                    print('<button type="button"><a href="product.cgi">Try again</a></button>')
                else:
                    sql = 'INSERT INTO product (SKU,name,description,ean,price) values (%(sku)s, %(name)s, %(description)s, %(ean)s, %(price)s);'
                    cursor.execute(sql, {'sku':sku,'name':product_name,'description':description,'ean':ean,'price':price})
                    connection.commit()
                    print('<h1>Product {} added sucessfully</h1>'.format(sku))
            if insert:
                sql = 'INSERT INTO supplier (name,SKU,sdate,TIN,address) values (%(name)s, %(SKU)s, %(sdate)s, %(TIN)s, %(address)s);'
                cursor.execute(sql, {'name':name,'SKU':SKU,'sdate':sdate,'TIN':TIN,'address':address})
                connection.commit()
                print('<h1>Supplier {} added sucessfully</h1>'.format(TIN))
                print('<button type="button"><a href="productwrapper.cgi">Go back to the Product Menu</a></button>')
        else:
            print('<h1>Adress was not Portuguese, it needs to be int he Format XXXX-XXXX "CITY" </h1>')
            print('<button type="button"><a href="product.cgi">Try Again</a></button>')
            

    else:
        print('<form method="post" action="product.cgi">')

        print('<label for="sku">Product SKU:</label>')
        print('<input type="text" id="sku" name="sku"><br><br>')

        print('<label for="product_description">Product Description:</label>')
        print('<input type="text" id="description" name="description"><br><br>')

        print('<label for="product_price">Product Price:</label>')
        print('<input type="price" id="price" name="price"><br><br>')

        print('<label for="ean">Product EAN:</label>')
        print('<input type="text" id="ean" name="ean"><br><br>')

        print('<label for="product_name">Product Name:</label>')
        print('<input type="text" id="product_name" name="product_name"><br><br>')


        print('<h2>Insert Supplier</h2>')

        print('<label for="TIN">Supplier TIN:</label>')
        print('<input type="text" id="TIN" name="TIN" required><br><br>')

        print('<label for="address">Supplier Address:</label>')
        print('<input type="text" id="address" name="address" required><br><br>')

        print('<label for="name">Supplier Name:</label>')
        print('<input type="text" id="name" name="name" required><br><br>')

        print('<label for="SKU">SKU:</label>')
        print('<input type="text" id="SKU" name="SKU" required><br><br>')


        print('<input type="submit" value="Submit">')
        print('</form>')
        # Go Back Button
        print('<button type="button"><a href="main.cgi">Go Back to Main Menu</a></button>')

    
    # Closing connection
    cursor.close()

except Exception as e:
    # Print errors on the webpage if they occur
    print('<h3>One of the input values was incorrect</h3>')
    print('<button type="button"><a href="product.cgi">Try Again</a></button>')

finally:
    if connection is not None:
        connection.close()

print('</body>')
print('</html>')
