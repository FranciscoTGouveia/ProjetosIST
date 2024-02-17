#!/usr/bin/python3
import psycopg2
import cgi
import login
import aux
aux.print_init_page("Pay an Order:")
connection = None
form = cgi.FieldStorage()
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()
    
    # See if there is any customer to insert on db
    cust_no = form.getvalue('cust_no')
    order_no = form.getvalue('order_no')
    if (cust_no and order_no):
        # Making query
        sql = 'INSERT INTO pay (cust_no, order_no) VALUES (%s, %s);'
        cursor.execute(sql, (cust_no, order_no))
        connection.commit()
        print('<h3>Order number {} paid sucessfully </h3>'.format(order_no))
        print('<button type="button"><a href="payorder.cgi">Pay another order</a></button>')
    else:
        print('<form method="post" action="payorder.cgi"')
        print('<label for="cust_no">Customer Number:</label>')
        print('<input type="text" id="cust_no" name="cust_no" required><br><br>')
        print('<label for="order_no">Order Number:</label>')
        print('<input type="text" id="order_no" name="order_no" required><br><br>')
        print('<input type="submit" value="Submit">')
        print('</form>')
    
    # Closing connection
    aux.finish_page(cursor)

except Exception as e:
    # Print errors on the webpage if they occur
    print('<h3>One of the input values was incorrect</h3>')
    print('<button type="button"><a href="payorder.cgi">Try Again</a></button>')

finally:
    if connection is not None:
        connection.close()

print('</body>')
print('</html>')
