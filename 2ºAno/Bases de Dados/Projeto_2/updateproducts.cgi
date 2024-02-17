#!/usr/bin/python3
import psycopg2
import cgi
import login
import aux
aux.print_init_page("Update a Product:")
connection = None
form = cgi.FieldStorage()
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()
    
    # See if there is any customer to insert on db
    sku = form.getvalue('sku')
    description = form.getvalue('description')
    price = form.getvalue('price')
    if (not sku) or (not description and not price):
        if (sku and not description and not price):
            print('<h2>Please fill all the information for the product you want to update</h2>')
        print('<form method="post" action="updateproducts.cgi"')
        print('<label for="sku">Product Sku:</label>')
        print('<input type="text" id="sku" name="sku" required ><br><br>')
        print('<label for="description">Product Description:</label>')
        print('<input type="text" id="description" name="description"><br><br>')
        print('<label for="price">Product Price:</label>')
        print('<input type="text" id="price" name="price"><br><br>')
        print('<input type="submit" value="Submit">')
        print('</form>')
    else:
        sql = 'SELECT * FROM product WHERE product.SKU = %(sku)s ;'
        cursor.execute(sql,{'sku':sku})
        result = cursor.fetchall()

        if len(result):
            if (description and not price):
                # Making update query
                sql = 'UPDATE product SET description = %s WHERE SKU = %s'
                cursor.execute(sql, (description, sku))
                connection.commit()
            elif (price and not description):
                # Making update query
                sql = 'UPDATE product SET price = %s WHERE SKU = %s'
                cursor.execute(sql, (price, sku))
                connection.commit()
            elif (description and price):
                # Making update query
                sql = 'UPDATE product SET description = %s, price = %s WHERE SKU = %s'
                cursor.execute(sql, (description, price, sku))
                connection.commit()
            print('<h3>Product {} sucessfully update</h3>'.format(sku))
            print('<button type="button"><a href="updateproducts.cgi">Update another product</a></button>')
        else:
            print('<h3>Product {} does not exist</h3>'.format(sku))
            print('<button type="button"><a href="updateproducts.cgi">Try Again</a></button>')
        
    # Getting product update information
    # Go Back Button
    print('<button type="button"><a href="main.cgi">Go Back to Main Menu</a></button>')
    
    # Closing connection
    cursor.close()

except Exception as e:
    # Print errors on the webpage if they occur
    print('<h3>One of the input values was incorrect</h3>')
    print('<button type="button"><a href="updateproducts.cgi">Try Again</a></button>')

finally:
    if connection is not None:
        connection.close()

print('</body>')
print('</html>')
