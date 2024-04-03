import png
from PIL import Image  # Bibliothek zum be-/verarbeiten von Bilder



images = ['1.png', '1 - Kopie.png', '1.png', '2.png', '1.png', '2.png', '3.png', '3.png', '3.png']

widths = []
heights = []

for i in range(9):
    w, h, p, m = png.Reader(filename=images[i]).read_flat()
    widths.append(w)
    heights.append(h)

# print(w)
stand_pixelsize = 25
width = max(widths[0], widths[3], widths[6]) + max(widths[1], widths[4], widths[7]) + max(widths[0], widths[3], widths[6])
height = width

avg_widths = [max(widths[0], widths[3], widths[6]), max(widths[1], widths[4], widths[7]), max(widths[0], widths[3], widths[6])] 
            #   max(widths[0], widths[3], widths[6]), max(widths[1], widths[4], widths[7]), max(widths[0], widths[3], widths[6]), 
            #   max(widths[0], widths[3], widths[6]), max(widths[1], widths[4], widths[7]), max(widths[0], widths[3], widths[6])]

new_im = Image.new('RGBA', (width, height))

def copy_image(image, offset_x=0, offset_y=0):
    for i in range(0, width, height):
        im = Image.open(image)
        new_im.paste(im, (i + offset_x, offset_y))

for i in range(9):
    y_offset = 0
    x_offset = 0
    if widths[i] != avg_widths[int((i)/3)]:
        y_offset = int((avg_widths[int((i)/3)]/widths[i]-1)/2*avg_widths[int((i)/3)]-widths[i]*2)
    if widths[i] != avg_widths[(i)%3]:
        x_offset = int((avg_widths[(i)%3]/widths[i]-1)/2*avg_widths[(i)%3]-widths[i]*2)
    x_pre_offset = int(i%3)
    y_pre_offset = int(i/3)
    # if x_pre_offset == 0:
    #     x_offset = x_offset 
    if x_pre_offset == 1:
        x_offset = x_offset + avg_widths[0]
    if x_pre_offset == 2:
        x_offset = x_offset + avg_widths[0] + avg_widths[1]
    # if y_pre_offset == 0:
    #     y_offset = y_offset
    if y_pre_offset == 1:
        y_offset = y_offset + avg_widths[0]
    if y_pre_offset == 2:
        y_offset = y_offset + avg_widths[0] + avg_widths[1]
    copy_image(images[i], x_offset, y_offset)

new_im.save('output.png')
