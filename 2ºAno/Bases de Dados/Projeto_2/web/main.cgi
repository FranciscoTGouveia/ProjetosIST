#!/usr/bin/python3
import psycopg2
import login
import aux
aux.print_init_page("Database Management Interface:")
connection = None
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    print('<div class="container">')
    print('<button type="button" class="square" ><a href="payorder.cgi">Pay an Order</a></button>')
    print('<button type="button" class="square" ><a href="order.cgi">Execute an Order</a></button>')
    print('<button type="button" class="square" ><a href="customerwrapper.cgi">Client Management</a></button>')
    print('<button type="button" class="square" ><a href="updateproducts.cgi">Update a Product</a></button>')
    print('<button type="button" class="square" ><a href="productwrapper.cgi">Product Management</a></button>')
    print('<button type="button" class="square" ><a href="supplierwrapper.cgi">Supplier Management</a></button>')
    print('</div>')
except Exception as e:
    print('<h3>An error occurred.</h3>')
    print('<p>{}</p>'.format(e))
finally:
    if connection is not None:
        connection.close()
print('</body>')
print('</html>')
