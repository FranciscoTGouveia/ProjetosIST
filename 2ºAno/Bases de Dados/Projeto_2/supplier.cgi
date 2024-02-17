#!/usr/bin/python3
import psycopg2
import cgi
import login
import aux
import re
from datetime import datetime
aux.print_init_page("Register a new Supplier:")
connection = None
form = cgi.FieldStorage()
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()
    
    # See if there is any customer to insert on db
    tin = form.getvalue('tin')
    name = form.getvalue('name')
    sku = form.getvalue('sku')
    address = form.getvalue('address')
    address_pattern = r'^[A-Za-zÀ-ÿ\s]+ \d{4}-\d{3} [A-Za-zÀ-ÿ\s]+$'
    sdate = datetime.now()

    if not (tin and sku):

        print('<form method="post" action="supplier.cgi"')

        print('<label for="tin">Supplier TIN:</label>')
        print('<input type="text" id="tin" name="tin" required><br><br>')

        print('<label for="name">Supplier Name:</label>')
        print('<input type="text" id="name" name="name" required><br><br>')

        print('<label for="sku">Supplier associated SKU:</label>')
        print('<input type="text" id="sku" name="sku" required ><br><br>')

        print('<label for="address">Supplier Address:</label>')
        print('<input type="text" id="address" name="address" required><br><br>')

        print('<input type="submit" value="Submit">')
        print('</form>')

    else:
        if re.match(address_pattern, address):
            sql = 'INSERT INTO supplier (TIN, name, address, SKU, sdate) values (%s, %s, %s, %s, %s)';
            cursor.execute(sql, (tin, name, address, sku, sdate))
            connection.commit()
            print('<h3>Supplier {} sucessfully added</h3>'.format(tin))
            print('<button type="button"><a href="supplier.cgi">Add another Supplier</a></button>')
        else:
            print('<h3>Adress was not Portuguese, it needs to be int he Format XXXX-XXXX "CITY" </h3>')
            print('<button type="button"><a href="supplier.cgi">Try Again</a></button>')
    
    print('<button type="button"><a href="main.cgi">Go Back to Main Menu</a></button>')
    
    # Closing connection
    cursor.close()

except Exception as e:
    # Print errors on the webpage if they occur
    print('<h3>One of the input values was incorrect</h3>')
    print('<button type="button"><a href="supplier.cgi">Try Again</a></button>')

finally:
    if connection is not None:
        connection.close()

print('</body>')
print('</html>')
