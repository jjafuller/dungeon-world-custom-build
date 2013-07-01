#! /usr/bin/env python

# -*- coding: utf-8 -*-
import sys
import codecs
from bs4 import BeautifulSoup

soup = BeautifulSoup(open(sys.argv[1]))

for table in soup.find_all('stattable'):
    cols = int(table['aid:tcols'])
    cells = []

    for tag in table.children:
        header = True if (len(tag.find_all('tableheader')) > 0) else False
        cells.append({ 'header': header, 'value': tag.contents[0].string, 'width': int(float(tag['aid:ccolwidth']) * 1.5) })
    
    tbody = '<tr>'

    count = 0

    for idx, cell in enumerate(cells):
        if(cell['header']):
            tbody += '<th style="width:' + str(cell['width']) + 'px;">' + cell['value'] + '</th>'
        else:
            tbody += '<td style="width:' + str(cell['width']) + 'px;">' + cell['value'] + '</td>'
        count += 1
        
        if(count == cols):
            tbody += '</tr><tr>'
            count = 0
    
    tbody += '</tr>'

    tbody = BeautifulSoup(tbody)

    table.clear()
    del table['xmlns:aid']
    del table['aid:table']
    del table['aid:trows']
    del table['aid:tcols']

    table.name = 'table'
    table['border'] = 0
    table['cellspacing'] = 0
    table['cellpadding'] = 3

    table.append(tbody)

    with codecs.open(sys.argv[1], 'w', 'utf-8') as f:
        f.write(soup.prettify())
