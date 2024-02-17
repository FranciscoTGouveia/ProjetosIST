def print_init_page(blob):
    print('Content-type:text/html\n\n')
    print('<html>')
    print('<head>')
    print('<link rel="stylesheet" type="text/css" href="styles.css">')
    print('<title>PRF Trading</title>')
    print('</head>')
    print('<body>')
    print('<h1>{}</h1>'.format(blob))

def finish_page(cursor):
 # Go Back Button
    print('<button type="button"><a href="main.cgi">Go Back to Main Menu</a></button>')
    # Closing connection
    if cursor is not None:
        cursor.close()
