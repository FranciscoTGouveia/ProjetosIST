#!/usr/bin/python3
import psycopg2
import cgi
import login
import re
import aux
aux.print_init_page("Register a new Customer:")
connection = None
form = cgi.FieldStorage()
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()
    
    # See if there is any customer to insert on db
    cnumber = form.getvalue('cnumber')
    name = form.getvalue('name')
    email = form.getvalue('email')
    phone = form.getvalue('phone')
    address = form.getvalue('address')
    address_pattern = r'^[A-Za-zÀ-ÿ\s]+ \d{4}-\d{3} [A-Za-zÀ-ÿ\s]+$'
    email_pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$'
    if (not(cnumber and name and email and phone and address)):
        print('<form method="post" action="customer.cgi"')

        print('<label for="cnumber">Customer Number:</label>')
        print('<input type="text" id="cnumber" name="cnumber" required><br><br>')

        print('<label for="name">Customer Name:</label>')
        print('<input type="text" id="name" name="name" required><br><br>')

        print('<label for="email">Customer Email:</label>')
        print('<input type="email" id="email" name="email" required><br><br>')

        print('<label for="phone">Customer Phone Number:</label>')
        print('<input type="text" id="phone" name="phone" required><br><br>')

        print('<label for="address">Customer Address:</label>')
        print('<input type="text" id="address" name="address" required><br><br>')

        print('<input type="submit" value="Submit">')
        print('</form>')
        
    elif(not(re.match(address_pattern, address))):
        print('<h3>Adress was not Portuguese, it needs to be int he Format XXXX-XXXX "CITY" </h3>')
        print('<button type="button"><a href="customer.cgi">Try Again</a></button>')
    elif(not(re.match(email_pattern,email))):
        print('<h3>The email was not correctly indicated, must be in the form "XXX"@"XXX"."XXX" </h3>')
        print('<button type="button"><a href="customer.cgi">Try Again</a></button>')

    else:
        # Making query
        sql = 'INSERT INTO customer (cust_no, name, email, phone, address) values (%(cust_no)s,%(name)s, %(email)s, %(phone)s, %(address)s);'
        cursor.execute(sql, {'cust_no':cnumber, 'name':name,'email':email, 'phone':phone,'address': address})
        connection.commit()
        print('<h3>Customer number {} added sucessfully </h3>'.format(cnumber))
        print('<button type="button"><a href="customer.cgi">Add another customer</a></button>')
    
    # Getting new customer information
    aux.finish_page(cursor)

except Exception as e:
    # Print errors on the webpage if they occur
    print('<h3>One of the input values was incorrect</h3>')
    print('<button type="button"><a href="customer.cgi">Try Again</a></button>')

finally:
    if connection is not None:
        connection.close()

print('</body>')
print('</html>')
