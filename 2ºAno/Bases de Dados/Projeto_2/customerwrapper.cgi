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
    print('<button type="button" class="square" ><a href="customer.cgi">Create a Customer</a></button>')
    print('<button type="button" class="square" ><a href="dcustomer.cgi">Delete a Customer</a></button>')
    print('</div>')
    aux.finish_page(None)
except Exception as e:
    print('<h1>An error occurred.</h1>')
    print('<p>{}</p>'.format(e))
finally:
    if connection is not None:
        connection.close()
print('</body>')
print('</html>')
