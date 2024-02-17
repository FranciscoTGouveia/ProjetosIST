#!/usr/bin/python3
import psycopg2
import cgi
import login
import aux
aux.print_init_page("What Customer are you?")
connection = None
form = cgi.FieldStorage()
try:
    # Creating connection
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()
    
    # See if there is any customer to insert on db
   
    cust_no = form.getvalue('cust_no')
    if cust_no :
        sql = 'SELECT cust_no FROM customer WHERE cust_no = %(blob)s;'
        cursor.execute(sql,{'blob':cust_no})
        result = cursor.fetchall()
        if len(result) != 0 :
            print('<meta http-equiv="refresh" content="0;URL=\'http://web2.tecnico.ulisboa.pt/ist1103168/order.cgi?order_no = {}'">".format(cust_no))
        # Getting new product information

    print('<form method="post" action="start_order.cgi">')
    print('<label for="cust_no">What is your Client Number?</label>')
    print('<input type="text" id="cust_no" name="cust_no"><br><br>')
    print('<input type="submit" value="Submit">')
    print('</form>')
    # Go Back Button
    print('<button type="button"><a href="main.cgi">Go Back to Main Menu</a></button>')

    
    cursor.close()

except Exception as e:
    # Print errors on the webpage if they occur
    print('<h1>An error occurred.</h1>')
    print('<p>{}</p>'.format(e))

finally:
    if connection is not None:
        connection.close()

print('</body>')
print('</html>')
