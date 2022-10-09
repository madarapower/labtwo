(define (problem build)
  (:domain build)
  (:objects
    p_technician - person ; технарь умеет собирать компьютер
    p_guard - person ; охранник умеет давать разрешения
    p_porter - person ; грузчик умеет двигать предметы со склада
    
    r_storage - location ; склад
    r_transfer_room - location  ; комната передачи
    r_server_room  - location ; серверная комната
    r_security_office - location ; комната охранника
    
    p_parts_hold - permissions ; разрешение держать компьютерные детали
    p_security_hold - permissions ; разрешение держать предметы охраны
    p_be_in_server_room - permissions ; разрешение быть в серверной комнате
    p_be_in_security - permissions ; разрешение быть в комнате охранника
    p_be_in_storage - permissions ; разрешение быть на складе
    p_be_in_transfer - permissions ; разрешение быть в комнате передачи
    
    c_box - container ; коробка, в которой изначально детали
    c_case  - container ; корпус, в который нужно положить детали
    c_locker  - container ; ящик с предметами охранника
    i_gpu - item
    i_psu - item
    i_cpu - item
    i_ram - item
    i_mbd - item
    i_key - item  ; ключ, который надо положить в компьютер помимо деталей
    
    cat_computer_part - category  ; категория "компьютерные запчасти"
    cat_security_item - category  ; категория "предмет охраны"
    
    )

  (:init 

        ; есть связь между серверной и комнатой передачи
        (adjacent r_server_room r_transfer_room)
        (adjacent r_transfer_room r_server_room)

        ; есть связь между комнатой передачи и складом
        (adjacent r_transfer_room r_storage)
        (adjacent r_storage r_transfer_room)

        ; есть связь между комнатой передачи и комнатой охранника
        (adjacent r_transfer_room r_security_office)
        (adjacent r_security_office r_transfer_room)

        ; существует разрешение, которое дает право держать компьютерные детали
        (permission_to_take p_parts_hold cat_computer_part)

        ; существует разрешение, которое дает право держать предметы охраны
        (permission_to_take p_security_hold cat_security_item)
        
        ; существует разрешение, которое дает право быть в серверной
        (permission_to_walk p_be_in_server_room r_server_room)

        ; существует разрешение, которое дает право быть в комнате охранника
        (permission_to_walk p_be_in_security r_security_office)

        ; существует разрешение, которое дает право быть на складе
        (permission_to_walk p_be_in_storage r_storage)

        ; существует разрешение, которое дает право быть в комнате передачи
        (permission_to_walk p_be_in_transfer r_transfer_room)


        ; технарь может держать компьютерные детали, и это право можно передавать
        (has_permissions p_technician p_parts_hold)
        (is_transferrable p_parts_hold)
        
        ; технарь может быть в серверной комнате, и это право нельзя передавать
        (has_permissions p_technician p_be_in_server_room)
        
        ; грузчик может быть на складе, и это право нельзя передавать
        (has_permissions p_porter p_be_in_storage)
        
        ; охранник может быть в каждой комнате
        (has_permissions p_guard p_be_in_storage)
        (has_permissions p_guard p_be_in_server_room)
        (has_permissions p_guard p_be_in_security)
        
        ; охранник имеет право быть в комнате передачи, и это право можно передавать
        (has_permissions p_guard p_be_in_transfer)
        (is_transferrable p_be_in_transfer)
        
        ; охранник может держать предметы охраны, и это право нельзя передавать
        (has_permissions p_guard p_security_hold)


        ; изначально все детали в коробке
        (at c_box i_gpu)
        (at c_box i_psu)
        (at c_box i_cpu)
        (at c_box i_ram)
        (at c_box i_mbd)
        ; все детали являются деталями
        (item_has_type i_gpu cat_computer_part)
        (item_has_type i_psu cat_computer_part)
        (item_has_type i_cpu cat_computer_part)
        (item_has_type i_ram cat_computer_part)
        (item_has_type i_mbd cat_computer_part)
        ; коробка находится на складе
        (large_at r_storage c_box)
        ; ключ -- это предмет охраны и хранится в ящике охранника в комнате охраны
        (item_has_type i_key cat_security_item)
        (at c_locker i_key)
        (large_at r_security_office c_locker)

        ; в серверной комнате находится корпус, в нем ничего нет
        (large_at r_server_room c_case)

        ; технарь находится в серверной комнате
        (large_at r_server_room p_technician)
        ; грузчик находится на складе
        (large_at r_storage p_porter)
        ; охранник находится в комнате охраны
        (large_at r_security_office p_guard)





  
        ; изначально у всех в руках пусто
        (person_hands_empty p_technician)
        (person_hands_empty p_guard)
        (person_hands_empty p_porter)
        




        
        
        


        )
  (:goal (and 

        

            ; все детали в корпусе
            (at c_case i_gpu)
            (at c_case i_psu)
            (at c_case i_cpu)
            (at c_case i_ram)
            (at c_case i_mbd)

            ; ключ в корпусе
            (at c_case i_key)

            ; технарь в серверной комнате
            (large_at r_server_room p_technician)

            ; грузчик на складе
            (large_at r_storage p_porter)

            ; охранник в комнате охраны
            (large_at r_security_office p_guard)


        
    )
)
)

