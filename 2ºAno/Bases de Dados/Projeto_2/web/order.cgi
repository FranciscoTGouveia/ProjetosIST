#!/usr/bin/python3
import psycopg2
import cgi
import login
import aux
print('Content-type:text/html\n\n')
print('<html>')
print('<head>')
print("""<style>body {
  background-image: url('background.png');
  font-family: Arial, sans-serif;
  background-repeat: no-repeat;
  background-position: center;
  background-size: cover;
}
button {
  display: flex;
  align-items: center;
}
table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 10px;
  margin-top: 10px; /* Add margin at the top */
  max-height: calc(100vh - 200px); /* Adjust the value as needed */
  overflow-y: auto; /* Add vertical scroll if necessary */
}
h1, h2, h3, h4, h5, h6 {
  text-align: center;
}

/* Add row background colors */
tr {
  background-color: #a3b4b8;
}

/* Add hover effect on table rows */
tr:hover {
  background-color: #f0f0f0;
}
p {text-align:center;}
</style>
""")
print('<title>PRF Trading</title>')
print('</head>')
print('<body>')
print('<h1>Create an Order:</h1>')
connection = None
form_cust = cgi.FieldStorage()
form = cgi.FieldStorage()
try:
    connection = psycopg2.connect(login.credentials)
    cursor = connection.cursor()

    cust_no = form.getvalue('cust_no')

    sql = 'SELECT SKU, name, price FROM product;'
    cursor.execute(sql)
    result = cursor.fetchall()
    num = len(result)

    # Displaying results
    print('<form method="post" action="process.cgi">')  # Add a form tag to display the submitted values
    print('<label for="cust_no">Please input your number:</label>')
    print('<input type="text" id="cust_no" name="cust_no" required><br><br>')
    print('<table border="5">')
    print('<tr><th>SKU</th><th>Name</th><th>Price</th><th>Quantity</th></tr>')
    for row in result:
        print('<tr>')
        for value in row:
            print('<td>{}</td>'.format(value))
        print('<td>')
        sku = row[0]
        quantity_name = '{}'.format(sku)  # Construct the name of the quantity input field
        print('<input type="number" name="{}" min="0" value="0"><br><br>'.format(quantity_name))  # Display the quantity input field
        print('</td>')
        print('</tr>')
    print('</table>')
    print('<input type="submit" value="Submit">')  # Add a submit button to the form
    print('</form>')  # Close the form tag
    aux.finish_page(cursor)
except Exception as e:
    # Print errors on the webpage if they occur
    print('<h3>One of the input values was incorrect</h3>')
    print('<button type="button"><a href="order.cgi">Try Again</a></button>')

finally:
    if connection is not None:
        connection.close()
print('</body>')
print('</html>')
