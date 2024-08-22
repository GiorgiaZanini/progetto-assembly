.section .data
    array: .long 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0


.section .text
    .global bubble_sort
    .type bubble_sort, @function
    
    bubble_sort:
        